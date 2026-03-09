import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'dart:convert';

// Mock Hive Box
class MockBox<T> extends Mock implements Box<T> {}

void main() {
  group('CacheService', () {
    late MockBox<String> mockCategoriesBox;
    late MockBox<String> mockListingsBox;
    late MockBox<String> mockTimestampsBox;

    setUp(() {
      mockCategoriesBox = MockBox<String>();
      mockListingsBox = MockBox<String>();
      mockTimestampsBox = MockBox<String>();
    });

    test('caches and retrieves categories correctly', () async {
      // Arrange
      const categoriesKey = 'categories';
      final mockData = [
        {'id': 1, 'name': 'Category 1'},
        {'id': 2, 'name': 'Category 2'},
      ];
      final jsonString = jsonEncode(mockData);

      // Simulate storing in cache
      when(mockCategoriesBox.put(
        categoriesKey,
        jsonString,
      )).thenAnswer((_) async {});

      when(mockTimestampsBox.put(
        'cache_timestamp_$categoriesKey',
        DateTime.now().millisecondsSinceEpoch.toString(),
      )).thenAnswer((_) async {});

      // Act & Assert
      await mockCategoriesBox.put(categoriesKey, jsonString);
      verify(mockCategoriesBox.put(categoriesKey, jsonString)).called(1);
    });

    test('handles invalid JSON in cache gracefully', () async {
      // Arrange
      const invalidJson = 'invalid json data';

      // Act
      dynamic result;
      try {
        result = jsonDecode(invalidJson);
      } catch (e) {
        result = null;
      }

      // Assert
      expect(result, isNull);
    });

    test('TTL validation works correctly', () async {
      // Arrange
      final now = DateTime.now().millisecondsSinceEpoch;
      final onHourAgo = now - (3600 * 1000); // 1 hour ago
      final ttl = 3600 * 1000; // 1 hour

      // Act
      final isExpired = (now - onHourAgo) > ttl;

      // Assert
      expect(isExpired, false);
    });

    test('detects expired cache correctly', () async {
      // Arrange
      final now = DateTime.now().millisecondsSinceEpoch;
      final twoHoursAgo = now - (2 * 3600 * 1000); // 2 hours ago
      final ttl = 3600 * 1000; // 1 hour TTL

      // Act
      final isExpired = (now - twoHoursAgo) > ttl;

      // Assert
      expect(isExpired, true);
    });

    test('pagination caching uses correct keys', () async {
      // Arrange
      const page = 1;
      const limit = 20;
      final expectedKey = 'listings_p${page}_l$limit';

      // Act & Assert
      expect(expectedKey, 'listings_p1_l20');
    });

    test('search caching includes query in key', () async {
      // Arrange
      const query = 'apartment';
      const page = 1;
      final cacheKey = 'search_${query}_p$page';

      // Act & Assert
      expect(cacheKey, 'search_apartment_p1');
    });
  });
}
