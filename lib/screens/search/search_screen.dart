import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/listing_model.dart';
import '../../models/category_model.dart';
import '../../models/governorate_model.dart';
import '../../constants/app_constants.dart';
import '../../providers/data_providers.dart';
import '../../widgets/shimmer_skeletons.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late TextEditingController _searchController;
  late FocusNode _focusNode;
  final ScrollController _scrollController = ScrollController();
  Timer? _debounceTimer;

  String _searchQuery = '';
  int _currentPage = 1;
  int? filterCategoryId;
  int? filterGovernorateId;

  final List<Listing> _allResults = [];
  int _totalResults = 0;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  static const int _limit = 20;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _focusNode = FocusNode();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    _focusNode.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      _loadMore();
    }
  }

  void _loadMore() {
    if (_isLoadingMore || !_hasMore || _searchQuery.isEmpty) return;
    setState(() {
      _isLoadingMore = true;
      _currentPage++;
    });
  }

  void _onSearchChanged(String value) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 400), () {
      if (mounted) {
        setState(() {
          _searchQuery = value.trim();
          _allResults.clear();
          _currentPage = 1;
          _hasMore = true;
          _isLoadingMore = false;
          _totalResults = 0;
        });
      }
    });
  }

  void _resetFilters() {
    setState(() {
      filterCategoryId = null;
      filterGovernorateId = null;
      _allResults.clear();
      _currentPage = 1;
      _hasMore = true;
      _isLoadingMore = false;
      _totalResults = 0;
    });
  }

  void _quickSearch(String query) {
    _searchController.text = query;
    setState(() {
      _searchQuery = query;
      _allResults.clear();
      _currentPage = 1;
      _hasMore = true;
      _isLoadingMore = false;
      _totalResults = 0;
    });
  }

  void _selectGovernorate(int? id) {
    setState(() {
      filterGovernorateId = id;
      _allResults.clear();
      _currentPage = 1;
      _hasMore = true;
      _isLoadingMore = false;
      _totalResults = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categoriesAsync = ref.watch(categoriesProvider);
    final governoratesAsync = ref.watch(governoratesProvider);

    final searchResultsAsync = _searchQuery.isEmpty
        ? null
        : ref.watch(searchListingsProvider((
            query: _searchQuery,
            page: _currentPage,
            limit: _limit,
            categoryId: filterCategoryId,
            governorateId: filterGovernorateId,
          )));

    // Accumulate results
    searchResultsAsync?.whenData((response) {
      if (_currentPage == 1 && _allResults.isEmpty) {
        _allResults.addAll(response.data);
        _totalResults = response.total;
      } else if (_isLoadingMore) {
        final existingIds = _allResults.map((l) => l.id).toSet();
        final newItems =
            response.data.where((l) => !existingIds.contains(l.id)).toList();
        if (newItems.isNotEmpty) {
          _allResults.addAll(newItems);
        }
        _totalResults = response.total;
        _isLoadingMore = false;
      }
      _hasMore = _allResults.length < response.total;
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('بحث'),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              controller: _searchController,
              focusNode: _focusNode,
              onChanged: _onSearchChanged,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'ابحث عن مطعم، فندق، خدمة...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          _searchController.clear();
                          _debounceTimer?.cancel();
                          setState(() {
                            _searchQuery = '';
                            _allResults.clear();
                            _totalResults = 0;
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Governorate filter row (always visible when searching)
          if (_searchQuery.isNotEmpty)
            governoratesAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
              data: (governorates) => Container(
                height: 44,
                color: theme.colorScheme.surface,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      _FilterPill(
                        label: 'كل المحافظات',
                        isSelected: filterGovernorateId == null,
                        onTap: () => _selectGovernorate(null),
                      ),
                      ...governorates.map((g) => _FilterPill(
                            label: g.name,
                            isSelected: filterGovernorateId == g.id,
                            onTap: () => _selectGovernorate(
                                filterGovernorateId == g.id ? null : g.id),
                          )),
                    ],
                  ),
                ),
              ),
            ),

          // Results count
          if (_searchQuery.isNotEmpty && _allResults.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Text(
                    '$_totalResults نتيجة',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                  if (filterGovernorateId != null) ...[
                    const Spacer(),
                    GestureDetector(
                      onTap: _resetFilters,
                      child: Text(
                        'مسح الفلاتر',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

          // Content
          Expanded(
            child: _searchQuery.isEmpty
                ? _buildDiscoverView(theme, categoriesAsync)
                : searchResultsAsync == null
                    ? _buildDiscoverView(theme, categoriesAsync)
                    : searchResultsAsync.when(
                        loading: () {
                          if (_allResults.isNotEmpty) {
                            return _buildResultsList(theme);
                          }
                          return _buildLoadingSkeleton();
                        },
                        error: (error, stack) {
                          if (_allResults.isNotEmpty) {
                            return _buildResultsList(theme);
                          }
                          return _buildErrorWidget(theme);
                        },
                        data: (response) {
                          if (_allResults.isEmpty && response.data.isEmpty) {
                            return _buildNoResultsWidget(theme);
                          }
                          return _buildResultsList(theme);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  // ─── Discover View (shown when no search) ────────────────────────

  Widget _buildDiscoverView(
      ThemeData theme, AsyncValue<List<Category>> categoriesAsync) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quick search suggestions
          Text('بحث سريع', style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _QuickSearchChip(
                  label: 'مطاعم', icon: '🍽️', onTap: () => _quickSearch('مطاعم')),
              _QuickSearchChip(
                  label: 'فنادق', icon: '🏨', onTap: () => _quickSearch('فنادق')),
              _QuickSearchChip(
                  label: 'صيدليات', icon: '💊', onTap: () => _quickSearch('صيدليات')),
              _QuickSearchChip(
                  label: 'مستشفيات', icon: '🏥', onTap: () => _quickSearch('مستشفيات')),
              _QuickSearchChip(
                  label: 'تعليم', icon: '📚', onTap: () => _quickSearch('تعليم')),
              _QuickSearchChip(
                  label: 'سيارات', icon: '🚗', onTap: () => _quickSearch('سيارات')),
            ],
          ),

          const SizedBox(height: 28),

          // Browse by category
          Text('تصفح حسب التصنيف', style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          categoriesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => const SizedBox.shrink(),
            data: (categories) => Column(
              children: categories.map((cat) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () => context
                        .push('/listings?categoryId=${cat.id}'),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          if (cat.icon != null && cat.icon!.isNotEmpty)
                            Text(cat.icon!,
                                style: const TextStyle(fontSize: 24))
                          else
                            Icon(Icons.category_rounded,
                                color: theme.colorScheme.primary),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(cat.name,
                                    style: theme.textTheme.titleSmall
                                        ?.copyWith(
                                            fontWeight: FontWeight.w600)),
                                if ((cat.count?.children ?? 0) > 0)
                                  Text(
                                    '${cat.count?.children} أصناف فرعية',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurface
                                          .withOpacity(0.5),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios_rounded,
                              size: 14,
                              color: theme.colorScheme.onSurface
                                  .withOpacity(0.3)),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsList(ThemeData theme) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _allResults.length + (_hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _allResults.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        }
        final listing = _allResults[index];
        return _SearchResultCard(
          listing: listing,
          onTap: () => context.push('/listing/${listing.id}'),
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

  Widget _buildNoResultsWidget(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded,
              size: 72, color: theme.colorScheme.onSurface.withOpacity(0.2)),
          const SizedBox(height: 16),
          Text('لا توجد نتائج لـ "$_searchQuery"',
              style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            'جرب كلمة بحث أخرى أو غيّر المحافظة',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () {
              _searchController.clear();
              _debounceTimer?.cancel();
              setState(() {
                _searchQuery = '';
                _allResults.clear();
                _totalResults = 0;
              });
            },
            icon: const Icon(Icons.clear_all),
            label: const Text('مسح البحث'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline_rounded,
              size: 72, color: theme.colorScheme.error),
          const SizedBox(height: 16),
          const Text('حدث خطأ'),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _allResults.clear();
                _currentPage = 1;
                _hasMore = true;
                _isLoadingMore = false;
              });
            },
            icon: const Icon(Icons.refresh),
            label: const Text('إعادة محاولة'),
          ),
        ],
      ),
    );
  }
}

// ─── Filter Pill ───────────────────────────────────────────────────

class _FilterPill extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterPill({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: Material(
        color: isSelected
            ? theme.colorScheme.primaryContainer
            : theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: isSelected
                  ? Border.all(
                      color: theme.colorScheme.primary.withOpacity(0.4))
                  : null,
            ),
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withOpacity(0.7),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Quick Search Chip ─────────────────────────────────────────────

class _QuickSearchChip extends StatelessWidget {
  final String label;
  final String icon;
  final VoidCallback onTap;

  const _QuickSearchChip({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.primaryContainer.withOpacity(0.3),
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(icon, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 6),
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Search Result Card ────────────────────────────────────────────

class _SearchResultCard extends StatelessWidget {
  final Listing listing;
  final VoidCallback onTap;

  const _SearchResultCard({
    required this.listing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            // Thumbnail
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                image: listing.images.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(
                            AppConstants.imageUrl(listing.images[0].imageUrl)),
                        fit: BoxFit.cover,
                      )
                    : null,
                color: theme.colorScheme.surfaceContainerHighest,
              ),
              child: listing.images.isEmpty
                  ? Icon(Icons.image_outlined,
                      size: 32,
                      color: theme.colorScheme.onSurface.withOpacity(0.2))
                  : null,
            ),
            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      listing.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.category_outlined,
                            size: 13,
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
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined,
                            size: 13,
                            color: theme.colorScheme.onSurface
                                .withOpacity(0.5)),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            listing.governorate?.name ?? 'غير محدد',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface
                                  .withOpacity(0.6),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Icon(Icons.chevron_left,
                  color: theme.colorScheme.onSurface.withOpacity(0.3)),
            ),
          ],
        ),
      ),
    );
  }
}
