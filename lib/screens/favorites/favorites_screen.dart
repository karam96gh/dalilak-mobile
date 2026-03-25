import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../constants/app_constants.dart';
import '../../providers/data_providers.dart';
import '../../widgets/shimmer_skeletons.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteIds = ref.watch(favoritesProvider);
    final favoriteListingsAsync = ref.watch(favoriteListingsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('المفضلة'),
        elevation: 0,
        actions: [
          if (favoriteIds.isNotEmpty)
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('مسح المفضلة'),
                    content: const Text('هل تريد مسح جميع العناصر المفضلة؟'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('إلغاء'),
                      ),
                      TextButton(
                        onPressed: () {
                          for (final id in List<int>.from(favoriteIds)) {
                            ref
                                .read(favoritesProvider.notifier)
                                .toggleFavorite(id);
                          }
                          Navigator.pop(ctx);
                        },
                        child: Text('مسح الكل',
                            style:
                                TextStyle(color: theme.colorScheme.error)),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('مسح الكل'),
            ),
        ],
      ),
      body: favoriteIds.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_outline_rounded,
                      size: 72,
                      color: theme.colorScheme.primary.withOpacity(0.2)),
                  const SizedBox(height: 16),
                  Text('لا توجد عناصر مفضلة',
                      style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(
                    'اضغط على القلب في أي محتوى لإضافته هنا',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => context.go('/home'),
                    icon: const Icon(Icons.explore_outlined),
                    label: const Text('استكشف المحتويات'),
                  ),
                ],
              ),
            )
          : favoriteListingsAsync.when(
              loading: () => ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: favoriteIds.length.clamp(0, 6),
                itemBuilder: (_, __) => const ListingCardSkeleton(),
              ),
              error: (_, __) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline_rounded,
                        size: 72, color: theme.colorScheme.error),
                    const SizedBox(height: 16),
                    Text('حدث خطأ في تحميل المفضلة',
                        style: theme.textTheme.bodyMedium),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () =>
                          ref.invalidate(favoriteListingsProvider),
                      icon: const Icon(Icons.refresh),
                      label: const Text('إعادة محاولة'),
                    ),
                  ],
                ),
              ),
              data: (favorites) {
                if (favorites.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.favorite_outline_rounded,
                            size: 72,
                            color:
                                theme.colorScheme.primary.withOpacity(0.2)),
                        const SizedBox(height: 16),
                        Text('لا توجد عناصر مفضلة',
                            style: theme.textTheme.titleMedium),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    final listing = favorites[index];
                    return Dismissible(
                      key: ValueKey(listing.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.error,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 24),
                        child: const Icon(Icons.delete_outline_rounded,
                            color: Colors.white),
                      ),
                      onDismissed: (_) {
                        ref
                            .read(favoritesProvider.notifier)
                            .toggleFavorite(listing.id);
                      },
                      child: Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: () =>
                              context.push('/listing/${listing.id}'),
                          child: Row(
                            children: [
                              // Image
                              Container(
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(
                                  image: listing.images.isNotEmpty
                                      ? DecorationImage(
                                          image: NetworkImage(
                                              AppConstants.imageUrl(
                                                  listing.images[0]
                                                      .imageUrl)),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                  color: theme.colorScheme
                                      .surfaceContainerHighest,
                                ),
                                child: listing.images.isEmpty
                                    ? Icon(Icons.image_outlined,
                                        size: 32,
                                        color: theme.colorScheme.onSurface
                                            .withOpacity(0.2))
                                    : null,
                              ),
                              // Info
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        listing.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: theme.textTheme.titleSmall
                                            ?.copyWith(
                                                fontWeight:
                                                    FontWeight.w700),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(Icons.category_outlined,
                                              size: 13,
                                              color: theme
                                                  .colorScheme.onSurface
                                                  .withOpacity(0.5)),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              listing.category?.name ??
                                                  'غير محدد',
                                              maxLines: 1,
                                              overflow:
                                                  TextOverflow.ellipsis,
                                              style: theme
                                                  .textTheme.bodySmall
                                                  ?.copyWith(
                                                color: theme
                                                    .colorScheme.onSurface
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
                                              color: theme
                                                  .colorScheme.onSurface
                                                  .withOpacity(0.5)),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              listing.governorate?.name ??
                                                  'غير محدد',
                                              maxLines: 1,
                                              overflow:
                                                  TextOverflow.ellipsis,
                                              style: theme
                                                  .textTheme.bodySmall
                                                  ?.copyWith(
                                                color: theme
                                                    .colorScheme.onSurface
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
                              // Favorite button
                              IconButton(
                                icon: const Icon(Icons.favorite_rounded),
                                color: Colors.red,
                                onPressed: () {
                                  ref
                                      .read(favoritesProvider.notifier)
                                      .toggleFavorite(listing.id);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
