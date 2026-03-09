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

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey[300]!),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'تصفية النتائج',
                    style: Theme.of(context).textTheme.titleLarge,
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
                    // Categories Filter
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'التصنيفات',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 12),
                          categoriesAsync.when(
                            loading: () =>
                                const CircularProgressIndicator(),
                            error: (error, stack) => const Text('خطأ'),
                            data: (categories) => Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                FilterChip(
                                  label: const Text('الكل'),
                                  onSelected: (selected) {
                                    setState(() => _selectedCategoryId = null);
                                  },
                                  selected: _selectedCategoryId == null,
                                ),
                                ...categories.map((category) {
                                  return FilterChip(
                                    label: Text(category.name),
                                    selected:
                                        _selectedCategoryId == category.id,
                                    onSelected: (_) {
                                      setState(() {
                                        _selectedCategoryId =
                                            _selectedCategoryId == category.id
                                                ? null
                                                : category.id;
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

                    const Divider(),

                    // Governorates Filter
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'المحافظات',
                            style: Theme.of(context).textTheme.titleMedium,
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
                                    setState(
                                        () => _selectedGovernorateId = null);
                                  },
                                  selected: _selectedGovernorateId == null,
                                ),
                                ...governorates.map((governorate) {
                                  return FilterChip(
                                    label: Text(governorate.name),
                                    selected:
                                        _selectedGovernorateId ==
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
        );
      },
    );
  }
}
