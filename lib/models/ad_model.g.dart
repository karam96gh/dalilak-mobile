// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ad_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AdImpl _$$AdImplFromJson(Map<String, dynamic> json) => _$AdImpl(
      id: (json['id'] as num).toInt(),
      image: json['image'] as String,
      linkType: json['linkType'] as String?,
      linkId: (json['linkId'] as num?)?.toInt(),
      linkUrl: json['linkUrl'] as String?,
      order: (json['order'] as num?)?.toInt() ?? 0,
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$AdImplToJson(_$AdImpl instance) => <String, dynamic>{
      'id': instance.id,
      'image': instance.image,
      'linkType': instance.linkType,
      'linkId': instance.linkId,
      'linkUrl': instance.linkUrl,
      'order': instance.order,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
    };
