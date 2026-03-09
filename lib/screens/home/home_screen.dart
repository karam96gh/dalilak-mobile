import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/ad_model.dart';
import '../../models/category_model.dart';
import '../../models/listing_model.dart';
import '../../providers/data_providers.dart';
import '../../widgets/shimmer_skeletons.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adsAsync = ref.watch(adsProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final listingsAsync = ref.watch(listingsProvider(
      (page: 1, limit: 6, categoryId: null, governorateId: null),
    ));

    return Scaffold(
      appBar: AppBar(
        title: const Text('دليلك'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ads Carousel
            adsAsync.when(
              loading: () => const AdCarouselSkeleton(),
              error: (err, stack) => const SizedBox(height: 200),
              data: (ads) => AdsCarousel(ads: ads),
            ),
            
            const SizedBox(height: 24),

            // Categories Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'أفضل التصنيفات',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextButton(
                    onPressed: () => context.go('/categories'),
                    child: const Text('عرض الكل'),
                  ),
                ],
              ),
            ),
            categoriesAsync.when(
              loading: () => const CategoryGridSkeleton(itemCount: 6),
              error: (err, stack) => const SizedBox(height: 150),
              data: (categories) => CategoriesSection(
                categories: categories.take(6).toList(),
              ),
            ),

            const SizedBox(height: 24),

            // Latest Listings Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'آخر الإضافات',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextButton(
                    onPressed: () => context.go('/listings'),
                    child: const Text('عرض الكل'),
                  ),
                ],
              ),
            ),
            listingsAsync.when(
              loading: () => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 3,
                  itemBuilder: (_, __) => ListingCardSkeleton(),
                ),
              ),
              error: (err, stack) => const SizedBox(height: 300),
              data: (response) => ListingsSection(
                listings: response.data,
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class AdsCarousel extends StatefulWidget {
  final List<Ad> ads;

  const AdsCarousel({Key? key, required this.ads}) : super(key: key);

  @override
  State<AdsCarousel> createState() => _AdsCarouselState();
}

class _AdsCarouselState extends State<AdsCarousel> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.ads.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemCount: widget.ads.length,
            itemBuilder: (context, index) {
              final ad = widget.ads[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: NetworkImage(ad.image),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
          // Page indicator
          Positioned(
            bottom: 8,
            left: 0,
            right: 0,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.ads.length,
                  (index) => Container(
                    width: _currentPage == index ? 12 : 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: _currentPage == index
                          ? Colors.white
                          : Colors.white54,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CategoriesSection extends StatelessWidget {
  final List<Category> categories;

  const CategoriesSection({Key? key, required this.categories})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: GestureDetector(
              onTap: () => context.go('/categories?id=${category.id}'),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.primaries[index % Colors.primaries.length]
                          .withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: category.icon != null
                          ? Image.asset(category.icon!, width: 40, height: 40)
                          : Icon(
                              Icons.category,
                              size: 40,
                              color:
                                  Colors.primaries[index % Colors.primaries.length],
                            ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 96,
                    child: Text(
                      category.name,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ListingsSection extends StatelessWidget {
  final List<Listing> listings;

  const ListingsSection({Key? key, required this.listings}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: listings.length,
      itemBuilder: (context, index) {
        final listing = listings[index];
        return GestureDetector(
          onTap: () => context.go('/listing/${listing.id}'),
          child: Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4),
                      bottomLeft: Radius.circular(4),
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
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.grey),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          listing.governorate?.name ?? 'غير محدد',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.grey),
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
