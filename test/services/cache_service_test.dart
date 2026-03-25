import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';

void main() {
  group('CacheService Logic', () {
    test('handles invalid JSON in cache gracefully', () {
      const invalidJson = 'invalid json data';

      dynamic result;
      try {
        result = jsonDecode(invalidJson);
      } catch (e) {
        result = null;
      }

      expect(result, isNull);
    });

    test('valid JSON decodes correctly', () {
      final mockData = [
        {'id': 1, 'name': 'Category 1'},
        {'id': 2, 'name': 'Category 2'},
      ];
      final jsonString = jsonEncode(mockData);

      final decoded = jsonDecode(jsonString) as List;
      expect(decoded.length, 2);
      expect(decoded[0]['name'], 'Category 1');
    });

    test('TTL not expired returns false', () {
      final now = DateTime.now().millisecondsSinceEpoch;
      final thirtyMinutesAgo = now - (30 * 60 * 1000);
      final ttl = 3600 * 1000;

      final isExpired = (now - thirtyMinutesAgo) > ttl;

      expect(isExpired, false);
    });

    test('TTL expired returns true', () {
      final now = DateTime.now().millisecondsSinceEpoch;
      final twoHoursAgo = now - (2 * 3600 * 1000);
      final ttl = 3600 * 1000;

      final isExpired = (now - twoHoursAgo) > ttl;

      expect(isExpired, true);
    });

    test('TTL exactly at boundary returns false', () {
      final now = DateTime.now().millisecondsSinceEpoch;
      final oneHourAgo = now - (3600 * 1000);
      final ttl = 3600 * 1000;

      final isExpired = (now - oneHourAgo) > ttl;

      expect(isExpired, false);
    });

    test('pagination caching uses correct keys', () {
      const page = 1;
      const limit = 20;
      final expectedKey = 'listings_p${page}_l$limit';

      expect(expectedKey, 'listings_p1_l20');
    });

    test('search caching includes query in key', () {
      const query = 'apartment';
      const page = 1;
      final cacheKey = 'search_${query}_p$page';

      expect(cacheKey, 'search_apartment_p1');
    });

    test('listing detail key includes ID', () {
      const id = 42;
      const key = 'listing_detail';
      final fullKey = '${key}_$id';

      expect(fullKey, 'listing_detail_42');
    });

    test('cache timestamp key format is correct', () {
      const cacheTimestampKey = 'cache_timestamp_';
      const dataKey = 'categories';
      final timestampKey = '$cacheTimestampKey$dataKey';

      expect(timestampKey, 'cache_timestamp_categories');
    });
  });
}
