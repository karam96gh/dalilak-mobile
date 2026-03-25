import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/category_model.dart';
import '../../providers/data_providers.dart';
import '../../config/app_theme.dart';
import 'package:shimmer/shimmer.dart';

class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen> {
  String _searchQuery = '';
  int? _expandedCategoryId;

  List<Category> _filterCategories(List<Category> allCategories) {
    if (_searchQuery.trim().isEmpty) {
      return allCategories;
    }
    final q = _searchQuery.trim().toLowerCase();
    final results = <Category>[];

    for (final cat in allCategories) {
      // Match root category name
      if (cat.name.toLowerCase().contains(q)) {
        results.add(cat);
        continue;
      }
      // Deep search: match children names
      final matchingChildren = cat.children
          .where((child) => child.name.toLowerCase().contains(q))
          .toList();
      if (matchingChildren.isNotEmpty) {
        results.add(cat);
      }
    }
    return results;
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerHighest,
      appBar: AppBar(
        title: const Text('التصنيفات'),
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: SearchBar(
              hintText: 'ابحث عن تصنيف أو قسم فرعي...',
              elevation: WidgetStateProperty.all(0),
              backgroundColor: WidgetStateProperty.all(
                  isDark ? AppTheme.cardDark : AppTheme.cardLight),
              padding: WidgetStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 16)),
              leading: Icon(
                Icons.search_rounded,
                color: theme.colorScheme.primary.withOpacity(0.7),
              ),
              onChanged: (value) {
                setState(() => _searchQuery = value);
              },
            ),
          ),
        ),
      ),
      body: categoriesAsync.when(
        loading: () => const _CategoriesSkeleton(),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64,
                  color: theme.colorScheme.error),
              const SizedBox(height: 16),
              Text('حدث خطأ في تحميل التصنيفات',
                  style: theme.textTheme.bodyMedium),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => ref.invalidate(categoriesProvider),
                icon: const Icon(Icons.refresh),
                label: const Text('إعادة محاولة'),
              ),
            ],
          ),
        ),
        data: (categories) {
          final filteredCategories = _filterCategories(categories);

          if (filteredCategories.isEmpty) {
            return const _EmptyCategoriesState();
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            itemCount: filteredCategories.length,
            itemBuilder: (context, index) {
              final category = filteredCategories[index];
              final isExpanded = _expandedCategoryId == category.id;
              final hasChildren = category.children.isNotEmpty ||
                  (category.count?.children ?? 0) > 0;

              return TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                tween: Tween(begin: 0.96, end: 1),
                builder: (context, scale, child) {
                  return Transform.scale(
                    scale: scale,
                    alignment: Alignment.center,
                    child: child,
                  );
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: theme.cardTheme.color,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(
                          isExpanded ? 0.08 : 0.04,
                        ),
                        blurRadius: isExpanded ? 18 : 10,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: CategoryTile(
                    category: category,
                    isExpanded: isExpanded,
                    hasChildren: hasChildren,
                    onTap: () {
                      setState(() {
                        _expandedCategoryId =
                            isExpanded ? null : category.id;
                      });
                    },
                    onCategorySelected: (selectedCategory) {
                      context.push(
                          '/listings?categoryId=${selectedCategory.id}');
                    },
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

class CategoryTile extends ConsumerWidget {
  final Category category;
  final bool isExpanded;
  final bool hasChildren;
  final VoidCallback onTap;
  final Function(Category) onCategorySelected;

  const CategoryTile({
    Key? key,
    required this.category,
    required this.isExpanded,
    required this.hasChildren,
    required this.onTap,
    required this.onCategorySelected,
  }) : super(key: key);

  static const List<List<Color>> _catGradients = [
    [Color(0xFF5C35C9), Color(0xFF8B5CF6)],
    [Color(0xFF00897B), Color(0xFF00BFA5)],
    [Color(0xFFE65100), Color(0xFFFF6D00)],
    [Color(0xFF1565C0), Color(0xFF1E88E5)],
    [Color(0xFF880E4F), Color(0xFFE91E63)],
    [Color(0xFF2E7D32), Color(0xFF43A047)],
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final grad = _catGradients[category.id % _catGradients.length];

    return Column(
      children: [
        ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: grad),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: category.icon != null && category.icon!.isNotEmpty
                  ? Text(category.icon!, style: const TextStyle(fontSize: 24))
                  : const Icon(Icons.category_rounded, color: Colors.white),
            ),
          ),
          title: Text(
            category.name,
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          subtitle: hasChildren
              ? Text(
                  '${category.count?.children ?? category.children.length} أصناف فرعية',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: Colors.grey.shade500),
                )
              : Text(
                  'عرض المحتويات',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary.withOpacity(0.7),
                  ),
                ),
          trailing: AnimatedRotation(
            duration: const Duration(milliseconds: 200),
            turns: hasChildren && isExpanded ? 0.5 : 0,
            child: Icon(
              hasChildren
                  ? Icons.keyboard_arrow_down_rounded
                  : Icons.arrow_forward_ios_rounded,
              size: hasChildren ? 24 : 16,
              color: hasChildren
                  ? Colors.grey.shade500
                  : theme.colorScheme.primary,
            ),
          ),
          onTap: () {
            if (hasChildren) {
              onTap();
            } else {
              onCategorySelected(category);
            }
          },
        ),
        if (isExpanded && hasChildren)
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: _buildSubcategories(context, ref),
          ),
      ],
    );
  }

  Widget _buildSubcategories(BuildContext context, WidgetRef ref) {
    if (category.children.isNotEmpty) {
      return _buildChildrenList(context, category.children);
    }

    final categoryDetailAsync = ref.watch(categoryByIdProvider(category.id));
    return categoryDetailAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
            child: Text('خطأ في التحميل',
                style: TextStyle(color: Colors.red[400]))),
      ),
      data: (detailedCategory) {
        if (detailedCategory.children.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(
                child: Text('لا توجد أصناف فرعية',
                    style: TextStyle(color: Colors.grey))),
          );
        }
        return _buildChildrenList(context, detailedCategory.children);
      },
    );
  }

  Widget _buildChildrenList(BuildContext context, List<Category> children) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF252236) : const Color(0xFFF9F9FC),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16),
        itemCount: children.length,
        separatorBuilder: (_, __) => Divider(
          color: isDark ? const Color(0xFF3B3654) : const Color(0xFFEBE9F1),
          height: 1,
        ),
        itemBuilder: (context, index) {
          final child = children[index];
          final hasGrandChildren =
              (child.count?.children ?? 0) > 0 || child.children.isNotEmpty;

          return ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            leading: child.icon != null && child.icon!.isNotEmpty
                ? Text(child.icon!, style: const TextStyle(fontSize: 20))
                : const Icon(Icons.circle, size: 8, color: Color(0xFF5C35C9)),
            title: Text(
              child.name,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Cairo'),
            ),
            subtitle: hasGrandChildren
                ? Text(
                    '${child.count?.children ?? child.children.length} أصناف',
                    style:
                        const TextStyle(fontSize: 11, color: Colors.grey),
                  )
                : Text(
                    'عرض المحتويات',
                    style: TextStyle(
                      fontSize: 11,
                      color: theme.colorScheme.primary.withOpacity(0.6),
                    ),
                  ),
            trailing: Icon(
              hasGrandChildren
                  ? Icons.chevron_right_rounded
                  : Icons.arrow_forward_ios_rounded,
              size: hasGrandChildren ? 20 : 12,
              color: hasGrandChildren
                  ? const Color(0xFF9E9BB8)
                  : theme.colorScheme.primary.withOpacity(0.5),
            ),
            onTap: () {
              if (hasGrandChildren) {
                context.push('/categories/${child.id}');
              } else {
                onCategorySelected(child);
              }
            },
          );
        },
      ),
    );
  }
}

class _CategoriesSkeleton extends StatelessWidget {
  const _CategoriesSkeleton();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Shimmer.fromColors(
            baseColor: theme.colorScheme.surface.withOpacity(0.4),
            highlightColor: theme.colorScheme.surface,
            child: Container(
              height: 72,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _EmptyCategoriesState extends StatelessWidget {
  const _EmptyCategoriesState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.category_outlined,
            size: 72,
            color: theme.colorScheme.primary.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text('لا يوجد نتائج', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            'جرّب كتابة كلمة أخرى أو تقليل التصفية',
            style: theme.textTheme.bodySmall
                ?.copyWith(color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}
