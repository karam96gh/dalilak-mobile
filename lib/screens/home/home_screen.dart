import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/ad_model.dart';
import '../../models/category_model.dart';
import '../../models/listing_model.dart';
import '../../constants/app_constants.dart';
import '../../config/app_theme.dart';
import '../../providers/data_providers.dart';
import '../../widgets/shimmer_skeletons.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final adsAsync = ref.watch(adsProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final latestAsync = ref.watch(latestListingsProvider);
    final featuredAsync = ref.watch(featuredListingsProvider);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.bgDark : AppTheme.bgLight,
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(adsProvider);
          ref.invalidate(categoriesProvider);
          ref.invalidate(latestListingsProvider);
          ref.invalidate(featuredListingsProvider);
        },
        color: theme.colorScheme.primary,
        child: CustomScrollView(
          slivers: [
            // ── Gradient App Bar ───────────────────────────────────────
            SliverAppBar(
              expandedHeight: 120,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(gradient: AppTheme.headerGradient),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            'مرحباً بك 👋',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'دليلك',
                            style: theme.textTheme.displayMedium?.copyWith(
                              color: Colors.white,
                              fontSize: 26,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              backgroundColor: AppTheme.primary,
              surfaceTintColor: Colors.transparent,
              actions: [
                Container(
                  margin: const EdgeInsets.only(left: 12, top: 8, bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.notifications_outlined,
                        color: Colors.white, size: 22),
                    onPressed: () => context.push('/notifications'),
                  ),
                ),
              ],
            ),

            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Ads Carousel ──────────────────────────────────────
                  adsAsync.when(
                    loading: () => const AdCarouselSkeleton(),
                    error: (_, __) => Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: _InlineError(
                        message: 'تعذّر تحميل الإعلانات',
                        onRetry: () => ref.invalidate(adsProvider),
                      ),
                    ),
                    data: (ads) => ads.isEmpty
                        ? const SizedBox.shrink()
                        : _AdsCarousel(ads: ads),
                  ),

                  const SizedBox(height: 16),

                  // ── Search Shortcut ───────────────────────────────────
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: _HomeSearchBar(),
                  ),

                  const SizedBox(height: 24),

                  // ── Categories Section ────────────────────────────────
                  _SectionHeader(
                    title: 'التصنيفات',
                    onSeeAll: () => context.go('/categories'),
                  ),
                  const SizedBox(height: 12),
                  categoriesAsync.when(
                    loading: () => const CategoryGridSkeleton(itemCount: 6),
                    error: (_, __) => Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: _InlineError(
                        message: 'تعذّر تحميل التصنيفات',
                        onRetry: () => ref.invalidate(categoriesProvider),
                      ),
                    ),
                    data: (cats) =>
                        _CategoriesGrid(categories: cats.take(8).toList()),
                  ),

                  const SizedBox(height: 28),

                  // ── Featured Listings ─────────────────────────────────
                  featuredAsync.when(
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                    data: (listings) => listings.isEmpty
                        ? const SizedBox.shrink()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _SectionHeader(
                                title: 'إعلانات مميزة',
                                onSeeAll: () => context.push('/listings'),
                              ),
                              const SizedBox(height: 12),
                              _FeaturedRow(listings: listings),
                              const SizedBox(height: 28),
                            ],
                          ),
                  ),

                  // ── Latest Listings ───────────────────────────────────
                  _SectionHeader(
                    title: 'آخر الإضافات',
                    onSeeAll: () => context.push('/listings'),
                  ),
                  const SizedBox(height: 12),
                  latestAsync.when(
                    loading: () => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 4,
                        itemBuilder: (_, __) => const ListingCardSkeleton(),
                      ),
                    ),
                    error: (_, __) => Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: _InlineError(
                        message: 'تعذّر تحميل آخر الإضافات',
                        onRetry: () =>
                            ref.invalidate(latestListingsProvider),
                      ),
                    ),
                    data: (listings) =>
                        _LatestListings(listings: listings),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Section Header
