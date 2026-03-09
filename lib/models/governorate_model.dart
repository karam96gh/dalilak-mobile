import 'package:freezed_annotation/freezed_annotation.dart';

part 'governorate_model.freezed.dart';
part 'governorate_model.g.dart';

@freezed
class Governorate with _$Governorate {
  const factory Governorate({
    required int id,
    required String name,
    @Default(true) bool isActive,
    @Default(0) int order,
  }) = _Governorate;

  factory Governorate.fromJson(Map<String, dynamic> json) =>
      _$GovernorateFromJson(json);
}
