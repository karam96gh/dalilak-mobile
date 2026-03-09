// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'review_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Review _$ReviewFromJson(Map<String, dynamic> json) {
  return _Review.fromJson(json);
}

/// @nodoc
mixin _$Review {
  String get id => throw _privateConstructorUsedError;
  String get listingId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get userName => throw _privateConstructorUsedError;
  String get userImage => throw _privateConstructorUsedError;
  int get rating => throw _privateConstructorUsedError; // 1-5
  String get comment => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  int get likesCount => throw _privateConstructorUsedError;
  bool get isVerifiedBuyer => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ReviewCopyWith<Review> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReviewCopyWith<$Res> {
  factory $ReviewCopyWith(Review value, $Res Function(Review) then) =
      _$ReviewCopyWithImpl<$Res, Review>;
  @useResult
  $Res call(
      {String id,
      String listingId,
      String userId,
      String userName,
      String userImage,
      int rating,
      String comment,
      DateTime createdAt,
      int likesCount,
      bool isVerifiedBuyer});
}

/// @nodoc
class _$ReviewCopyWithImpl<$Res, $Val extends Review>
    implements $ReviewCopyWith<$Res> {
  _$ReviewCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? listingId = null,
    Object? userId = null,
    Object? userName = null,
    Object? userImage = null,
    Object? rating = null,
    Object? comment = null,
    Object? createdAt = null,
    Object? likesCount = null,
    Object? isVerifiedBuyer = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      listingId: null == listingId
          ? _value.listingId
          : listingId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      userImage: null == userImage
          ? _value.userImage
          : userImage // ignore: cast_nullable_to_non_nullable
              as String,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as int,
      comment: null == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      likesCount: null == likesCount
          ? _value.likesCount
          : likesCount // ignore: cast_nullable_to_non_nullable
              as int,
      isVerifiedBuyer: null == isVerifiedBuyer
          ? _value.isVerifiedBuyer
          : isVerifiedBuyer // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReviewImplCopyWith<$Res> implements $ReviewCopyWith<$Res> {
  factory _$$ReviewImplCopyWith(
          _$ReviewImpl value, $Res Function(_$ReviewImpl) then) =
      __$$ReviewImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String listingId,
      String userId,
      String userName,
      String userImage,
      int rating,
      String comment,
      DateTime createdAt,
      int likesCount,
      bool isVerifiedBuyer});
}

/// @nodoc
class __$$ReviewImplCopyWithImpl<$Res>
    extends _$ReviewCopyWithImpl<$Res, _$ReviewImpl>
    implements _$$ReviewImplCopyWith<$Res> {
  __$$ReviewImplCopyWithImpl(
      _$ReviewImpl _value, $Res Function(_$ReviewImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? listingId = null,
    Object? userId = null,
    Object? userName = null,
    Object? userImage = null,
    Object? rating = null,
    Object? comment = null,
    Object? createdAt = null,
    Object? likesCount = null,
    Object? isVerifiedBuyer = null,
  }) {
    return _then(_$ReviewImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      listingId: null == listingId
          ? _value.listingId
          : listingId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      userImage: null == userImage
          ? _value.userImage
          : userImage // ignore: cast_nullable_to_non_nullable
              as String,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as int,
      comment: null == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      likesCount: null == likesCount
          ? _value.likesCount
          : likesCount // ignore: cast_nullable_to_non_nullable
              as int,
      isVerifiedBuyer: null == isVerifiedBuyer
          ? _value.isVerifiedBuyer
          : isVerifiedBuyer // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReviewImpl implements _Review {
  const _$ReviewImpl(
      {required this.id,
      required this.listingId,
      required this.userId,
      required this.userName,
      required this.userImage,
      required this.rating,
      required this.comment,
      required this.createdAt,
      this.likesCount = 0,
      this.isVerifiedBuyer = false});

  factory _$ReviewImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReviewImplFromJson(json);

  @override
  final String id;
  @override
  final String listingId;
  @override
  final String userId;
  @override
  final String userName;
  @override
  final String userImage;
  @override
  final int rating;
// 1-5
  @override
  final String comment;
  @override
  final DateTime createdAt;
  @override
  @JsonKey()
  final int likesCount;
  @override
  @JsonKey()
  final bool isVerifiedBuyer;

  @override
  String toString() {
    return 'Review(id: $id, listingId: $listingId, userId: $userId, userName: $userName, userImage: $userImage, rating: $rating, comment: $comment, createdAt: $createdAt, likesCount: $likesCount, isVerifiedBuyer: $isVerifiedBuyer)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReviewImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.listingId, listingId) ||
                other.listingId == listingId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.userImage, userImage) ||
                other.userImage == userImage) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.comment, comment) || other.comment == comment) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.likesCount, likesCount) ||
                other.likesCount == likesCount) &&
            (identical(other.isVerifiedBuyer, isVerifiedBuyer) ||
                other.isVerifiedBuyer == isVerifiedBuyer));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, listingId, userId, userName,
      userImage, rating, comment, createdAt, likesCount, isVerifiedBuyer);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReviewImplCopyWith<_$ReviewImpl> get copyWith =>
      __$$ReviewImplCopyWithImpl<_$ReviewImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReviewImplToJson(
      this,
    );
  }
}

