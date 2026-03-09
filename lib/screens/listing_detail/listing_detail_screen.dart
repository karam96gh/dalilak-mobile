import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import '../../models/listing_model.dart';
import '../../providers/data_providers.dart';
import '../../widgets/shimmer_skeletons.dart';

class ListingDetailScreen extends ConsumerWidget {
  final int listingId;

  const ListingDetailScreen({
    Key? key,
    required this.listingId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listingAsync = ref.watch(listingByIdProvider(listingId));
    final isFavorite = ref.watch(
      favoritesProvider.select((fav) => fav.contains(listingId)),
    );

    return Scaffold(
      body: listingAsync.when(
        loading: () => const Scaffold(
          body: ListingDetailSkeleton(),
        ),
        error: (error, stack) => _buildErrorWidget(context, ref),
        data: (listing) => _buildDetailWidget(
          context,
          ref,
          listing,
          isFavorite,
        ),
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
            const SizedBox(height: 16),
            const Text('حدث خطأ في تحميل البيانات'),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                ref.refresh(listingByIdProvider(listingId));
              },
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة محاولة'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailWidget(
    BuildContext context,
    WidgetRef ref,
    Listing listing,
    bool isFavorite,
  ) {
    return CustomScrollView(
      slivers: [
        // App bar with images
        _buildImageAppBar(context, ref, listing, isFavorite),

        // Content
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and badges
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            listing.name,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (listing.isFeatured)
                      Chip(
                        label: const Text('مميز'),
                        backgroundColor: Colors.orange[100],
                        labelStyle: const TextStyle(color: Colors.orange),
                      ),
                    const SizedBox(height: 12),
                    // Info badges
                    Wrap(
                      spacing: 8,
                      children: [
                        if (listing.category != null)
                          Chip(
                            label: Text(listing.category!.name),
                          ),
                        if (listing.governorate != null)
                          Chip(
                            label: Text(listing.governorate!.name),
                          ),
                        Chip(
                          label: Text('${listing.viewCount} مشاهدة'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(),

              // Description
              if (listing.description != null && listing.description!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'الوصف',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        listing.description!,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              const Divider(),

              // Contact Information
              if (_hasContactInfo(listing))
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'معلومات الاتصال',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      _buildContactButtons(listing),
                    ],
                  ),
                ),
              const Divider(),

              // Address
              if (listing.address != null && listing.address!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'العنوان',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(listing.address!),
                    ],
                  ),
                ),

              // Social Media
              if (_hasSocialMedia(listing))
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'تابعنا على',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        children: [
                          if (listing.instagram != null)
                            _buildSocialButton(
                              'Instagram',
                              Icons.link,
                              Colors.pink,
                              () => _launchUrl('https://instagram.com/${listing.instagram}'),
                            ),
                          if (listing.facebook != null)
                            _buildSocialButton(
                              'Facebook',
                              Icons.link,
                              Colors.blue,
                              () => _launchUrl('https://facebook.com/${listing.facebook}'),
                            ),
                          if (listing.tiktok != null)
                            _buildSocialButton(
                              'TikTok',
                              Icons.link,
                              Colors.black,
                              () => _launchUrl('https://tiktok.com/@${listing.tiktok}'),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              const Divider(),

              // Ratings Section
              _buildRatingsSection(context, ref, listing),
              const Divider(),

              // Reviews Section
              _buildReviewsSection(context, ref, listing),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImageAppBar(
    BuildContext context,
    WidgetRef ref,
    Listing listing,
    bool isFavorite,
  ) {
    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      actions: [
        IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : null,
          ),
          onPressed: () {
            ref.read(favoritesProvider.notifier).toggleFavorite(listing.id);
          },
        ),
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: () {
            Share.share(
              'تحقق من ${listing.name} في دليلك\n\n${listing.description}\n\nهاتف: ${listing.phone}\nواتساب: ${listing.whatsapp}',
              subject: listing.name,
            );
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: listing.images.isEmpty
            ? Container(color: Colors.grey[200])
            : PageView.builder(
                itemCount: listing.images.length,
                itemBuilder: (context, index) {
                  return Image.network(
                    listing.images[index].imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.image_not_supported),
                      );
                    },
                  );
                },
              ),
      ),
    );
  }

  Widget _buildContactButtons(Listing listing) {
    return Column(
      children: [
        if (listing.phone != null)
          _buildContactButton(
            icon: Icons.phone,
            label: 'اتصل',
            value: listing.phone!,
            onTap: () => _launchUrl('tel:${listing.phone}'),
          ),
        if (listing.whatsapp != null) ...[
          const SizedBox(height: 8),
          _buildContactButton(
            icon: Icons.message,
            label: 'واتس آب',
            value: listing.whatsapp!,
            onTap: () => _launchUrl('https://wa.me/${listing.whatsapp}'),
          ),
        ],
        if (listing.email != null) ...[
          const SizedBox(height: 8),
          _buildContactButton(
            icon: Icons.email,
            label: 'بريد إلكتروني',
            value: listing.email!,
            onTap: () => _launchUrl('mailto:${listing.email}'),
          ),
        ],
        if (listing.website != null) ...[
          const SizedBox(height: 8),
          _buildContactButton(
            icon: Icons.language,
            label: 'الموقع الإلكتروني',
            value: listing.website!,
            onTap: () => _launchUrl(listing.website!),
          ),
        ],
      ],
    );
  }

  Widget _buildContactButton({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return Material(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(icon, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return OutlinedButton.icon(
      icon: Icon(icon),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
      ),
      onPressed: onTap,
    );
  }

  bool _hasContactInfo(Listing listing) {
    return listing.phone != null ||
        listing.whatsapp != null ||
        listing.email != null ||
        listing.website != null;
  }

  bool _hasSocialMedia(Listing listing) {
    return listing.instagram != null ||
        listing.facebook != null ||
        listing.tiktok != null;
  }

  Widget _buildRatingsSection(
    BuildContext context,
    WidgetRef ref,
    Listing listing,
  ) {
    final ratingsAsync = ref.watch(listingRatingStatsProvider(listing.id));

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'التقييمات',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          ratingsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => const Text('خطأ في تحميل التقييمات'),
            data: (stats) => Column(
              children: [
                Row(
                  children: [
                    Text(
                      stats.averageRating.toStringAsFixed(1),
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: List.generate(
                              5,
                              (index) => Icon(
                                index < stats.averageRating.toInt()
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.amber,
                                size: 16,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'من ${stats.totalReviews} تقييم',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
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

  Widget _buildReviewsSection(
    BuildContext context,
    WidgetRef ref,
    Listing listing,
  ) {
    final reviewsAsync = ref.watch(
      listingReviewsProvider((
        listingId: listing.id,
        page: 1,
        limit: 5,
      )),
    );

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'التعليقات والمراجعات',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              TextButton(
                onPressed: () {
                  // TODO: Navigate to full reviews page
                },
                child: const Text('عرض الكل'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          reviewsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => const Text('خطأ في تحميل المراجعات'),
            data: (reviewsResponse) => reviewsResponse.data.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'لا توجد مراجعات حتى الآن',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  )
                : Column(
                    children: reviewsResponse.data.take(3).map((review) {
                      return _buildReviewCard(context, review);
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(BuildContext context, dynamic review) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: review.userImage != null
                      ? NetworkImage(review.userImage)
                      : null,
                  child: review.userImage == null
                      ? Text(review.userName.substring(0, 1))
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.userName,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Row(
                        children: [
                          ...List.generate(
                            5,
                            (index) => Icon(
                              index < review.rating
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.amber,
                              size: 14,
                            ),
                          ),
                          if (review.isVerifiedBuyer) ...[
                            const SizedBox(width: 8),
                            const Chip(
                              label: Text('مشتري محقق'),
                              labelStyle: TextStyle(fontSize: 10),
                              padding: EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 2,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(review.comment),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      }
    } catch (e) {
      // Handle error
    }
  }
}
