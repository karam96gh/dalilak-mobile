import 'package:freezed_annotation/freezed_annotation.dart';
import 'category_model.dart';
import 'governorate_model.dart';

part 'listing_model.freezed.dart';
part 'listing_model.g.dart';

double? _toDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

@freezed
class ListingImage with _$ListingImage {
  const factory ListingImage({
    required int id,
    required int listingId,
    required String imageUrl,
    @Default(0) int order,
  }) = _ListingImage;

  factory ListingImage.fromJson(Map<String, dynamic> json) =>
      _$ListingImageFromJson(json);
}

@freezed
class Listing with _$Listing {
  const factory Listing({
    required int id,
    required String name,
    String? description,
    required int categoryId,
    required int governorateId,
    String? phone,
    String? whatsapp,
    String? email,
    String? website,
    String? instagram,
    String? facebook,
    String? tiktok,
    @JsonKey(fromJson: _toDouble) double? locationLat,
    @JsonKey(fromJson: _toDouble) double? locationLng,
    String? address,
    @Default(false) bool isFeatured,
    @Default(true) bool isActive,
    @Default(0) int viewCount,
    Category? category,
    Governorate? governorate,
    @Default([]) List<ListingImage> images,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Listing;

  factory Listing.fromJson(Map<String, dynamic> json) =>
      _$ListingFromJson(json);
}
