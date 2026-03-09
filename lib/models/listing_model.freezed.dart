// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'listing_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ListingImage _$ListingImageFromJson(Map<String, dynamic> json) {
  return _ListingImage.fromJson(json);
}

/// @nodoc
mixin _$ListingImage {
  int get id => throw _privateConstructorUsedError;
  int get listingId => throw _privateConstructorUsedError;
  String get imageUrl => throw _privateConstructorUsedError;
  int get order => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ListingImageCopyWith<ListingImage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ListingImageCopyWith<$Res> {
  factory $ListingImageCopyWith(
          ListingImage value, $Res Function(ListingImage) then) =
      _$ListingImageCopyWithImpl<$Res, ListingImage>;
  @useResult
  $Res call({int id, int listingId, String imageUrl, int order});
}

/// @nodoc
class _$ListingImageCopyWithImpl<$Res, $Val extends ListingImage>
    implements $ListingImageCopyWith<$Res> {
  _$ListingImageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? listingId = null,
    Object? imageUrl = null,
    Object? order = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      listingId: null == listingId
          ? _value.listingId
          : listingId // ignore: cast_nullable_to_non_nullable
              as int,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ListingImageImplCopyWith<$Res>
    implements $ListingImageCopyWith<$Res> {
  factory _$$ListingImageImplCopyWith(
          _$ListingImageImpl value, $Res Function(_$ListingImageImpl) then) =
      __$$ListingImageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, int listingId, String imageUrl, int order});
}

/// @nodoc
class __$$ListingImageImplCopyWithImpl<$Res>
    extends _$ListingImageCopyWithImpl<$Res, _$ListingImageImpl>
    implements _$$ListingImageImplCopyWith<$Res> {
  __$$ListingImageImplCopyWithImpl(
      _$ListingImageImpl _value, $Res Function(_$ListingImageImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? listingId = null,
    Object? imageUrl = null,
    Object? order = null,
  }) {
    return _then(_$ListingImageImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      listingId: null == listingId
          ? _value.listingId
          : listingId // ignore: cast_nullable_to_non_nullable
              as int,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ListingImageImpl implements _ListingImage {
  const _$ListingImageImpl(
      {required this.id,
      required this.listingId,
      required this.imageUrl,
      this.order = 0});

  factory _$ListingImageImpl.fromJson(Map<String, dynamic> json) =>
      _$$ListingImageImplFromJson(json);

  @override
  final int id;
  @override
  final int listingId;
  @override
  final String imageUrl;
  @override
  @JsonKey()
  final int order;

  @override
  String toString() {
    return 'ListingImage(id: $id, listingId: $listingId, imageUrl: $imageUrl, order: $order)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ListingImageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.listingId, listingId) ||
                other.listingId == listingId) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.order, order) || other.order == order));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, listingId, imageUrl, order);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ListingImageImplCopyWith<_$ListingImageImpl> get copyWith =>
      __$$ListingImageImplCopyWithImpl<_$ListingImageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ListingImageImplToJson(
      this,
    );
  }
}

abstract class _ListingImage implements ListingImage {
  const factory _ListingImage(
      {required final int id,
      required final int listingId,
      required final String imageUrl,
      final int order}) = _$ListingImageImpl;

  factory _ListingImage.fromJson(Map<String, dynamic> json) =
      _$ListingImageImpl.fromJson;

