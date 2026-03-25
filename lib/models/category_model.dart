import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_model.freezed.dart';
part 'category_model.g.dart';

@freezed
class CategoryCount with _$CategoryCount {
  const factory CategoryCount({
    @Default(0) int children,
    @Default(0) int listings,
  }) = _CategoryCount;

  factory CategoryCount.fromJson(Map<String, dynamic> json) =>
      _$CategoryCountFromJson(json);
}

@freezed
class Category with _$Category {
  const factory Category({
    required int id,
    required String name,
    String? icon,
    String? image,
    int? parentId,
    @Default(1) int level,
    @Default(0) int order,
    @Default(true) bool isActive,
    @Default([]) List<Category> children,
    // Freezed uses constructor params; suppress analyzer target warning.
    // ignore: invalid_annotation_target
    @JsonKey(name: '_count') CategoryCount? count,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
}
