// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationImpl _$$NotificationImplFromJson(Map<String, dynamic> json) =>
    _$NotificationImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      body: json['body'] as String,
      image: json['image'] as String?,
      linkType: json['linkType'] as String?,
      linkId: (json['linkId'] as num?)?.toInt(),
      linkUrl: json['linkUrl'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$NotificationImplToJson(_$NotificationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'image': instance.image,
      'linkType': instance.linkType,
      'linkId': instance.linkId,
      'linkUrl': instance.linkUrl,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
    };
