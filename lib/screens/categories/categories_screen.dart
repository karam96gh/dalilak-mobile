import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/category_model.dart';
import '../../providers/data_providers.dart';
import '../../widgets/shimmer_skeletons.dart';

class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen> {
  late List<Category> allCategories;
  List<Category> filteredCategories = [];
  String searchQuery = '';
  int? expandedCategoryId;

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('التصنيفات'),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchBar(
              hintText: 'ابحث عن تصنيف...',
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                  _filterCategories();
                });
              },
            ),
          ),
        ),
      ),
      body: categoriesAsync.when(
        loading: () => ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: 8,
          itemBuilder: (_, __) => ListItemSkeleton(),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
              const SizedBox(height: 16),
              const Text('حدث خطأ في تحميل التصنيفات'),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  ref.refresh(categoriesProvider);
                },
                icon: const Icon(Icons.refresh),
                label: const Text('إعادة محاولة'),
              ),
            ],
          ),
        ),
        data: (categories) {
          allCategories = categories;
          _filterCategories();
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: filteredCategories.length,
            itemBuilder: (context, index) {
              final category = filteredCategories[index];
              final isExpanded = expandedCategoryId == category.id;
              return CategoryTile(
                category: category,
                isExpanded: isExpanded,
                onTap: () {
                  setState(() {
                    expandedCategoryId = isExpanded ? null : category.id;
                  });
                },
                onCategorySelected: (selectedCategory) {
                  context.go('/listings?categoryId=${selectedCategory.id}');
                },
              );
            },
          );
        },
      ),
    );
  }

  void _filterCategories() {
    if (searchQuery.isEmpty) {
      filteredCategories = allCategories;
    } else {
      filteredCategories = allCategories
          .where((cat) => cat.name.contains(searchQuery))
          .toList();
    }
  }
}

class CategoryTile extends StatelessWidget {
  final Category category;
  final bool isExpanded;
  final VoidCallback onTap;
  final Function(Category) onCategorySelected;

  const CategoryTile({
    Key? key,
    required this.category,
    required this.isExpanded,
    required this.onTap,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.primaries[category.id % Colors.primaries.length]
                  .withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.category,
              color: Colors.primaries[category.id % Colors.primaries.length],
            ),
          ),
          title: Text(category.name),
          trailing: category.children.isNotEmpty
              ? Icon(isExpanded ? Icons.expand_less : Icons.expand_more)
              : null,
          onTap: () {
            if (category.children.isNotEmpty) {
              onTap();
            } else {
              onCategorySelected(category);
            }
          },
        ),
        if (isExpanded && category.children.isNotEmpty)
          Container(
            color: Colors.grey[50],
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.only(left: 24, right: 8),
              itemCount: category.children.length,
              itemBuilder: (context, index) {
                final child = category.children[index];
                return ListTile(
                  title: Text(child.name),
                  trailing: const Icon(Icons.chevron_right,
                      size: 20, color: Colors.grey),
                  onTap: () => onCategorySelected(child),
                );
              },
            ),
          ),
      ],
    );
  }
}
