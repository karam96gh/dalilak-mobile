import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import '../../models/listing_model.dart';
import '../../constants/app_constants.dart';
import '../../providers/data_providers.dart';
import '../../widgets/shimmer_skeletons.dart';

class ListingDetailScreen extends ConsumerStatefulWidget {
  final int listingId;

  const ListingDetailScreen({
    Key? key,
    required this.listingId,
  }) : super(key: key);

  @override
  ConsumerState<ListingDetailScreen> createState() =>
      _ListingDetailScreenState();
}

class _ListingDetailScreenState extends ConsumerState<ListingDetailScreen> {
  bool _viewRecorded = false;
  int _currentImageIndex = 0;

  int get listingId => widget.listingId;

  void _recordView() {
    if (_viewRecorded) return;
    _viewRecorded = true;
    final repository = ref.read(dalilakRepositoryProvider);
    repository.recordListingView(listingId).catchError((_) {});
  }

  @override
  Widget build(BuildContext context) {
    final listingAsync = ref.watch(listingByIdProvider(listingId));
    final isFavorite = ref.watch(
      favoritesProvider.select((fav) => fav.contains(listingId)),
    );

    return Scaffold(
      body: listingAsync.when(
        loading: () => const Scaffold(body: ListingDetailSkeleton()),
        error: (error, stack) => _buildErrorWidget(context, ref),
        data: (listing) {
          _recordView();
          return _buildDetailWidget(context, ref, listing, isFavorite);
        },
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded,
                size: 72, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Text('حدث خطأ في تحميل البيانات',
                style: theme.textTheme.bodyMedium),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => ref.invalidate(listingByIdProvider(listingId)),
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
    final theme = Theme.of(context);

    return CustomScrollView(
      slivers: [
        // ─── Image AppBar ───
        SliverAppBar(
          expandedHeight: 280,
          pinned: true,
          actions: [
            // Favorite
            Container(
              margin: const EdgeInsets.only(left: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  color: isFavorite ? Colors.red : Colors.white,
                ),
                onPressed: () {
                  ref.read(favoritesProvider.notifier).toggleFavorite(listing.id);
                },
              ),
            ),
            // Share
            Container(
              margin: const EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.share_rounded, color: Colors.white),
                onPressed: () {
                  final parts = <String>[listing.name];
                  if (listing.description != null) parts.add(listing.description!);
                  if (listing.phone != null) parts.add('هاتف: ${listing.phone}');
                  Share.share(parts.join('\n\n'), subject: listing.name);
                },
              ),
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: listing.images.isEmpty
                ? Container(
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: Icon(Icons.image_outlined,
                        size: 64,
                        color: theme.colorScheme.onSurface.withOpacity(0.15)),
                  )
                : Stack(
                    children: [
                      PageView.builder(
                        itemCount: listing.images.length,
                        onPageChanged: (i) =>
                            setState(() => _currentImageIndex = i),
                        itemBuilder: (context, index) {
                          return Image.network(
                            AppConstants.imageUrl(
                                listing.images[index].imageUrl),
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: theme.colorScheme.surfaceContainerHighest,
                              child: const Icon(Icons.image_not_supported),
                            ),
                          );
                        },
                      ),
                      // Image indicator
                      if (listing.images.length > 1)
                        Positioned(
                          bottom: 12,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(listing.images.length, (i) {
                              final active = i == _currentImageIndex;
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: const EdgeInsets.symmetric(horizontal: 3),
                                width: active ? 20 : 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: active
                                      ? Colors.white
                                      : Colors.white.withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              );
                            }),
                          ),
                        ),
                      // Image count badge
                      if (listing.images.length > 1)
                        Positioned(
                          top: 80,
                          left: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              '${_currentImageIndex + 1}/${listing.images.length}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
          ),
        ),

        // ─── Content ───
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title & Badges
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      listing.name,
                      style: theme.textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        if (listing.isFeatured)
                          _InfoChip(
                            icon: Icons.star_rounded,
                            label: 'مميز',
                            color: theme.colorScheme.tertiary,
                          ),
                        if (listing.category != null)
                          _InfoChip(
                            icon: Icons.category_outlined,
                            label: listing.category!.name,
                            color: theme.colorScheme.primary,
                          ),
                        if (listing.governorate != null)
                          _InfoChip(
                            icon: Icons.location_on_outlined,
                            label: listing.governorate!.name,
                            color: theme.colorScheme.secondary,
                          ),
                        _InfoChip(
                          icon: Icons.visibility_outlined,
                          label: '${listing.viewCount} مشاهدة',
                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Divider(),

              // Description
              if (listing.description != null &&
                  listing.description!.isNotEmpty)
                _DetailSection(
                  icon: Icons.description_outlined,
                  title: 'الوصف',
                  child: Text(
                    listing.description!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      height: 1.6,
                    ),
                  ),
                ),

              // Contact Information
              if (_hasContactInfo(listing))
                _DetailSection(
                  icon: Icons.phone_outlined,
                  title: 'معلومات الاتصال',
                  child: _buildContactButtons(listing, theme),
                ),

              // Address
              if (listing.address != null && listing.address!.isNotEmpty)
                _DetailSection(
                  icon: Icons.pin_drop_outlined,
                  title: 'العنوان',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(listing.address!, style: theme.textTheme.bodyMedium),
                      if (listing.locationLat != null && listing.locationLng != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: SizedBox(
                            width: double.infinity,
                            child: Material(
                              color: theme.colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(14),
                              child: InkWell(
                                onTap: () => _launchUrl(
                                  'https://www.google.com/maps/search/?api=1&query=${listing.locationLat},${listing.locationLng}',
                                ),
                                borderRadius: BorderRadius.circular(14),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.map_rounded, size: 20, color: theme.colorScheme.primary),
                                      const SizedBox(width: 8),
                                      Text(
                                        'عرض على الخريطة',
                                        style: TextStyle(
                                          color: theme.colorScheme.primary,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

              // Map button (when no address but has coordinates)
              if ((listing.address == null || listing.address!.isEmpty) &&
                  listing.locationLat != null && listing.locationLng != null)
                _DetailSection(
                  icon: Icons.pin_drop_outlined,
                  title: 'الموقع',
                  child: SizedBox(
                    width: double.infinity,
                    child: Material(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(14),
                      child: InkWell(
                        onTap: () => _launchUrl(
                          'https://www.google.com/maps/search/?api=1&query=${listing.locationLat},${listing.locationLng}',
                        ),
                        borderRadius: BorderRadius.circular(14),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.map_rounded, size: 20, color: theme.colorScheme.primary),
                              const SizedBox(width: 8),
                              Text(
                                'عرض على الخريطة',
                                style: TextStyle(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              // Social Media
              if (_hasSocialMedia(listing))
                _DetailSection(
                  icon: Icons.share_outlined,
                  title: 'تابعنا على',
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      if (listing.instagram != null)
                        _SocialButton(
                          label: 'Instagram',
                          color: const Color(0xFFE1306C),
                          onTap: () => _launchUrl(
                              'https://instagram.com/${listing.instagram}'),
                        ),
                      if (listing.facebook != null)
                        _SocialButton(
                          label: 'Facebook',
                          color: const Color(0xFF1877F2),
                          onTap: () => _launchUrl(
                              'https://facebook.com/${listing.facebook}'),
                        ),
                      if (listing.tiktok != null)
                        _SocialButton(
                          label: 'TikTok',
                          color: const Color(0xFFEE1D52),
                          onTap: () => _launchUrl(
                              'https://tiktok.com/@${listing.tiktok}'),
                        ),
                    ],
                  ),
                ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactButtons(Listing listing, ThemeData theme) {
    return Column(
      children: [
        if (listing.phone != null)
          _ContactTile(
            icon: Icons.phone_rounded,
            iconColor: Colors.green,
            label: 'اتصل',
            value: listing.phone!,
            onTap: () => _launchUrl('tel:${listing.phone}'),
          ),
        if (listing.whatsapp != null)
          _ContactTile(
            icon: Icons.chat_rounded,
            iconColor: const Color(0xFF25D366),
            label: 'واتس آب',
            value: listing.whatsapp!,
            onTap: () => _launchUrl('https://wa.me/${listing.whatsapp}'),
          ),
        if (listing.email != null)
          _ContactTile(
            icon: Icons.email_rounded,
            iconColor: Colors.orange,
            label: 'بريد إلكتروني',
            value: listing.email!,
            onTap: () => _launchUrl('mailto:${listing.email}'),
          ),
        if (listing.website != null)
          _ContactTile(
            icon: Icons.language_rounded,
            iconColor: theme.colorScheme.primary,
            label: 'الموقع الإلكتروني',
            value: listing.website!,
            onTap: () => _launchUrl(listing.website!),
          ),
      ],
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

  Future<void> _launchUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    } catch (_) {}
  }
}

// ─── Info Chip ─────────────────────────────────────────────────────

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Detail Section ────────────────────────────────────────────────

class _DetailSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;

  const _DetailSection({
    required this.icon,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
          child: Row(
            children: [
              Icon(icon, size: 20, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(title, style: theme.textTheme.titleMedium),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: child,
        ),
        const SizedBox(height: 8),
        const Divider(),
      ],
    );
  }
}

// ─── Contact Tile ──────────────────────────────────────────────────

class _ContactTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final VoidCallback onTap;

  const _ContactTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: theme.colorScheme.primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, size: 20, color: iconColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                      Text(
                        value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_back_ios_rounded,
                    size: 14,
                    color: theme.colorScheme.onSurface.withOpacity(0.3)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Social Button ─────────────────────────────────────────────────

class _SocialButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _SocialButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}
