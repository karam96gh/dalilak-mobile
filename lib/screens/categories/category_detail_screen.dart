import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../constants/app_constants.dart';
import '../../providers/data_providers.dart';
import '../../models/listing_model.dart';
import '../../models/category_model.dart';
import '../../models/governorate_model.dart';
import '../../widgets/shimmer_skeletons.dart';

class CategoryDetailScreen extends ConsumerStatefulWidget {
  final int categoryId;

  const CategoryDetailScreen({
    Key? key,
    required this.categoryId,
  }) : super(key: key);

  @override
  ConsumerState<CategoryDetailScreen> createState() =>
      _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends ConsumerState<CategoryDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  final List<Listing> _allListings = [];

  int _currentPage = 1;
  int _totalItems = 0;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  bool _showScrollToTop = false;
  static const int _itemsPerPage = 20;

  int? _selectedSubcategoryId;
  int? _selectedLevel3Id;
  int? _selectedGovernorateId;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 300) {
      _loadMore();
    }
    final shouldShow = position.pixels > 400;
    if (shouldShow != _showScrollToTop) {
      setState(() => _showScrollToTop = shouldShow);
    }
  }

  void _loadMore() {
    if (_isLoadingMore || !_hasMore) return;
    setState(() {
      _isLoadingMore = true;
      _currentPage++;
    });
  }

  void _resetAndReload() {
    setState(() {
      _allListings.clear();
      _currentPage = 1;
      _hasMore = true;
      _isLoadingMore = false;
      _totalItems = 0;
    });
  }

  int get _effectiveCategoryId =>
      _selectedLevel3Id ?? _selectedSubcategoryId ?? widget.categoryId;

  bool get _hasActiveFilters =>
      _selectedSubcategoryId != null || _selectedGovernorateId != null;

  void _clearAllFilters() {
    setState(() {
      _selectedSubcategoryId = null;
      _selectedLevel3Id = null;
      _selectedGovernorateId = null;
    });
    _resetAndReload();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categoryAsync = ref.watch(categoryByIdProvider(widget.categoryId));
    final governoratesAsync = ref.watch(governoratesProvider);

    final listingsAsync = ref.watch(listingsProvider((
      page: _currentPage,
      limit: _itemsPerPage,
      categoryId: _effectiveCategoryId,
      governorateId: _selectedGovernorateId,
    )));

    // Accumulate results
    listingsAsync.whenData((response) {
      if (_currentPage == 1 && _allListings.isEmpty) {
        _allListings.addAll(response.data);
        _totalItems = response.total;
      } else if (_isLoadingMore) {
        final existingIds = _allListings.map((l) => l.id).toSet();
        final newItems =
            response.data.where((l) => !existingIds.contains(l.id)).toList();
        if (newItems.isNotEmpty) {
          _allListings.addAll(newItems);
        }
        _totalItems = response.total;
        _isLoadingMore = false;
      }
      _hasMore = _allListings.length < response.total;
    });

    return Scaffold(
      floatingActionButton: _showScrollToTop
          ? FloatingActionButton.small(
              onPressed: () {
                _scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOut,
                );
              },
              child: const Icon(Icons.arrow_upward_rounded),
            )
          : null,
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            // AppBar with category name
            SliverAppBar(
              title: categoryAsync.when(
                loading: () => const Text('التصنيف'),
                error: (_, __) => const Text('التصنيف'),
                data: (cat) => Text(cat.name),
              ),
              floating: true,
              snap: true,
              pinned: true,
              elevation: 0,
              actions: [
                // Governorate Dropdown
                governoratesAsync.when(
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                  data: (governorates) => _GovernorateDropdown(
                    governorates: governorates,
                    selectedId: _selectedGovernorateId,
                    onChanged: (id) {
                      setState(() => _selectedGovernorateId = id);
                      _resetAndReload();
                    },
                  ),
                ),
                const SizedBox(width: 8),
              ],
              // Subcategory chips (Level 2)
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(52),
                child: categoryAsync.when(
                  loading: () => const SizedBox(
                    height: 52,
                    child: Center(
                        child: LinearProgressIndicator(minHeight: 2)),
                  ),
                  error: (_, __) => const SizedBox(height: 52),
                  data: (category) {
                    if (category.children == null ||
                        category.children!.isEmpty) {
                      return const SizedBox(height: 0);
                    }
                    return _SubcategoryTabs(
                      subcategories: category.children!,
                      selectedId: _selectedSubcategoryId,
                      onSelected: (id) {
                        setState(() {
                          _selectedSubcategoryId = id;
                          _selectedLevel3Id = null;
                        });
                        _resetAndReload();
                      },
                    );
                  },
                ),
              ),
            ),

            // Level 3 subcategory chips
            if (_selectedSubcategoryId != null)
              SliverPersistentHeader(
                pinned: true,
                delegate: _StickyHeaderDelegate(
                  child: _Level3ChipsRow(
                    parentId: _selectedSubcategoryId!,
                    selectedId: _selectedLevel3Id,
                    onSelected: (id) {
                      setState(() => _selectedLevel3Id = id);
                      _resetAndReload();
                    },
                  ),
                ),
              ),

            // Results count + clear filters
            SliverToBoxAdapter(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                color: theme.scaffoldBackgroundColor,
                child: Row(
                  children: [
                    Text(
                      _allListings.isNotEmpty
                          ? '$_totalItems نتيجة'
                          : 'جاري التحميل...',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                      ),
                    ),
                    const Spacer(),
                    if (_hasActiveFilters)
                      GestureDetector(
                        onTap: _clearAllFilters,
                        child: Text(
                          'إعادة تعيين',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ];
        },
        // Listings list
        body: listingsAsync.when(
          loading: () {
            if (_allListings.isNotEmpty) {
              return _buildListingsView(theme);
            }
            return _buildLoadingSkeleton();
          },
          error: (error, stack) {
            if (_allListings.isNotEmpty) {
              return _buildListingsView(theme);
            }
            return _buildErrorWidget(theme);
          },
          data: (response) {
            if (_allListings.isEmpty && response.data.isEmpty) {
              return _buildEmptyWidget(theme);
            }
            return _buildListingsView(theme);
          },
        ),
      ),
    );
  }

  Widget _buildListingsView(ThemeData theme) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _allListings.length + (_hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _allListings.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        }
        return _ListingCard(
          listing: _allListings[index],
          onTap: () => context.push('/listing/${_allListings[index].id}'),
        );
      },
    );
  }

  Widget _buildLoadingSkeleton() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: 6,
      itemBuilder: (_, __) => const ListingCardSkeleton(),
    );
  }

  Widget _buildEmptyWidget(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_rounded, size: 72, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text('لا توجد محتويات', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            'جرّب تغيير الفلاتر أو اختيار قسم آخر',
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
          ),
          if (_hasActiveFilters) ...[
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: _clearAllFilters,
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة تعيين'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorWidget(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
          const SizedBox(height: 16),
          Text('حدث خطأ في تحميل البيانات',
              style: theme.textTheme.bodyMedium),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              ref.invalidate(categoryByIdProvider(widget.categoryId));
              _resetAndReload();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('إعادة محاولة'),
          ),
        ],
      ),
    );
  }
}