// ─────────────────────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;

  const _SectionHeader({required this.title, this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: theme.textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          if (onSeeAll != null)
            TextButton(
              onPressed: onSeeAll,
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.primary,
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
              child: Row(
                children: [
                  Text(
                    'عرض الكل',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 2),
                  Icon(Icons.arrow_back_ios,
                      size: 12, color: theme.colorScheme.primary),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Home Search Bar
// ─────────────────────────────────────────────────────────────────────────────
class _HomeSearchBar extends StatelessWidget {
  const _HomeSearchBar();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: isDark ? AppTheme.surfaceDark : const Color(0xFFEEEBF8),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () => context.go('/search'),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? const Color(0xFF2E2A45) : const Color(0xFFDDDAF0),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.search_rounded,
                color: theme.colorScheme.primary.withOpacity(0.7),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'ابحث عن نشاط، خدمة أو مكان...',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.45),
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.tune_rounded,
                    size: 16, color: theme.colorScheme.primary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Inline Error
// ─────────────────────────────────────────────────────────────────────────────
class _InlineError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _InlineError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.error.withOpacity(0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.error.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline_rounded,
              size: 18, color: theme.colorScheme.error),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error.withOpacity(0.9),
              ),
            ),
          ),
          const SizedBox(width: 4),
          TextButton(
            onPressed: onRetry,
            style: TextButton.styleFrom(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: const Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'إعادة',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Ads Carousel
// ─────────────────────────────────────────────────────────────────────────────
class _AdsCarousel extends StatefulWidget {
  final List<Ad> ads;
  const _AdsCarousel({required this.ads});

  @override
  State<_AdsCarousel> createState() => _AdsCarouselState();
}

class _AdsCarouselState extends State<_AdsCarousel> {
  late PageController _ctrl;
  int _current = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _ctrl = PageController(viewportFraction: 0.9);
    if (widget.ads.length > 1) {
      _timer = Timer.periodic(const Duration(seconds: 4), (_) {
        if (!mounted) return;
        final next = (_current + 1) % widget.ads.length;
        _ctrl.animateToPage(next,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut);
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  void _onTap(Ad ad) {
    if (ad.linkType == 'listing' && ad.linkId != null) {
      context.push('/listing/${ad.linkId}');
    } else if (ad.linkUrl != null && ad.linkUrl!.isNotEmpty) {
      launchUrl(Uri.parse(ad.linkUrl!));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        SizedBox(
          height: 190,
          child: PageView.builder(
            controller: _ctrl,
            onPageChanged: (i) => setState(() => _current = i),
            itemCount: widget.ads.length,
            itemBuilder: (_, i) {
              final ad = widget.ads[i];
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: i == _current ? 0 : 8,
                ),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () => _onTap(ad),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          AppConstants.imageUrl(ad.image),
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            decoration: const BoxDecoration(
                                gradient: AppTheme.primaryGradient),
                            child: const Center(
                              child: Icon(Icons.image_outlined,
                                  color: Colors.white54, size: 48),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        if (widget.ads.length > 1) ...[
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.ads.length, (i) {
              final active = i == _current;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: active ? 20 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: active
                      ? theme.colorScheme.primary
                      : theme.colorScheme.primary.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Categories Grid (2 rows, horizontally scrollable)
// ─────────────────────────────────────────────────────────────────────────────
class _CategoriesGrid extends StatelessWidget {
  final List<Category> categories;
  const _CategoriesGrid({required this.categories});

  static const List<List<Color>> _catGradients = [
    [Color(0xFF5C35C9), Color(0xFF8B5CF6)],
    [Color(0xFF00897B), Color(0xFF00BFA5)],
    [Color(0xFFE65100), Color(0xFFFF6D00)],
    [Color(0xFF1565C0), Color(0xFF1E88E5)],
    [Color(0xFF880E4F), Color(0xFFE91E63)],
    [Color(0xFF2E7D32), Color(0xFF43A047)],
    [Color(0xFF4A148C), Color(0xFF7B1FA2)],
    [Color(0xFF0277BD), Color(0xFF0288D1)],
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Split into 2 rows for a grid-like scroll
    final row1 = categories.length > 4 ? categories.sublist(0, 4) : categories;
    final row2 =
        categories.length > 4 ? categories.sublist(4) : <Category>[];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildRow(context, row1, 0, theme, isDark),
          if (row2.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildRow(context, row2, 4, theme, isDark),
          ],
        ],
      ),
    );
  }

  Widget _buildRow(BuildContext context, List<Category> cats, int offset,
      ThemeData theme, bool isDark) {
    return Row(
      children: List.generate(cats.length, (i) {
        final cat = cats[i];
        final grad = _catGradients[(i + offset) % _catGradients.length];
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: i > 0 ? 10 : 0),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () =>
                    context.push('/categories/${cat.id}'),
                borderRadius: BorderRadius.circular(16),
                child: Column(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: grad,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: grad[0].withOpacity(0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: cat.icon != null && cat.icon!.isNotEmpty
                            ? Text(cat.icon!,
                                style: const TextStyle(fontSize: 26))
                            : const Icon(Icons.category_rounded,
                                color: Colors.white, size: 26),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      cat.name,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Featured Listings Row
// ─────────────────────────────────────────────────────────────────────────────
class _FeaturedRow extends StatelessWidget {
  final List<Listing> listings;
  const _FeaturedRow({required this.listings});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 210,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: listings.length,
        itemBuilder: (context, i) {
          final l = listings[i];
          return Container(
            width: 170,
            margin: const EdgeInsets.only(left: 12),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(18),
              clipBehavior: Clip.antiAlias,
              elevation: 3,
              shadowColor: Colors.black26,
              child: InkWell(
                onTap: () => context.push('/listing/${l.id}'),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    l.images.isNotEmpty
                        ? Image.network(
                            AppConstants.imageUrl(l.images.first.imageUrl),
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              decoration: const BoxDecoration(
                                  gradient: AppTheme.primaryGradient),
                            ),
                          )
                        : Container(
                            decoration: const BoxDecoration(
                                gradient: AppTheme.primaryGradient),
                            child: const Icon(Icons.store_rounded,
                                color: Colors.white54, size: 40),
                          ),
                    // Gradient overlay
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.8),
                              Colors.transparent,
                            ],
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppTheme.accent,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text('مميز',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 10,
                                  )),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              l.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                            if (l.governorate != null) ...[
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  const Icon(Icons.location_on_outlined,
                                      size: 11, color: Colors.white70),
                                  const SizedBox(width: 3),
                                  Expanded(
                                    child: Text(
                                      l.governorate!.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                        color: Colors.white70,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Latest Listings
// ─────────────────────────────────────────────────────────────────────────────
class _LatestListings extends StatelessWidget {
  final List<Listing> listings;
  const _LatestListings({required this.listings});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: listings.map((l) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: isDark ? 0 : 1,
            shadowColor: Colors.black12,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: isDark
                    ? const Color(0xFF2E2A45)
                    : const Color(0xFFEEEBF8),
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => context.push('/listing/${l.id}'),
              child: Row(
                children: [
                  // Image
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: l.images.isNotEmpty
                          ? Image.network(
                              AppConstants.imageUrl(
                                  l.images.first.imageUrl),
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                decoration: const BoxDecoration(
                                    gradient: AppTheme.primaryGradient),
                                child: const Icon(Icons.store_rounded,
                                    color: Colors.white54, size: 32),
                              ),
                            )
                          : Container(
                              decoration: const BoxDecoration(
                                  gradient: AppTheme.primaryGradient),
                              child: const Icon(Icons.store_rounded,
                                  color: Colors.white54, size: 32),
                            ),
                    ),
                  ),
                  // Info
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (l.isFeatured)
                            Container(
                              margin: const EdgeInsets.only(bottom: 6),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppTheme.accent.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'مميز',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: AppTheme.accent,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          Text(
                            l.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          if (l.category != null)
                            _InfoRow(
                              icon: Icons.grid_view_rounded,
                              text: l.category!.name,
                              theme: theme,
                            ),
                          if (l.governorate != null)
                            _InfoRow(
                              icon: Icons.location_on_outlined,
                              text: l.governorate!.name,
                              theme: theme,
                            ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Icon(Icons.arrow_back_ios,
                        size: 14,
                        color: theme.colorScheme.onSurface.withOpacity(0.3)),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final ThemeData theme;

  const _InfoRow(
      {required this.icon, required this.text, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Row(
        children: [
          Icon(icon,
              size: 12,
              color: theme.colorScheme.onSurface.withOpacity(0.45)),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.55),
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
