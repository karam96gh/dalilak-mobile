import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/listing_model.dart';
import '../../models/category_model.dart';
import '../../models/governorate_model.dart';
import '../../constants/app_constants.dart';
import '../../providers/data_providers.dart';
import '../../widgets/shimmer_skeletons.dart';

class ListingsScreen extends ConsumerStatefulWidget {
  final int? categoryId;
  final int? governorateId;

  const ListingsScreen({
    Key? key,
    this.categoryId,
    this.governorateId,
  }) : super(key: key);

  @override
  ConsumerState<ListingsScreen> createState() => _ListingsScreenState();
}

class _ListingsScreenState extends ConsumerState<ListingsScreen> {
  final ScrollController _scrollController = ScrollController();
  final List<Listing> _allListings = [];

  int _currentPage = 1;
  int _totalItems = 0;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  static const int _itemsPerPage = 20;
  bool _showScrollToTop = false;

  int? _selectedGovernorateId;
  int? _selectedRootCategoryId;
  int? _selectedLevel2CategoryId;
  int? _selectedLevel3CategoryId;

  @override
  void initState() {
    super.initState();
    _selectedGovernorateId = widget.governorateId;
    _selectedRootCategoryId = widget.categoryId;
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

    final shouldShowToTop = position.pixels > 400;
    if (shouldShowToTop != _showScrollToTop) {
      setState(() {
        _showScrollToTop = shouldShowToTop;
      });
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

  int? get _effectiveCategoryId =>
      _selectedLevel3CategoryId ??
      _selectedLevel2CategoryId ??
      _selectedRootCategoryId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final governoratesAsync = ref.watch(governoratesProvider);
    final categoriesAsync = ref.watch(categoriesProvider);

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
            // ─── AppBar مع dropdown المحافظة ───
            SliverAppBar(
              title: const Text('المحتويات'),
              floating: true,
              snap: true,
              pinned: true,
              elevation: 0,
              actions: [
                // Governorate Dropdown
                governoratesAsync.when(
                  loading: () => const Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
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
              // ─── TabBar الأقسام الرئيسية ───
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(52),
                child: categoriesAsync.when(
                  loading: () => const SizedBox(
                    height: 52,
                    child: Center(
                        child: LinearProgressIndicator(minHeight: 2)),
                  ),
                  error: (_, __) => const SizedBox(height: 52),
                  data: (categories) => _RootCategoryTabs(
                    categories: categories,
                    selectedId: _selectedRootCategoryId,
                    onSelected: (id) {
                      setState(() {
                        _selectedRootCategoryId = id;
                        _selectedLevel2CategoryId = null;
                        _selectedLevel3CategoryId = null;
                      });
                      _resetAndReload();
                    },
                  ),
                ),
              ),
            ),

            // ─── الأقسام الفرعية (Level 2) ───
            if (_selectedRootCategoryId != null)
              SliverPersistentHeader(
                pinned: true,
                delegate: _SubcategoryHeaderDelegate(
                  child: _SubcategoryChipsRow(
                    parentId: _selectedRootCategoryId!,
                    selectedId: _selectedLevel2CategoryId,
                    onSelected: (id) {
                      setState(() {
                        _selectedLevel2CategoryId = id;
                        _selectedLevel3CategoryId = null;
                      });
                      _resetAndReload();
                    },
                  ),
                ),
              ),

            // ─── الأقسام الفرعية (Level 3) ───
            if (_selectedLevel2CategoryId != null)
              SliverPersistentHeader(
                pinned: true,
                delegate: _SubcategoryHeaderDelegate(
                  child: _SubcategoryChipsRow(
                    parentId: _selectedLevel2CategoryId!,
                    selectedId: _selectedLevel3CategoryId,
                    onSelected: (id) {
                      setState(() => _selectedLevel3CategoryId = id);
                      _resetAndReload();
                    },
                  ),
                ),
              ),

            // ─── عداد النتائج ───
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
                    if (_selectedGovernorateId != null ||
                        _selectedRootCategoryId != null)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedGovernorateId = null;
                            _selectedRootCategoryId = null;
                            _selectedLevel2CategoryId = null;
                            _selectedLevel3CategoryId = null;
                          });
                          _resetAndReload();
                        },
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
        // ─── المحتويات ───
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
            return _buildErrorWidget();
          },
          data: (response) {
            if (_allListings.isEmpty && response.data.isEmpty) {
              return _buildEmptyWidget();
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
        return ListingCard(
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

  Widget _buildEmptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_rounded, size: 72, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text('لا توجد محتويات',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            'جرّب تغيير الفلاتر أو اختيار قسم آخر',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () {
              setState(() {
                _selectedGovernorateId = null;
                _selectedRootCategoryId = null;
                _selectedLevel2CategoryId = null;
                _selectedLevel3CategoryId = null;
              });
              _resetAndReload();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('إعادة تعيين'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline_rounded, size: 72,
              color: Theme.of(context).colorScheme.error),
          const SizedBox(height: 16),
          const Text('حدث خطأ في تحميل البيانات'),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              ref.invalidate(listingsProvider((
                page: _currentPage,
                limit: _itemsPerPage,
                categoryId: _effectiveCategoryId,
                governorateId: _selectedGovernorateId,
              )));
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
                color: selectedId == null
                    ? theme.colorScheme.primary
                    : Colors.grey,
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

// ─── Root Category Tabs ────────────────────────────────────────────

class _RootCategoryTabs extends StatefulWidget {
  final List<Category> categories;
  final int? selectedId;
  final ValueChanged<int?> onSelected;

  const _RootCategoryTabs({
    required this.categories,
    required this.selectedId,
    required this.onSelected,
  });

  @override
  State<_RootCategoryTabs> createState() => _RootCategoryTabsState();
}

class _RootCategoryTabsState extends State<_RootCategoryTabs> {
  final Map<int?, GlobalKey> _tabKeys = {};

  @override
  void initState() {
    super.initState();
    _tabKeys[null] = GlobalKey(); // "الكل" tab
    for (final cat in widget.categories) {
      _tabKeys[cat.id] = GlobalKey();
    }
    _scrollToSelected();
  }

  @override
  void didUpdateWidget(covariant _RootCategoryTabs oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Add keys for any new categories
    for (final cat in widget.categories) {
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
              icon: null,
              isSelected: widget.selectedId == null,
              onTap: () => widget.onSelected(null),
            ),
            ...widget.categories.map((cat) => _TabChip(
                  key: _tabKeys[cat.id],
                  label: cat.name,
                  icon: cat.icon,
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
  final String? icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabChip({
    super.key,
    required this.label,
    required this.icon,
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
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null && icon!.isNotEmpty) ...[
                  Text(icon!, style: const TextStyle(fontSize: 16)),
                  const SizedBox(width: 6),
                ],
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: 'Cairo',
                    color: isSelected
                        ? Colors.white
                        : theme.colorScheme.onSurface.withOpacity(0.85),
                    fontWeight:
                        isSelected ? FontWeight.w700 : FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Subcategory Chips Row (Level 2 & 3) ───────────────────────────

class _SubcategoryChipsRow extends ConsumerWidget {
  final int parentId;
  final int? selectedId;
  final ValueChanged<int?> onSelected;

  const _SubcategoryChipsRow({
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
        loading: () => const Center(
            child: LinearProgressIndicator(minHeight: 2)),
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
                      onTap: () => onSelected(
                          selectedId == c.id ? null : c.id),
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
                fontWeight:
                    isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Subcategory Header Delegate (Sticky) ──────────────────────────

class _SubcategoryHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _SubcategoryHeaderDelegate({required this.child});

  @override
  double get minExtent => 48;

  @override
  double get maxExtent => 48;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(covariant _SubcategoryHeaderDelegate oldDelegate) => true;
}

// ─── Listing Card ──────────────────────────────────────────────────

class ListingCard extends StatelessWidget {
  final Listing listing;
  final VoidCallback onTap;

  const ListingCard({
    Key? key,
    required this.listing,
    required this.onTap,
  }) : super(key: key);

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
                      Icon(Icons.category_outlined,
                          size: 14,
                          color: theme.colorScheme.onSurface
                              .withOpacity(0.5)),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          listing.category?.name ?? 'غير محدد',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withOpacity(0.6),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(Icons.location_on_outlined,
                          size: 14,
                          color: theme.colorScheme.onSurface
                              .withOpacity(0.5)),
                      const SizedBox(width: 4),
                      Text(
                        listing.governorate?.name ?? 'غير محدد',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withOpacity(0.6),
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