  @override
  int get id;
  @override
  int get listingId;
  @override
  String get imageUrl;
  @override
  int get order;
  @override
  @JsonKey(ignore: true)
  _$$ListingImageImplCopyWith<_$ListingImageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Listing _$ListingFromJson(Map<String, dynamic> json) {
  return _Listing.fromJson(json);
}

/// @nodoc
mixin _$Listing {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  int get categoryId => throw _privateConstructorUsedError;
  int get governorateId => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get whatsapp => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get website => throw _privateConstructorUsedError;
  String? get instagram => throw _privateConstructorUsedError;
  String? get facebook => throw _privateConstructorUsedError;
  String? get tiktok => throw _privateConstructorUsedError;
  double? get locationLat => throw _privateConstructorUsedError;
  double? get locationLng => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  bool get isFeatured => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  int get viewCount => throw _privateConstructorUsedError;
  Category? get category => throw _privateConstructorUsedError;
  Governorate? get governorate => throw _privateConstructorUsedError;
  List<ListingImage> get images => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ListingCopyWith<Listing> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ListingCopyWith<$Res> {
  factory $ListingCopyWith(Listing value, $Res Function(Listing) then) =
      _$ListingCopyWithImpl<$Res, Listing>;
  @useResult
  $Res call(
      {int id,
      String name,
      String? description,
      int categoryId,
      int governorateId,
      String? phone,
      String? whatsapp,
      String? email,
      String? website,
      String? instagram,
      String? facebook,
      String? tiktok,
      double? locationLat,
      double? locationLng,
      String? address,
      bool isFeatured,
      bool isActive,
      int viewCount,
      Category? category,
      Governorate? governorate,
      List<ListingImage> images,
      DateTime createdAt,
      DateTime updatedAt});

  $CategoryCopyWith<$Res>? get category;
  $GovernorateCopyWith<$Res>? get governorate;
}

/// @nodoc
class _$ListingCopyWithImpl<$Res, $Val extends Listing>
    implements $ListingCopyWith<$Res> {
  _$ListingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? categoryId = null,
    Object? governorateId = null,
    Object? phone = freezed,
    Object? whatsapp = freezed,
    Object? email = freezed,
    Object? website = freezed,
    Object? instagram = freezed,
    Object? facebook = freezed,
    Object? tiktok = freezed,
    Object? locationLat = freezed,
    Object? locationLng = freezed,
    Object? address = freezed,
    Object? isFeatured = null,
    Object? isActive = null,
    Object? viewCount = null,
    Object? category = freezed,
    Object? governorate = freezed,
    Object? images = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as int,
      governorateId: null == governorateId
          ? _value.governorateId
          : governorateId // ignore: cast_nullable_to_non_nullable
              as int,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      whatsapp: freezed == whatsapp
          ? _value.whatsapp
          : whatsapp // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      website: freezed == website
          ? _value.website
          : website // ignore: cast_nullable_to_non_nullable
              as String?,
      instagram: freezed == instagram
          ? _value.instagram
          : instagram // ignore: cast_nullable_to_non_nullable
              as String?,
      facebook: freezed == facebook
          ? _value.facebook
          : facebook // ignore: cast_nullable_to_non_nullable
              as String?,
      tiktok: freezed == tiktok
          ? _value.tiktok
          : tiktok // ignore: cast_nullable_to_non_nullable
              as String?,
      locationLat: freezed == locationLat
          ? _value.locationLat
          : locationLat // ignore: cast_nullable_to_non_nullable
              as double?,
      locationLng: freezed == locationLng
          ? _value.locationLng
          : locationLng // ignore: cast_nullable_to_non_nullable
              as double?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      isFeatured: null == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      viewCount: null == viewCount
          ? _value.viewCount
          : viewCount // ignore: cast_nullable_to_non_nullable
              as int,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as Category?,
      governorate: freezed == governorate
          ? _value.governorate
          : governorate // ignore: cast_nullable_to_non_nullable
              as Governorate?,
      images: null == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<ListingImage>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $CategoryCopyWith<$Res>? get category {
    if (_value.category == null) {
      return null;
    }

    return $CategoryCopyWith<$Res>(_value.category!, (value) {
      return _then(_value.copyWith(category: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $GovernorateCopyWith<$Res>? get governorate {
    if (_value.governorate == null) {
      return null;
    }

    return $GovernorateCopyWith<$Res>(_value.governorate!, (value) {
      return _then(_value.copyWith(governorate: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ListingImplCopyWith<$Res> implements $ListingCopyWith<$Res> {
  factory _$$ListingImplCopyWith(
          _$ListingImpl value, $Res Function(_$ListingImpl) then) =
      __$$ListingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String name,
      String? description,
      int categoryId,
      int governorateId,
      String? phone,
      String? whatsapp,
      String? email,
      String? website,
      String? instagram,
      String? facebook,
      String? tiktok,
      double? locationLat,
      double? locationLng,
      String? address,
      bool isFeatured,
      bool isActive,
      int viewCount,
      Category? category,
      Governorate? governorate,
      List<ListingImage> images,
      DateTime createdAt,
      DateTime updatedAt});

  @override
  $CategoryCopyWith<$Res>? get category;
  @override
  $GovernorateCopyWith<$Res>? get governorate;
}

/// @nodoc
class __$$ListingImplCopyWithImpl<$Res>
    extends _$ListingCopyWithImpl<$Res, _$ListingImpl>
    implements _$$ListingImplCopyWith<$Res> {
  __$$ListingImplCopyWithImpl(
      _$ListingImpl _value, $Res Function(_$ListingImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? categoryId = null,
    Object? governorateId = null,
    Object? phone = freezed,
    Object? whatsapp = freezed,
    Object? email = freezed,
    Object? website = freezed,
    Object? instagram = freezed,
    Object? facebook = freezed,
    Object? tiktok = freezed,
    Object? locationLat = freezed,
    Object? locationLng = freezed,
    Object? address = freezed,
    Object? isFeatured = null,
    Object? isActive = null,
    Object? viewCount = null,
    Object? category = freezed,
    Object? governorate = freezed,
    Object? images = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$ListingImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as int,
      governorateId: null == governorateId
          ? _value.governorateId
          : governorateId // ignore: cast_nullable_to_non_nullable
              as int,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      whatsapp: freezed == whatsapp
          ? _value.whatsapp
          : whatsapp // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      website: freezed == website
          ? _value.website
          : website // ignore: cast_nullable_to_non_nullable
              as String?,
      instagram: freezed == instagram
          ? _value.instagram
          : instagram // ignore: cast_nullable_to_non_nullable
              as String?,
      facebook: freezed == facebook
          ? _value.facebook
          : facebook // ignore: cast_nullable_to_non_nullable
              as String?,
      tiktok: freezed == tiktok
          ? _value.tiktok
          : tiktok // ignore: cast_nullable_to_non_nullable
              as String?,
      locationLat: freezed == locationLat
          ? _value.locationLat
          : locationLat // ignore: cast_nullable_to_non_nullable
              as double?,
      locationLng: freezed == locationLng
          ? _value.locationLng
          : locationLng // ignore: cast_nullable_to_non_nullable
              as double?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      isFeatured: null == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      viewCount: null == viewCount
          ? _value.viewCount
          : viewCount // ignore: cast_nullable_to_non_nullable
              as int,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as Category?,
      governorate: freezed == governorate
          ? _value.governorate
          : governorate // ignore: cast_nullable_to_non_nullable
              as Governorate?,
      images: null == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<ListingImage>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ListingImpl implements _Listing {
  const _$ListingImpl(
      {required this.id,
      required this.name,
      this.description,
      required this.categoryId,
      required this.governorateId,
      this.phone,
      this.whatsapp,
      this.email,
      this.website,
      this.instagram,
      this.facebook,
      this.tiktok,
      this.locationLat,
      this.locationLng,
      this.address,
      this.isFeatured = false,
      this.isActive = true,
      this.viewCount = 0,
      this.category,
      this.governorate,
      final List<ListingImage> images = const [],
      required this.createdAt,
      required this.updatedAt})
      : _images = images;

  factory _$ListingImpl.fromJson(Map<String, dynamic> json) =>
      _$$ListingImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String? description;
  @override
  final int categoryId;
  @override
  final int governorateId;
  @override
  final String? phone;
  @override
  final String? whatsapp;
  @override
  final String? email;
  @override
  final String? website;
  @override
  final String? instagram;
  @override
  final String? facebook;
  @override
  final String? tiktok;
  @override
  final double? locationLat;
  @override
  final double? locationLng;
  @override
  final String? address;
  @override
  @JsonKey()
  final bool isFeatured;
  @override
  @JsonKey()
  final bool isActive;
  @override
  @JsonKey()
  final int viewCount;
  @override
  final Category? category;
  @override
  final Governorate? governorate;
  final List<ListingImage> _images;
  @override
  @JsonKey()
  List<ListingImage> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'Listing(id: $id, name: $name, description: $description, categoryId: $categoryId, governorateId: $governorateId, phone: $phone, whatsapp: $whatsapp, email: $email, website: $website, instagram: $instagram, facebook: $facebook, tiktok: $tiktok, locationLat: $locationLat, locationLng: $locationLng, address: $address, isFeatured: $isFeatured, isActive: $isActive, viewCount: $viewCount, category: $category, governorate: $governorate, images: $images, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ListingImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.governorateId, governorateId) ||
                other.governorateId == governorateId) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.whatsapp, whatsapp) ||
                other.whatsapp == whatsapp) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.website, website) || other.website == website) &&
            (identical(other.instagram, instagram) ||
                other.instagram == instagram) &&
            (identical(other.facebook, facebook) ||
                other.facebook == facebook) &&
            (identical(other.tiktok, tiktok) || other.tiktok == tiktok) &&
            (identical(other.locationLat, locationLat) ||
                other.locationLat == locationLat) &&
            (identical(other.locationLng, locationLng) ||
                other.locationLng == locationLng) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.isFeatured, isFeatured) ||
                other.isFeatured == isFeatured) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.viewCount, viewCount) ||
                other.viewCount == viewCount) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.governorate, governorate) ||
                other.governorate == governorate) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        name,
        description,
        categoryId,
        governorateId,
        phone,
        whatsapp,
        email,
        website,
        instagram,
        facebook,
        tiktok,
        locationLat,
        locationLng,
        address,
        isFeatured,
        isActive,
        viewCount,
        category,
        governorate,
        const DeepCollectionEquality().hash(_images),
        createdAt,
        updatedAt
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ListingImplCopyWith<_$ListingImpl> get copyWith =>
      __$$ListingImplCopyWithImpl<_$ListingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ListingImplToJson(
      this,
    );
  }
}

abstract class _Listing implements Listing {
  const factory _Listing(
      {required final int id,
      required final String name,
      final String? description,
      required final int categoryId,
      required final int governorateId,
      final String? phone,
      final String? whatsapp,
      final String? email,
      final String? website,
      final String? instagram,
      final String? facebook,
      final String? tiktok,
      final double? locationLat,
      final double? locationLng,
      final String? address,
      final bool isFeatured,
      final bool isActive,
      final int viewCount,
      final Category? category,
      final Governorate? governorate,
      final List<ListingImage> images,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$ListingImpl;

  factory _Listing.fromJson(Map<String, dynamic> json) = _$ListingImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String? get description;
  @override
  int get categoryId;
  @override
  int get governorateId;
  @override
  String? get phone;
  @override
  String? get whatsapp;
  @override
  String? get email;
  @override
  String? get website;
  @override
  String? get instagram;
  @override
  String? get facebook;
  @override
  String? get tiktok;
  @override
  double? get locationLat;
  @override
  double? get locationLng;
  @override
  String? get address;
  @override
  bool get isFeatured;
  @override
  bool get isActive;
  @override
  int get viewCount;
  @override
  Category? get category;
  @override
  Governorate? get governorate;
  @override
  List<ListingImage> get images;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$ListingImplCopyWith<_$ListingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
