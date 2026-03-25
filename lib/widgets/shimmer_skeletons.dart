import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Reusable shimmer loading skeletons for various UI components
class ShimmerSkeleton extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const ShimmerSkeleton({
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Shimmer.fromColors(
      baseColor: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
      highlightColor: isDarkMode ? Colors.grey[600]! : Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
      ),
    );
  }
}

/// Skeleton for listing card
class ListingCardSkeleton extends StatelessWidget {
  const ListingCardSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerSkeleton(
            width: double.infinity,
            height: 150,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerSkeleton(
                  width: 200,
                  height: 16,
                  borderRadius: BorderRadius.circular(4),
                ),
                SizedBox(height: 8),
                ShimmerSkeleton(
                  width: 150,
                  height: 14,
                  borderRadius: BorderRadius.circular(4),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    ShimmerSkeleton(
                      width: 100,
                      height: 12,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    Spacer(),
                    ShimmerSkeleton(
                      width: 50,
                      height: 24,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Skeleton for category card
class CategoryCardSkeleton extends StatelessWidget {
  const CategoryCardSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ShimmerSkeleton(
          width: 80,
          height: 80,
          borderRadius: BorderRadius.circular(12),
        ),
        SizedBox(height: 8),
        ShimmerSkeleton(
          width: 70,
          height: 14,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }
}

/// Skeleton for listing detail screen
class ListingDetailSkeleton extends StatelessWidget {
  const ListingDetailSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerSkeleton(
            width: double.infinity,
            height: 250,
            borderRadius: BorderRadius.zero,
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerSkeleton(
                  width: 250,
                  height: 24,
                  borderRadius: BorderRadius.circular(4),
                ),
                SizedBox(height: 12),
                ShimmerSkeleton(
                  width: 200,
                  height: 16,
                  borderRadius: BorderRadius.circular(4),
                ),
                SizedBox(height: 16),
                ...[1, 2, 3].map((e) => Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: ShimmerSkeleton(
                    width: double.infinity,
                    height: 14,
                    borderRadius: BorderRadius.circular(4),
                  ),
                )),
                SizedBox(height: 20),
                ShimmerSkeleton(
                  width: double.infinity,
                  height: 48,
                  borderRadius: BorderRadius.circular(8),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Skeleton for notification card
class NotificationSkeleton extends StatelessWidget {
  const NotificationSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          ShimmerSkeleton(
            width: 56,
            height: 56,
            borderRadius: BorderRadius.circular(8),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerSkeleton(
                  width: 150,
                  height: 16,
                  borderRadius: BorderRadius.circular(4),
                ),
                SizedBox(height: 8),
                ShimmerSkeleton(
                  width: double.infinity,
                  height: 14,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Skeleton for governorate/category list item
class ListItemSkeleton extends StatelessWidget {
  const ListItemSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          ShimmerSkeleton(
            width: 40,
            height: 40,
            borderRadius: BorderRadius.circular(4),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerSkeleton(
                  width: 200,
                  height: 16,
                  borderRadius: BorderRadius.circular(4),
                ),
                SizedBox(height: 4),
                ShimmerSkeleton(
                  width: 150,
                  height: 12,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Skeleton for search results
class SearchResultSkeleton extends StatelessWidget {
  const SearchResultSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (_, __) => ListingCardSkeleton(),
    );
  }
}

/// Skeleton for grid of categories
class CategoryGridSkeleton extends StatelessWidget {
  final int itemCount;

  const CategoryGridSkeleton({
    this.itemCount = 8,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.8,
      ),
      itemCount: itemCount,
      itemBuilder: (_, __) => CategoryCardSkeleton(),
    );
  }
}

/// Skeleton for horizontal list
class HorizontalListSkeleton extends StatelessWidget {
  final int itemCount;

  const HorizontalListSkeleton({
    this.itemCount = 5,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: itemCount,
        itemBuilder: (_, __) => Padding(
          padding: EdgeInsets.only(right: 12),
          child: CategoryCardSkeleton(),
        ),
      ),
    );
  }
}


/// Skeleton for ad carousel
class AdCarouselSkeleton extends StatelessWidget {
  const AdCarouselSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: ShimmerSkeleton(
        width: double.infinity,
        height: 180,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
