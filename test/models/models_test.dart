import 'package:flutter_test/flutter_test.dart';
import 'package:dalilak_app/models/category_model.dart';
import 'package:dalilak_app/models/governorate_model.dart';
import 'package:dalilak_app/models/listing_model.dart';

void main() {
  group('Category Model', () {
    test('Category fromJson creates instance correctly', () {
      // Arrange
      const json = {
        'id': 1,
        'name': 'Real Estate',
        'icon': '🏠',
        'image': null,
        'parentId': null,
        'level': 0,
        'children': [],
      };

      // Act
      final category = Category.fromJson(json);

      // Assert
      expect(category.id, 1);
      expect(category.name, 'Real Estate');
      expect(category.icon, '🏠');
      expect(category.level, 0);
      expect(category.children, isEmpty);
    });

    test('Category toJson converts instance correctly', () {
      // Arrange
      final category = Category(
        id: 1,
        name: 'Real Estate',
        icon: '🏠',
        image: null,
        parentId: null,
        level: 0,
        children: [],
      );

      // Act
      final json = category.toJson();

      // Assert
      expect(json['id'], 1);
      expect(json['name'], 'Real Estate');
      expect(json['icon'], '🏠');
      expect(json['parentId'], null);
    });

    test('Category with children creates hierarchy', () {
      // Arrange
      final parentCategory = Category(
        id: 1,
        name: 'Real Estate',
        icon: '🏠',
        image: null,
        parentId: null,
        level: 0,
        children: [
          Category(
            id: 2,
            name: 'Apartments',
            icon: '🏢',
            image: null,
            parentId: 1,
            level: 1,
            children: [],
          ),
        ],
      );

      // Act & Assert
      expect(parentCategory.children.length, 1);
      expect(parentCategory.children[0].parentId, 1);
      expect(parentCategory.children[0].level, 1);
    });
  });

  group('Governorate Model', () {
    test('Governorate fromJson creates instance correctly', () {
      // Arrange
      const json = {
        'id': 1,
        'name': 'Cairo',
        'isActive': true,
        'order': 1,
      };

      // Act
      final governorate = Governorate.fromJson(json);

      // Assert
      expect(governorate.id, 1);
      expect(governorate.name, 'Cairo');
      expect(governorate.isActive, true);
      expect(governorate.order, 1);
    });

    test('Governorate toJson converts correctly', () {
      // Arrange
      final governorate = Governorate(
        id: 1,
        name: 'Cairo',
        isActive: true,
        order: 1,
      );

      // Act
      final json = governorate.toJson();

      // Assert
      expect(json['id'], 1);
      expect(json['name'], 'Cairo');
      expect(json['isActive'], true);
    });

    test('Governorate equality works correctly', () {
      // Arrange
      final gov1 = Governorate(
        id: 1,
        name: 'Cairo',
        isActive: true,
        order: 1,
      );
      final gov2 = Governorate(
        id: 1,
        name: 'Cairo',
        isActive: true,
        order: 1,
      );

      // Act & Assert
      expect(gov1, gov2);
    });
  });

  group('Listing Model', () {
    test('Listing fromJson creates instance correctly', () {
      // Arrange
      const json = {
        'id': 1,
        'name': 'Apartment for Sale',
        'description': 'Nice apartment',
        'categoryId': 1,
        'governorateId': 1,
        'phone': '+20123456789',
        'whatsapp': '+20987654321',
        'email': 'test@example.com',
        'website': 'https://example.com',
        'instagram': 'example',
        'facebook': 'example',
        'tiktok': 'example',
        'locationLat': 30.0444,
        'locationLng': 31.2357,
        'address': 'Downtown Cairo',
        'isFeatured': false,
        'isActive': true,
        'viewCount': 0,
        'images': [],
        'createdAt': '2024-01-01T00:00:00Z',
        'updatedAt': '2024-01-01T00:00:00Z',
      };

      // Act
      final listing = Listing.fromJson(json);

      // Assert
      expect(listing.id, 1);
      expect(listing.name, 'Apartment for Sale');
      expect(listing.phone, '+20123456789');
    });

    test('Listing toJson converts correctly', () {
      // Arrange
      final listing = Listing(
        id: 1,
        name: 'Apartment for Sale',
        description: 'Nice apartment',
        categoryId: 1,
        governorateId: 1,
        phone: '+20123456789',
        whatsapp: '+20987654321',
        email: 'test@example.com',
        website: 'https://example.com',
        instagram: 'example',
        facebook: 'example',
        tiktok: 'example',
        locationLat: 30.0444,
        locationLng: 31.2357,
        address: 'Downtown Cairo',
        isFeatured: false,
        isActive: true,
        viewCount: 0,
        images: [],
        createdAt: DateTime.parse('2024-01-01T00:00:00Z'),
        updatedAt: DateTime.parse('2024-01-01T00:00:00Z'),
      );

      // Act
      final json = listing.toJson();

      // Assert
      expect(json['id'], 1);
      expect(json['name'], 'Apartment for Sale');
      expect(json['phone'], '+20123456789');
    });

    test('Listing model validates required fields', () {
      // Arrange & Act & Assert - checking that model requires essential fields
      expect(
        () => Listing(
          id: 1,
          name: 'Test Listing',
          categoryId: 1,
          governorateId: 1,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        returnsNormally,
      );
    });
  });

  group('ListingImage Model', () {
    test('ListingImage fromJson creates instance', () {
      // Arrange
      const json = {
        'id': 1,
        'listingId': 1,
        'imageUrl': 'https://example.com/image.jpg',
        'order': 0,
      };

      // Act
      final image = ListingImage.fromJson(json);

      // Assert
      expect(image.id, 1);
      expect(image.listingId, 1);
      expect(image.imageUrl, 'https://example.com/image.jpg');
      expect(image.order, 0);
    });
  });
}
