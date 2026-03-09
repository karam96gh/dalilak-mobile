import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/data_providers.dart';

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
  late int _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPage = 1;
  }

  @override
  Widget build(BuildContext context) {
    final categoryAsync = ref.watch(categoryByIdProvider(widget.categoryId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('التصنيف'),
        centerTitle: true,
      ),
      body: categoryAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => _buildErrorWidget(context),
        data: (category) => _buildCategoryDetail(context, category),
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context) {
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
              ref.refresh(categoryByIdProvider(widget.categoryId));
            },
            icon: const Icon(Icons.refresh),
            label: const Text('إعادة محاولة'),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryDetail(BuildContext context, dynamic category) {
    final listingsAsync = ref.watch(
      listingsProvider((
        page: _currentPage,
        limit: 20,
        categoryId: widget.categoryId,
        governorateId: null,
      )),
    );

    return CustomScrollView(
      slivers: [
        // Category Header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category Icon/Image
                if (category.image != null && category.image!.isNotEmpty)
                  Container(
                    width: double.infinity,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey[200],
                    ),
                    child: Image.network(
                      category.image!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: const Icon(Icons.category, size: 48),
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 16),

                // Category Name
                Text(
                  category.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),

                // Subcategories if any
                if (category.children != null && category.children!.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: category.children!.map<Widget>((subcat) {
                      return InputChip(
                        label: Text(subcat.name),
                        onPressed: () {
                          // Navigate to subcategory
                          context.push('/categories/${subcat.id}');
                        },
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(child: Divider()),

        // Listings for this category
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'المحتويات',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  'الصفحة $_currentPage',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),

        // Listings Grid
        listingsAsync.when(
          loading: () => const SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, stack) => SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text('خطأ: $error'),
              ),
            ),
          ),
          data: (listingsResponse) => listingsResponse.data.isEmpty
              ? SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'لا توجد محتويات في هذا التصنيف',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.8,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final listing = listingsResponse.data[index];
                        return _buildListingCard(context, listing);
                      },
                      childCount: listingsResponse.data.length,
                    ),
                  ),
                ),
        ),

        // Pagination Controls
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _currentPage > 1
                      ? () {
                          setState(() => _currentPage--);
                        }
                      : null,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('السابق'),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() => _currentPage++);
                  },
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('التالي'),
                ),
              ],
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }

  Widget _buildListingCard(BuildContext context, dynamic listing) {
    return GestureDetector(
      onTap: () => context.push('/listing/${listing.id}'),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              child: Container(
                width: double.infinity,
                color: Colors.grey[200],
                child: listing.images.isNotEmpty
                    ? Image.network(
                        listing.images.first.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.image_not_supported);
                        },
                      )
                    : const Icon(Icons.image_not_supported),
              ),
            ),
            // Info
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (listing.isFeatured)
                    Chip(
                      label: const Text('مميز'),
                      backgroundColor: Colors.orange[100],
                      labelStyle: const TextStyle(color: Colors.orange),
                      visualDensity: VisualDensity.compact,
                    ),
                  const SizedBox(height: 4),
                  Text(
                    listing.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  if (listing.governorate != null)
                    Text(
                      listing.governorate!.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
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
