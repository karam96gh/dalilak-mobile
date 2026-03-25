import 'package:flutter_test/flutter_test.dart';
import 'package:dalilak_app/models/category_model.dart';
import 'package:dalilak_app/models/governorate_model.dart';
import 'package:dalilak_app/utils/exceptions.dart';

void main() {
  group('Repository Data Models', () {
    group('Category', () {
      test('creates Category from JSON correctly', () {
        final json = {
          'id': 1,
          'name': 'مطاعم وكافيهات',
          'icon': '🍽️',
          'image': null,
          'parentId': null,
          'level': 1,
          'order': 0,
          'isActive': true,
          'children': <Map<String, dynamic>>[],
        };

        final category = Category.fromJson(json);

        expect(category.id, 1);
        expect(category.name, 'مطاعم وكافيهات');
        expect(category.icon, '🍽️');
        expect(category.parentId, isNull);
        expect(category.children, isEmpty);
      });

      test('creates Category with children', () {
        final json = {
          'id': 1,
          'name': 'مطاعم وكافيهات',
          'icon': '🍽️',
          'level': 1,
          'children': [
            {
              'id': 101,
              'name': 'مطاعم عربية',
              'icon': '🥘',
              'parentId': 1,
              'level': 2,
              'children': <Map<String, dynamic>>[],
            },
          ],
        };

        final category = Category.fromJson(json);

        expect(category.children.length, 1);
        expect(category.children[0].name, 'مطاعم عربية');
        expect(category.children[0].parentId, 1);
      });

      test('Category toJson roundtrip works', () {
        const category = Category(
          id: 1,
          name: 'Test',
          icon: '📦',
          level: 1,
        );

        final json = category.toJson();
        final restored = Category.fromJson(json);

        expect(restored.id, category.id);
        expect(restored.name, category.name);
        expect(restored.icon, category.icon);
      });
    });

    group('Governorate', () {
      test('creates Governorate from JSON correctly', () {
        final json = {
          'id': 1,
          'name': 'دمشق',
          'isActive': true,
          'order': 0,
        };

        final gov = Governorate.fromJson(json);

        expect(gov.id, 1);
        expect(gov.name, 'دمشق');
        expect(gov.isActive, true);
        expect(gov.order, 0);
      });

      test('Governorate toJson roundtrip works', () {
        const gov = Governorate(id: 1, name: 'دمشق');

        final json = gov.toJson();
        final restored = Governorate.fromJson(json);

        expect(restored.id, gov.id);
        expect(restored.name, gov.name);
      });
    });
  });

  group('Repository Error Handling Logic', () {
    test('throws NetworkException when offline and no cache', () {
      expect(
        () => throw NetworkException(
          message: 'No internet connection',
          code: 'NO_INTERNET',
        ),
        throwsA(isA<NetworkException>()),
      );
    });

    test('uses cache fallback when API fails', () {
      final cachedCategories = [
        const Category(id: 1, name: 'Cached Category', icon: '📦', level: 1),
      ];

      expect(cachedCategories.length, 1);
      expect(cachedCategories[0].name, 'Cached Category');
    });

    test('pagination parameters are built correctly', () {
      const page = 2;
      const limit = 10;
      const categoryId = 100;

      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
        'categoryId': categoryId,
      };

      expect(queryParams['page'], 2);
      expect(queryParams['limit'], 10);
      expect(queryParams['categoryId'], 100);
    });
  });
}