// ─── Governorate Dropdown ──────────────────────────────────────────

class _GovernorateDropdown extends StatelessWidget {
  final List<Governorate> governorates;
  final int? selectedId;
  final ValueChanged<int?> onChanged;

  const _GovernorateDropdown({
    required this.governorates,
    required this.selectedId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedName = selectedId == null
        ? 'كل المحافظات'
        : governorates
            .firstWhere((g) => g.id == selectedId,
                orElse: () => Governorate(id: 0, name: 'كل المحافظات'))
            .name;

    return PopupMenuButton<int?>(
      onSelected: onChanged,
      offset: const Offset(0, 48),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      itemBuilder: (context) => [
        PopupMenuItem<int?>(
          value: null,
          child: Row(
            children: [
              Icon(
                selectedId == null
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                size: 18,
                color:
                    selectedId == null ? theme.colorScheme.primary : Colors.grey,
              ),
              const SizedBox(width: 8),
              const Text('كل المحافظات'),
            ],
          ),
        ),
        const PopupMenuDivider(),
        ...governorates.map((g) => PopupMenuItem<int?>(
              value: g.id,
              child: Row(
                children: [
                  Icon(
                    selectedId == g.id
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    size: 18,
                    color: selectedId == g.id
                        ? theme.colorScheme.primary
                        : Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Text(g.name),
                ],
              ),
            )),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer.withOpacity(0.3),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.location_on_outlined,
                size: 16, color: theme.colorScheme.primary),
            const SizedBox(width: 4),
            Text(
              selectedName,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 2),
            Icon(Icons.arrow_drop_down,
                size: 18, color: theme.colorScheme.primary),
          ],
        ),
      ),
    );
  }
}

// ─── Subcategory Tabs (Level 2) ─────────────────────────────────────

class _SubcategoryTabs extends StatefulWidget {
  final List<Category> subcategories;
  final int? selectedId;
  final ValueChanged<int?> onSelected;

  const _SubcategoryTabs({
    required this.subcategories,
    required this.selectedId,
    required this.onSelected,
  });

  @override
  State<_SubcategoryTabs> createState() => _SubcategoryTabsState();
}

class _SubcategoryTabsState extends State<_SubcategoryTabs> {
  final Map<int?, GlobalKey> _tabKeys = {};

  @override
  void initState() {
    super.initState();
    _tabKeys[null] = GlobalKey();
    for (final cat in widget.subcategories) {
      _tabKeys[cat.id] = GlobalKey();
    }
    _scrollToSelected();
  }

  @override
  void didUpdateWidget(covariant _SubcategoryTabs oldWidget) {
    super.didUpdateWidget(oldWidget);
    for (final cat in widget.subcategories) {
      _tabKeys.putIfAbsent(cat.id, () => GlobalKey());
    }
    if (oldWidget.selectedId != widget.selectedId) {
      _scrollToSelected();
    }
  }

