import 'package:freezed_annotation/freezed_annotation.dart';

part 'ad_model.freezed.dart';
part 'ad_model.g.dart';

@freezed
class Ad with _$Ad {
  const factory Ad({
    required int id,
    required String image,
    String? linkType,
    int? linkId,
    String? linkUrl,
    @Default(0) int order,
    DateTime? startDate,
    DateTime? endDate,
    @Default(true) bool isActive,
    required DateTime createdAt,
  }) = _Ad;

  factory Ad.fromJson(Map<String, dynamic> json) => _$AdFromJson(json);
}
