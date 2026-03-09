import 'package:hive_flutter/hive_flutter.dart';
import '../models/category_model.dart';
import '../models/governorate_model.dart';
import '../models/ad_model.dart';
import '../models/notification_model.dart';

class CacheService {
  static const String _categoriesBoxKey = 'categories';
  static const String _governoratesBoxKey = 'governorates';
  static const String _listingsBoxKey = 'listings';
  static const String _adsBoxKey = 'ads';
  static const String _notificationsBoxKey = 'notifications';
  static const String _cacheTimestampKey = 'cache_timestamp_';

  late Box<dynamic> _categoriesBox;
  late Box<dynamic> _governoratesBox;
  late Box<dynamic> _listingsBox;
  late Box<dynamic> _adsBox;
  late Box<dynamic> _notificationsBox;
  late Box<String> _timestampBox;

  /// Initialize all Hive boxes
  Future<void> init() async {
    _categoriesBox = await Hive.openBox(_categoriesBoxKey);
    _governoratesBox = await Hive.openBox(_governoratesBoxKey);
    _listingsBox = await Hive.openBox(_listingsBoxKey);
    _adsBox = await Hive.openBox(_adsBoxKey);
    _notificationsBox = await Hive.openBox(_notificationsBoxKey);
    _timestampBox = await Hive.openBox('cache_timestamps');
  }

  /// Cache TTL in milliseconds (default: 1 hour)
  static const int cacheTtlMs = 3600000;

  /// Check if cache is still valid
  bool _isCacheValid(String key) {
    final timestamp = _timestampBox.get('$_cacheTimestampKey$key');
    if (timestamp == null) return false;

    try {
      final cachedTime = int.parse(timestamp);
      final now = DateTime.now().millisecondsSinceEpoch;
      return (now - cachedTime) < cacheTtlMs;
    } catch (_) {
      return false;
    }
  }

  /// Set cache timestamp
  Future<void> _setCacheTimestamp(String key) async {
    await _timestampBox.put(
      '$_cacheTimestampKey$key',
      DateTime.now().millisecondsSinceEpoch.toString(),
    );
  }

  // ============ CATEGORIES ============
  Future<List<Category>?> getCachedCategories() async {
    if (!_isCacheValid('categories')) return null;

    try {
      final listDynamic = _categoriesBox.get(_categoriesBoxKey) as List?;
      if (listDynamic == null) return null;
      return listDynamic
          .map((e) => Category.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return null;
    }
  }

  Future<void> cacheCategories(List<Category> categories) async {
    try {
      await _categoriesBox.put(
        _categoriesBoxKey,
        categories.map((e) => e.toJson()).toList(),
      );
      await _setCacheTimestamp('categories');
    } catch (_) {}
  }

  // ============ GOVERNORATES ============
  Future<List<Governorate>?> getCachedGovernorates() async {
    if (!_isCacheValid('governorates')) return null;

    try {
      final listDynamic = _governoratesBox.get(_governoratesBoxKey) as List?;
      if (listDynamic == null) return null;
      return listDynamic
          .map((e) => Governorate.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return null;
    }
  }

  Future<void> cacheGovernorates(List<Governorate> governorates) async {
    try {
      await _governoratesBox.put(
        _governoratesBoxKey,
        governorates.map((e) => e.toJson()).toList(),
      );
      await _setCacheTimestamp('governorates');
    } catch (_) {}
  }

  // ============ LISTINGS ============
  Future<String?> getCachedListingsPaginated(int page, int limit) async {
    final key = 'listings_p${page}_l$limit';
    if (!_isCacheValid(key)) return null;

    try {
      return _listingsBox.get(key) as String?;
    } catch (_) {
      return null;
    }
  }

  Future<void> cacheListingsPaginated(
    int page,
    int limit,
    String jsonData,
  ) async {
    try {
      final key = 'listings_p${page}_l$limit';
      await _listingsBox.put(key, jsonData);
      await _setCacheTimestamp(key);
    } catch (_) {}
  }

  Future<String?> getCachedListing(int id) async {
    const key = 'listing_detail';
    final fullKey = '${key}_$id';
    if (!_isCacheValid(fullKey)) return null;

    try {
      return _listingsBox.get(fullKey) as String?;
    } catch (_) {
      return null;
    }
  }

  Future<void> cacheListing(int id, String jsonData) async {
    try {
      const key = 'listing_detail';
      final fullKey = '${key}_$id';
      await _listingsBox.put(fullKey, jsonData);
      await _setCacheTimestamp(fullKey);
    } catch (_) {}
  }

  // ============ SEARCH RESULTS ============
  Future<String?> getCachedSearch(String query, int page) async {
    final key = 'search_${query}_p$page';
    if (!_isCacheValid(key)) return null;

    try {
      return _listingsBox.get(key) as String?;
    } catch (_) {
      return null;
    }
  }

  Future<void> cacheSearch(String query, int page, String jsonData) async {
    try {
      final key = 'search_${query}_p$page';
      await _listingsBox.put(key, jsonData);
      await _setCacheTimestamp(key);
    } catch (_) {}
  }

  // ============ ADS ============
  Future<List<Ad>?> getCachedAds() async {
    if (!_isCacheValid('ads')) return null;

    try {
      final listDynamic = _adsBox.get(_adsBoxKey) as List?;
      if (listDynamic == null) return null;
      return listDynamic
          .map((e) => Ad.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return null;
    }
  }

  Future<void> cacheAds(List<Ad> ads) async {
    try {
      await _adsBox.put(
        _adsBoxKey,
        ads.map((e) => e.toJson()).toList(),
      );
      await _setCacheTimestamp('ads');
    } catch (_) {}
  }

  // ============ NOTIFICATIONS ============
  Future<List<Notification>?> getCachedNotifications() async {
    if (!_isCacheValid('notifications')) return null;

    try {
      final listDynamic = _notificationsBox.get(_notificationsBoxKey) as List?;
      if (listDynamic == null) return null;
      return listDynamic
          .map((e) => Notification.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return null;
    }
  }

  Future<void> cacheNotifications(List<Notification> notifications) async {
    try {
      await _notificationsBox.put(
        _notificationsBoxKey,
        notifications.map((e) => e.toJson()).toList(),
      );
      await _setCacheTimestamp('notifications');
    } catch (_) {}
  }

  // ============ CLEAR CACHE ============
  Future<void> clearAllCache() async {
    try {
      await _categoriesBox.clear();
      await _governoratesBox.clear();
      await _listingsBox.clear();
      await _adsBox.clear();
      await _notificationsBox.clear();
      await _timestampBox.clear();
    } catch (_) {}
  }

  Future<void> clearExpiredCache() async {
    // This can be called periodically to clean up old cached data
    try {
      final keysToDelete = <String>[];
      for (var key in _timestampBox.keys) {
        if (!_isCacheValid(key.toString().replaceFirst(_cacheTimestampKey, ''))) {
          keysToDelete.add(key);
        }
      }
      for (var key in keysToDelete) {
        await _timestampBox.delete(key);
      }
    } catch (_) {}
  }
}
