// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReviewImpl _$$ReviewImplFromJson(Map<String, dynamic> json) => _$ReviewImpl(
      id: json['id'] as String,
      listingId: json['listingId'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      userImage: json['userImage'] as String,
      rating: (json['rating'] as num).toInt(),
      comment: json['comment'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      likesCount: (json['likesCount'] as num?)?.toInt() ?? 0,
      isVerifiedBuyer: json['isVerifiedBuyer'] as bool? ?? false,
    );

Map<String, dynamic> _$$ReviewImplToJson(_$ReviewImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'listingId': instance.listingId,
      'userId': instance.userId,
      'userName': instance.userName,
      'userImage': instance.userImage,
      'rating': instance.rating,
      'comment': instance.comment,
      'createdAt': instance.createdAt.toIso8601String(),
      'likesCount': instance.likesCount,
      'isVerifiedBuyer': instance.isVerifiedBuyer,
    };

_$RatingStatsImpl _$$RatingStatsImplFromJson(Map<String, dynamic> json) =>
    _$RatingStatsImpl(
      averageRating: (json['averageRating'] as num).toDouble(),
      totalReviews: (json['totalReviews'] as num).toInt(),
      fiveStarCount: (json['fiveStarCount'] as num?)?.toInt() ?? 0,
      fourStarCount: (json['fourStarCount'] as num?)?.toInt() ?? 0,
      threeStarCount: (json['threeStarCount'] as num?)?.toInt() ?? 0,
      twoStarCount: (json['twoStarCount'] as num?)?.toInt() ?? 0,
      oneStarCount: (json['oneStarCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$RatingStatsImplToJson(_$RatingStatsImpl instance) =>
    <String, dynamic>{
      'averageRating': instance.averageRating,
      'totalReviews': instance.totalReviews,
      'fiveStarCount': instance.fiveStarCount,
      'fourStarCount': instance.fourStarCount,
      'threeStarCount': instance.threeStarCount,
      'twoStarCount': instance.twoStarCount,
      'oneStarCount': instance.oneStarCount,
    };
