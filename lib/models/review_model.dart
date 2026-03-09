import 'package:freezed_annotation/freezed_annotation.dart';

part 'review_model.freezed.dart';
part 'review_model.g.dart';

@freezed
class Review with _$Review {
  const factory Review({
    required String id,
    required String listingId,
    required String userId,
    required String userName,
    required String userImage,
    required int rating, // 1-5
    required String comment,
    required DateTime createdAt,
    @Default(0) int likesCount,
    @Default(false) bool isVerifiedBuyer,
  }) = _Review;

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);
}

@freezed
class RatingStats with _$RatingStats {
  const factory RatingStats({
    required double averageRating,
    required int totalReviews,
    @Default(0) int fiveStarCount,
    @Default(0) int fourStarCount,
    @Default(0) int threeStarCount,
    @Default(0) int twoStarCount,
    @Default(0) int oneStarCount,
  }) = _RatingStats;

  factory RatingStats.fromJson(Map<String, dynamic> json) =>
      _$RatingStatsFromJson(json);
}
