// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listing_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ListingImageImpl _$$ListingImageImplFromJson(Map<String, dynamic> json) =>
    _$ListingImageImpl(
      id: (json['id'] as num).toInt(),
      listingId: (json['listingId'] as num).toInt(),
      imageUrl: json['imageUrl'] as String,
      order: (json['order'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$ListingImageImplToJson(_$ListingImageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'listingId': instance.listingId,
      'imageUrl': instance.imageUrl,
      'order': instance.order,
    };

_$ListingImpl _$$ListingImplFromJson(Map<String, dynamic> json) =>
    _$ListingImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String?,
      categoryId: (json['categoryId'] as num).toInt(),
      governorateId: (json['governorateId'] as num).toInt(),
      phone: json['phone'] as String?,
      whatsapp: json['whatsapp'] as String?,
      email: json['email'] as String?,
      website: json['website'] as String?,
      instagram: json['instagram'] as String?,
      facebook: json['facebook'] as String?,
      tiktok: json['tiktok'] as String?,
      locationLat: (json['locationLat'] as num?)?.toDouble(),
      locationLng: (json['locationLng'] as num?)?.toDouble(),
      address: json['address'] as String?,
      isFeatured: json['isFeatured'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
      viewCount: (json['viewCount'] as num?)?.toInt() ?? 0,
      category: json['category'] == null
          ? null
          : Category.fromJson(json['category'] as Map<String, dynamic>),
      governorate: json['governorate'] == null
          ? null
          : Governorate.fromJson(json['governorate'] as Map<String, dynamic>),
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => ListingImage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ListingImplToJson(_$ListingImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'categoryId': instance.categoryId,
      'governorateId': instance.governorateId,
      'phone': instance.phone,
      'whatsapp': instance.whatsapp,
      'email': instance.email,
      'website': instance.website,
      'instagram': instance.instagram,
      'facebook': instance.facebook,
      'tiktok': instance.tiktok,
      'locationLat': instance.locationLat,
      'locationLng': instance.locationLng,
      'address': instance.address,
      'isFeatured': instance.isFeatured,
      'isActive': instance.isActive,
      'viewCount': instance.viewCount,
      'category': instance.category,
      'governorate': instance.governorate,
      'images': instance.images,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