abstract class _Review implements Review {
  const factory _Review(
      {required final String id,
      required final String listingId,
      required final String userId,
      required final String userName,
      required final String userImage,
      required final int rating,
      required final String comment,
      required final DateTime createdAt,
      final int likesCount,
      final bool isVerifiedBuyer}) = _$ReviewImpl;

  factory _Review.fromJson(Map<String, dynamic> json) = _$ReviewImpl.fromJson;

  @override
  String get id;
  @override
  String get listingId;
  @override
  String get userId;
  @override
  String get userName;
  @override
  String get userImage;
  @override
  int get rating;
  @override // 1-5
  String get comment;
  @override
  DateTime get createdAt;
  @override
  int get likesCount;
  @override
  bool get isVerifiedBuyer;
  @override
  @JsonKey(ignore: true)
  _$$ReviewImplCopyWith<_$ReviewImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RatingStats _$RatingStatsFromJson(Map<String, dynamic> json) {
  return _RatingStats.fromJson(json);
}

/// @nodoc
mixin _$RatingStats {
  double get averageRating => throw _privateConstructorUsedError;
  int get totalReviews => throw _privateConstructorUsedError;
  int get fiveStarCount => throw _privateConstructorUsedError;
  int get fourStarCount => throw _privateConstructorUsedError;
  int get threeStarCount => throw _privateConstructorUsedError;
  int get twoStarCount => throw _privateConstructorUsedError;
  int get oneStarCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RatingStatsCopyWith<RatingStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RatingStatsCopyWith<$Res> {
  factory $RatingStatsCopyWith(
          RatingStats value, $Res Function(RatingStats) then) =
      _$RatingStatsCopyWithImpl<$Res, RatingStats>;
  @useResult
  $Res call(
      {double averageRating,
      int totalReviews,
      int fiveStarCount,
      int fourStarCount,
      int threeStarCount,
      int twoStarCount,
      int oneStarCount});
}

/// @nodoc
class _$RatingStatsCopyWithImpl<$Res, $Val extends RatingStats>
    implements $RatingStatsCopyWith<$Res> {
  _$RatingStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? averageRating = null,
    Object? totalReviews = null,
    Object? fiveStarCount = null,
    Object? fourStarCount = null,
    Object? threeStarCount = null,
    Object? twoStarCount = null,
    Object? oneStarCount = null,
  }) {
    return _then(_value.copyWith(
      averageRating: null == averageRating
          ? _value.averageRating
          : averageRating // ignore: cast_nullable_to_non_nullable
              as double,
      totalReviews: null == totalReviews
          ? _value.totalReviews
          : totalReviews // ignore: cast_nullable_to_non_nullable
              as int,
      fiveStarCount: null == fiveStarCount
          ? _value.fiveStarCount
          : fiveStarCount // ignore: cast_nullable_to_non_nullable
              as int,
      fourStarCount: null == fourStarCount
          ? _value.fourStarCount
          : fourStarCount // ignore: cast_nullable_to_non_nullable
              as int,
      threeStarCount: null == threeStarCount
          ? _value.threeStarCount
          : threeStarCount // ignore: cast_nullable_to_non_nullable
              as int,
      twoStarCount: null == twoStarCount
          ? _value.twoStarCount
          : twoStarCount // ignore: cast_nullable_to_non_nullable
              as int,
      oneStarCount: null == oneStarCount
          ? _value.oneStarCount
          : oneStarCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RatingStatsImplCopyWith<$Res>
    implements $RatingStatsCopyWith<$Res> {
  factory _$$RatingStatsImplCopyWith(
          _$RatingStatsImpl value, $Res Function(_$RatingStatsImpl) then) =
      __$$RatingStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double averageRating,
      int totalReviews,
      int fiveStarCount,
      int fourStarCount,
      int threeStarCount,
      int twoStarCount,
      int oneStarCount});
}

/// @nodoc
class __$$RatingStatsImplCopyWithImpl<$Res>
    extends _$RatingStatsCopyWithImpl<$Res, _$RatingStatsImpl>
    implements _$$RatingStatsImplCopyWith<$Res> {
  __$$RatingStatsImplCopyWithImpl(
      _$RatingStatsImpl _value, $Res Function(_$RatingStatsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? averageRating = null,
    Object? totalReviews = null,
    Object? fiveStarCount = null,
    Object? fourStarCount = null,
    Object? threeStarCount = null,
    Object? twoStarCount = null,
    Object? oneStarCount = null,
  }) {
    return _then(_$RatingStatsImpl(
      averageRating: null == averageRating
          ? _value.averageRating
          : averageRating // ignore: cast_nullable_to_non_nullable
              as double,
      totalReviews: null == totalReviews
          ? _value.totalReviews
          : totalReviews // ignore: cast_nullable_to_non_nullable
              as int,
      fiveStarCount: null == fiveStarCount
          ? _value.fiveStarCount
          : fiveStarCount // ignore: cast_nullable_to_non_nullable
              as int,
      fourStarCount: null == fourStarCount
          ? _value.fourStarCount
          : fourStarCount // ignore: cast_nullable_to_non_nullable
              as int,
      threeStarCount: null == threeStarCount
          ? _value.threeStarCount
          : threeStarCount // ignore: cast_nullable_to_non_nullable
              as int,
      twoStarCount: null == twoStarCount
          ? _value.twoStarCount
          : twoStarCount // ignore: cast_nullable_to_non_nullable
              as int,
      oneStarCount: null == oneStarCount
          ? _value.oneStarCount
          : oneStarCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RatingStatsImpl implements _RatingStats {
  const _$RatingStatsImpl(
      {required this.averageRating,
      required this.totalReviews,
      this.fiveStarCount = 0,
      this.fourStarCount = 0,
      this.threeStarCount = 0,
      this.twoStarCount = 0,
      this.oneStarCount = 0});

  factory _$RatingStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$RatingStatsImplFromJson(json);

  @override
  final double averageRating;
  @override
  final int totalReviews;
  @override
  @JsonKey()
  final int fiveStarCount;
  @override
  @JsonKey()
  final int fourStarCount;
  @override
  @JsonKey()
  final int threeStarCount;
  @override
  @JsonKey()
  final int twoStarCount;
  @override
  @JsonKey()
  final int oneStarCount;

  @override
  String toString() {
    return 'RatingStats(averageRating: $averageRating, totalReviews: $totalReviews, fiveStarCount: $fiveStarCount, fourStarCount: $fourStarCount, threeStarCount: $threeStarCount, twoStarCount: $twoStarCount, oneStarCount: $oneStarCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RatingStatsImpl &&
            (identical(other.averageRating, averageRating) ||
                other.averageRating == averageRating) &&
            (identical(other.totalReviews, totalReviews) ||
                other.totalReviews == totalReviews) &&
            (identical(other.fiveStarCount, fiveStarCount) ||
                other.fiveStarCount == fiveStarCount) &&
            (identical(other.fourStarCount, fourStarCount) ||
                other.fourStarCount == fourStarCount) &&
            (identical(other.threeStarCount, threeStarCount) ||
                other.threeStarCount == threeStarCount) &&
            (identical(other.twoStarCount, twoStarCount) ||
                other.twoStarCount == twoStarCount) &&
            (identical(other.oneStarCount, oneStarCount) ||
                other.oneStarCount == oneStarCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, averageRating, totalReviews,
      fiveStarCount, fourStarCount, threeStarCount, twoStarCount, oneStarCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RatingStatsImplCopyWith<_$RatingStatsImpl> get copyWith =>
      __$$RatingStatsImplCopyWithImpl<_$RatingStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RatingStatsImplToJson(
      this,
    );
  }
}

abstract class _RatingStats implements RatingStats {
  const factory _RatingStats(
      {required final double averageRating,
      required final int totalReviews,
      final int fiveStarCount,
      final int fourStarCount,
      final int threeStarCount,
      final int twoStarCount,
      final int oneStarCount}) = _$RatingStatsImpl;

  factory _RatingStats.fromJson(Map<String, dynamic> json) =
      _$RatingStatsImpl.fromJson;

  @override
  double get averageRating;
  @override
  int get totalReviews;
  @override
  int get fiveStarCount;
  @override
  int get fourStarCount;
  @override
  int get threeStarCount;
  @override
  int get twoStarCount;
  @override
  int get oneStarCount;
  @override
  @JsonKey(ignore: true)
  _$$RatingStatsImplCopyWith<_$RatingStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
