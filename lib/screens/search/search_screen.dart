import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/listing_model.dart';
import '../../providers/data_providers.dart';
import '../../widgets/shimmer_skeletons.dart';
import 'search_filters_modal.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late TextEditingController _searchController;
  String searchQuery = '';
  int currentPage = 1;
  int? filterCategoryId;
  int? filterGovernorateId;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchResultsAsync = searchQuery.isEmpty
        ? null
        : ref.watch(searchListingsProvider(
            (
              query: searchQuery,
              page: currentPage,
              limit: 20,
              categoryId: filterCategoryId,
              governorateId: filterGovernorateId,
            ),
          ));

    final categoriesAsync = ref.watch(categoriesProvider);
    final governoratesAsync = ref.watch(governoratesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('بحث'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => SearchFiltersModal(
                  selectedCategoryId: filterCategoryId,
                  selectedGovernorateId: filterGovernorateId,
                  onFiltersChanged: (categoryId, governorateId) {
                    setState(() {
                      filterCategoryId = categoryId;
                      filterGovernorateId = governorateId;
                      currentPage = 1;
                    });
                  },
                ),
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                  currentPage = 1;
                });
              },
              decoration: InputDecoration(
                hintText: 'ابحث عن محتوى...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => searchQuery = '');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Filter chips
          if (!categoriesAsync.isLoading && !governoratesAsync.isLoading)
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.grey[50],
              child: Row(
                children: [
                  // Category filter
                  Expanded(
                    child: governoratesAsync.when(
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                      data: (governorates) => SizedBox(
                        height: 40,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: governorates.length + 1,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return FilterChip(
                                label: const Text('الكل'),
                                selected: filterGovernorateId == null,
                                onSelected: (selected) {
                                  setState(() {
                                    filterGovernorateId = null;
                                    currentPage = 1;
                                  });
                                },
                              );
                            }
                            final gov = governorates[index - 1];
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: FilterChip(
                                label: Text(gov.name),
                                selected: filterGovernorateId == gov.id,
                                onSelected: (selected) {
                                  setState(() {
                                    filterGovernorateId =
                                        selected ? gov.id : null;
                                    currentPage = 1;
                                  });
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          // Search results
          Expanded(
            child: searchQuery.isEmpty
                ? _buildEmptySearchState()
                : searchResultsAsync == null
                    ? _buildEmptySearchState()
                    : searchResultsAsync.when(
                        loading: () => ListView.builder(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          itemCount: 6,
                          itemBuilder: (_, __) => ListingCardSkeleton(),
                        ),
                        error: (error, stack) => _buildErrorWidget(),
                        data: (response) {
                          if (response.data.isEmpty) {
                            return _buildNoResultsWidget();
                          }
                          return _buildSearchResults(response.data);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptySearchState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'ابحث عما تبحث عنه',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'أدخل كلمة البحث أعلاه',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text('لا توجد نتائج'),
          const SizedBox(height: 8),
          Text(
            'جرب كلمة بحث أخرى',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              _searchController.clear();
              setState(() => searchQuery = '');
            },
            child: const Text('مسح البحث'),
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
          Icon(Icons.error_outline, size: 80, color: Colors.red[400]),
          const SizedBox(height: 16),
          const Text('حدث خطأ'),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              ref.refresh(searchListingsProvider(
                (
                  query: searchQuery,
                  page: currentPage,
                  limit: 20,
                  categoryId: filterCategoryId,
                  governorateId: filterGovernorateId,
                ),
              ));
            },
            icon: const Icon(Icons.refresh),
            label: const Text('إعادة محاولة'),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(List<Listing> listings) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: listings.length,
      itemBuilder: (context, index) {
        final listing = listings[index];
        return GestureDetector(
          onTap: () => context.go('/listing/${listing.id}'),
          child: Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                // Thumbnail
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                    image: listing.images.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(listing.images[0].imageUrl),
                            fit: BoxFit.cover,
                          )
                        : null,
                    color: Colors.grey[200],
                  ),
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
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          listing.category?.name ?? 'غير محدد',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          listing.governorate?.name ?? 'غير محدد',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          listing.description ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