  void _scrollToSelected() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final key = _tabKeys[widget.selectedId];
      if (key?.currentContext != null) {
        Scrollable.ensureVisible(
          key!.currentContext!,
          alignment: 0.3,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 52,
      color: theme.appBarTheme.backgroundColor ?? theme.colorScheme.surface,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            _TabChip(
              key: _tabKeys[null],
              label: 'الكل',
              isSelected: widget.selectedId == null,
              onTap: () => widget.onSelected(null),
            ),
            ...widget.subcategories.map((cat) => _TabChip(
                  key: _tabKeys[cat.id],
                  label: cat.name,
                  isSelected: widget.selectedId == cat.id,
                  onTap: () => widget.onSelected(
                      widget.selectedId == cat.id ? null : cat.id),
                )),
          ],
        ),
      ),
    );
  }
}

class _TabChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Material(
        color: isSelected
            ? theme.colorScheme.primary
            : isDark
                ? const Color(0xFF2E2A45)
                : const Color(0xFFEEEBF8),
        borderRadius: BorderRadius.circular(24),
        elevation: isSelected ? 2 : 0,
        shadowColor: isSelected
            ? theme.colorScheme.primary.withOpacity(0.4)
            : Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontFamily: 'Cairo',
                color: isSelected
                    ? Colors.white
                    : theme.colorScheme.onSurface.withOpacity(0.85),
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Level 3 Chips Row ──────────────────────────────────────────────

class _Level3ChipsRow extends ConsumerWidget {
  final int parentId;
  final int? selectedId;
  final ValueChanged<int?> onSelected;

  const _Level3ChipsRow({
    required this.parentId,
    required this.selectedId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final childrenAsync = ref.watch(categoryChildrenProvider(parentId));
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C192E) : const Color(0xFFF0EDF7),
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.onSurface.withOpacity(0.06),
          ),
        ),
      ),
      child: childrenAsync.when(
        loading: () =>
            const Center(child: LinearProgressIndicator(minHeight: 2)),
        error: (_, __) => const SizedBox.shrink(),
        data: (children) {
          if (children.isEmpty) return const SizedBox.shrink();
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              children: [
                _SubChip(
                  label: 'الكل',
                  isSelected: selectedId == null,
                  onTap: () => onSelected(null),
                ),
                ...children.map((c) => _SubChip(
                      label: c.name,
                      isSelected: selectedId == c.id,
                      onTap: () =>
                          onSelected(selectedId == c.id ? null : c.id),
                    )),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SubChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SubChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: Material(
        color: isSelected
            ? theme.colorScheme.primary.withOpacity(0.15)
            : isDark
                ? theme.colorScheme.surface
                : Colors.white,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withOpacity(0.15),
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontFamily: 'Cairo',
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withOpacity(0.85),
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Sticky Header Delegate ─────────────────────────────────────────

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyHeaderDelegate({required this.child});

  @override
  double get minExtent => 50;

  @override
  double get maxExtent => 50;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(covariant _StickyHeaderDelegate oldDelegate) => true;
}

// ─── Listing Card (same style as listings_screen) ───────────────────

class _ListingCard extends StatelessWidget {
  final Listing listing;
  final VoidCallback onTap;

  const _ListingCard({
    required this.listing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 160,
                  decoration: BoxDecoration(
                    image: listing.images.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(AppConstants.imageUrl(
                                listing.images[0].imageUrl)),
                            fit: BoxFit.cover,
                          )
                        : null,
                    color: theme.colorScheme.surfaceContainerHighest,
                  ),
                  child: listing.images.isEmpty
                      ? Center(
                          child: Icon(Icons.image_outlined,
                              size: 48,
                              color: theme.colorScheme.onSurface
                                  .withOpacity(0.2)))
                      : null,
                ),
                if (listing.isFeatured)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'مميز',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            // Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    listing.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      if (listing.category != null) ...[
                        Icon(Icons.category_outlined,
                            size: 14,
                            color: theme.colorScheme.onSurface
                                .withOpacity(0.5)),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            listing.category!.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface
                                  .withOpacity(0.6),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                      Icon(Icons.location_on_outlined,
                          size: 14,
                          color:
                              theme.colorScheme.onSurface.withOpacity(0.5)),
                      const SizedBox(width: 4),
                      Text(
                        listing.governorate?.name ?? 'غير محدد',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color:
                              theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.visibility_outlined,
                              size: 14,
                              color: theme.colorScheme.onSurface
                                  .withOpacity(0.4)),
                          const SizedBox(width: 4),
                          Text(
                            '${listing.viewCount}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface
                                  .withOpacity(0.4),
                            ),
                          ),
                        ],
                      ),
                      FilledButton.tonalIcon(
                        onPressed: onTap,
                        icon: const Icon(Icons.arrow_forward_rounded,
                            size: 16),
                        label: const Text('التفاصيل'),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          textStyle: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
