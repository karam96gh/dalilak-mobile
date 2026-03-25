// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CategoryCountImpl _$$CategoryCountImplFromJson(Map<String, dynamic> json) =>
    _$CategoryCountImpl(
      children: (json['children'] as num?)?.toInt() ?? 0,
      listings: (json['listings'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$CategoryCountImplToJson(_$CategoryCountImpl instance) =>
    <String, dynamic>{
      'children': instance.children,
      'listings': instance.listings,
    };

_$CategoryImpl _$$CategoryImplFromJson(Map<String, dynamic> json) =>
    _$CategoryImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      icon: json['icon'] as String?,
      image: json['image'] as String?,
      parentId: (json['parentId'] as num?)?.toInt(),
      level: (json['level'] as num?)?.toInt() ?? 1,
      order: (json['order'] as num?)?.toInt() ?? 0,
      isActive: json['isActive'] as bool? ?? true,
      children: (json['children'] as List<dynamic>?)
              ?.map((e) => Category.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      count: json['_count'] == null
          ? null
          : CategoryCount.fromJson(json['_count'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$CategoryImplToJson(_$CategoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'icon': instance.icon,
      'image': instance.image,
      'parentId': instance.parentId,
      'level': instance.level,
      'order': instance.order,
      'isActive': instance.isActive,
      'children': instance.children,
      '_count': instance.count,
    };
