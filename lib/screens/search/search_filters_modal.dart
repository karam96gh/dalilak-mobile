import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/data_providers.dart';

class SearchFiltersModal extends ConsumerStatefulWidget {
  final int? selectedCategoryId;
  final int? selectedGovernorateId;
  final Function(int?, int?) onFiltersChanged;

  const SearchFiltersModal({
    Key? key,
    this.selectedCategoryId,
    this.selectedGovernorateId,
    required this.onFiltersChanged,
  }) : super(key: key);

  @override
  ConsumerState<SearchFiltersModal> createState() =>
      _SearchFiltersModalState();
}

class _SearchFiltersModalState extends ConsumerState<SearchFiltersModal> {
  late int? _selectedCategoryId;
  late int? _selectedGovernorateId;
  int? _expandedCategoryId;

  @override
  void initState() {
    super.initState();
    _selectedCategoryId = widget.selectedCategoryId;
    _selectedGovernorateId = widget.selectedGovernorateId;
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final governoratesAsync = ref.watch(governoratesProvider);
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, -6),
              ),
            ],
          ),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 8),
              // Header
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'تصفية النتائج',
                      style: theme.textTheme.titleLarge,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      // Categories Filter (رئيسي + فرعي)
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'التصنيفات',
                              style: theme.textTheme.titleMedium,
                            ),
                            const SizedBox(height: 12),
                            categoriesAsync.when(
                              loading: () =>
                                  const CircularProgressIndicator(),
                              error: (error, stack) => const Text('خطأ'),
                              data: (categories) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: [
                                      FilterChip(
                                        label: const Text('الكل'),
                                        onSelected: (selected) {
                                          setState(() {
                                            _selectedCategoryId = null;
                                            _expandedCategoryId = null;
                                          });
                                        },
                                        selected: _selectedCategoryId == null,
                                      ),
                                      ...categories.map((category) {
                                        final isSelected =
                                            _selectedCategoryId ==
                                                category.id;
                                        final isExpanded =
                                            _expandedCategoryId ==
                                                category.id;
                                        return FilterChip(
                                          label: Text(category.name),
                                          selected: isSelected,
                                          onSelected: (_) {
                                            setState(() {
                                              _selectedCategoryId =
                                                  isSelected
                                                      ? null
                                                      : category.id;
                                              _expandedCategoryId =
                                                  isExpanded
                                                      ? null
                                                      : category.id;
                                            });
                                          },
                                        );
                                      }).toList(),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  if (_expandedCategoryId != null)
                                    _CategoryChildrenSection(
                                      parentId: _expandedCategoryId!,
                                      selectedCategoryId: _selectedCategoryId,
                                      onSelected: (id) {
                                        setState(() {
                                          _selectedCategoryId = id;
                                        });
                                      },
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Divider(),

                      // Governorates Filter
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'المحافظات',
                              style: theme.textTheme.titleMedium,
                            ),
                            const SizedBox(height: 12),
                            governoratesAsync.when(
                              loading: () =>
                                  const CircularProgressIndicator(),
                              error: (error, stack) => const Text('خطأ'),
                              data: (governorates) => Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  FilterChip(
                                    label: const Text('الكل'),
                                    onSelected: (selected) {
                                      setState(() =>
                                          _selectedGovernorateId = null);
                                    },
                                    selected:
                                        _selectedGovernorateId == null,
                                  ),
                                  ...governorates.map((governorate) {
                                    return FilterChip(
                                      label: Text(governorate.name),
                                      selected: _selectedGovernorateId ==
                                          governorate.id,
                                      onSelected: (_) {
                                        setState(() {
                                          _selectedGovernorateId =
                                              _selectedGovernorateId ==
                                                      governorate.id
                                                  ? null
                                                  : governorate.id;
                                        });
                                      },
                                    );
                                  }).toList(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              // Action Buttons
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _selectedCategoryId = null;
                            _selectedGovernorateId = null;
                            _expandedCategoryId = null;
                          });
                        },
                        child: const Text('إعادة تعيين'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          widget.onFiltersChanged(
                            _selectedCategoryId,
                            _selectedGovernorateId,
                          );
                          Navigator.pop(context);
                        },
                        child: const Text('تطبيق'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CategoryChildrenSection extends ConsumerWidget {
  final int parentId;
  final int? selectedCategoryId;
  final ValueChanged<int?> onSelected;

  const _CategoryChildrenSection({
    Key? key,
    required this.parentId,
    required this.selectedCategoryId,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final childrenAsync = ref.watch(categoryChildrenProvider(parentId));

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: childrenAsync.when(
        loading: () => const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: LinearProgressIndicator(minHeight: 2),
        ),
        error: (error, stack) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            'تعذر تحميل الأصناف الفرعية',
            style: theme.textTheme.bodySmall
                ?.copyWith(color: theme.colorScheme.error),
          ),
        ),
        data: (children) {
          if (children.isEmpty) {
            return const SizedBox.shrink();
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                'الأقسام الفرعية',
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: children.map((child) {
                  final isSelected = selectedCategoryId == child.id;
                  return FilterChip(
                    label: Text(child.name),
                    selected: isSelected,
                    onSelected: (_) => onSelected(
                      isSelected ? null : child.id,
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        },
      ),
    );
  }
}
