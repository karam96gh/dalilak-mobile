import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/listing_model.dart';
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
  int currentPage = 1;
  int itemsPerPage = 20;
  String sortBy = 'newest'; // newest, popular, featured
  bool isFeatured = false;

  @override
  Widget build(BuildContext context) {
    final listingsAsync = ref.watch(listingsProvider(
      (
        page: currentPage,
        limit: itemsPerPage,
        categoryId: widget.categoryId,
        governorateId: widget.governorateId
      ),
    ));

    return Scaffold(
      appBar: AppBar(
        title: const Text('المحتويات'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Filter and Sort Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.grey[50],
            child: Row(
              children: [
                // Filter button
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _showFilterDialog,
                    icon: const Icon(Icons.filter_list),
                    label: const Text('تصفية'),
                  ),
                ),
                const SizedBox(width: 8),
                // Sort dropdown
                Expanded(
                  child: DropdownButton<String>(
                    value: sortBy,
                    onChanged: (value) {
                      setState(() => sortBy = value ?? 'newest');
                    },
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(value: 'newest', child: Text('الأحدث')),
                      DropdownMenuItem(
                          value: 'popular', child: Text('الأكثر شهرة')),
                      DropdownMenuItem(
                          value: 'featured', child: Text('المميزة')),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Listings list
          Expanded(
            child: listingsAsync.when(
              loading: () => ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: 6,
                itemBuilder: (_, __) => ListingCardSkeleton(),
              ),
              error: (error, stack) => _buildErrorWidget(),
              data: (response) {
                if (response.data.isEmpty) {
                  return _buildEmptyWidget();
                }
                return _buildListingsListView(response.data, response.total);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListingsListView(List<Listing> listings, int total) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: listings.length + 1,
      itemBuilder: (context, index) {
        if (index == listings.length) {
          // Pagination controls
          return _buildPaginationControls(total);
        }
        final listing = listings[index];
        return ListingCard(
          listing: listing,
          onTap: () => context.go('/listing/${listing.id}'),
        );
      },
    );
  }

  Widget _buildPaginationControls(int total) {
    final totalPages = (total / itemsPerPage).ceil();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: currentPage > 1
                ? () {
                    setState(() => currentPage--);
                  }
                : null,
            child: const Text('السابق'),
          ),
          const SizedBox(width: 16),
          Text('$currentPage / $totalPages'),
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: currentPage < totalPages
                ? () {
                    setState(() => currentPage++);
                  }
                : null,
            child: const Text('التالي'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text('لا توجد محتويات'),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => setState(() => currentPage = 1),
            icon: const Icon(Icons.refresh),
            label: const Text('إعادة محاولة'),
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
          Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
          const SizedBox(height: 16),
          const Text('حدث خطأ في تحميل البيانات'),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              ref.refresh(listingsProvider(
                (
                  page: currentPage,
                  limit: itemsPerPage,
                  categoryId: widget.categoryId,
                  governorateId: widget.governorateId
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

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'خيارات التصفية',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              value: isFeatured,
              onChanged: (value) {
                setState(() => isFeatured = value ?? false);
                Navigator.pop(context);
              },
              title: const Text('المميزة فقط'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('تم'),
            ),
          ],
        ),
      ),
    );
  }
}

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
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
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
                // Featured badge
                if (listing.isFeatured)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'مميز',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
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
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.category, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          listing.category?.name ?? 'غير محدد',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          listing.governorate?.name ?? 'غير محدد',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // View count
                      Row(
                        children: [
                          Icon(Icons.visibility, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            '${listing.viewCount}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      // Contact button
                      OutlinedButton.icon(
                        onPressed: onTap,
                        icon: const Icon(Icons.phone, size: 16),
                        label: const Text('تفاصيل'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
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
