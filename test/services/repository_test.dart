import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dalilak_app/services/api_client.dart';
import 'package:dalilak_app/services/cache_service.dart';
import 'package:dalilak_app/services/connectivity_service.dart';
import 'package:dalilak_app/services/dalilak_repository.dart';
import 'package:dalilak_app/models/category_model.dart';
import 'package:dalilak_app/models/governorate_model.dart';
import 'package:dalilak_app/utils/exceptions.dart';

// Generate mocks
class MockApiClient extends Mock implements ApiClient {}
class MockCacheService extends Mock implements CacheService {}
class MockConnectivityService extends Mock implements ConnectivityService {}

void main() {
  group('DalilakRepository', () {
    late MockApiClient mockApiClient;
    late MockCacheService mockCacheService;
    late MockConnectivityService mockConnectivityService;
    late DalilakRepository repository;

    setUp(() {
      mockApiClient = MockApiClient();
      mockCacheService = MockCacheService();
      mockConnectivityService = MockConnectivityService();
      
      repository = DalilakRepository(
        apiClient: mockApiClient,
        cacheService: mockCacheService,
        connectivityService: mockConnectivityService,
      );
    });

    group('getCategories', () {
      final mockCategories = [
        Category(
          id: 1,
          name: 'Real Estate',
          icon: '🏠',
          image: null,
          parentId: null,
          level: 0,
          children: [],
        ),
        Category(
          id: 2,
          name: 'Vehicles',
          icon: '🚗',
          image: null,
          parentId: null,
          level: 0,
          children: [],
        ),
      ];

      test('returns cached categories when cache is valid', () async {
        // Arrange
        when(mockCacheService.getCachedCategories())
            .thenAnswer((_) async => mockCategories);

        // Act
        final result = await repository.getCategories();

        // Assert
        expect(result, mockCategories);
        verify(mockCacheService.getCachedCategories()).called(1);
        verifyNever(mockConnectivityService.isConnected());
      });

      test('fetches from API when cache is empty and connected', () async {
        // Arrange
        when(mockCacheService.getCachedCategories())
            .thenAnswer((_) async => null);
        when(mockConnectivityService.isConnected())
            .thenAnswer((_) async => true);
        when(mockApiClient.get<List<dynamic>>('/categories'))
            .thenAnswer((_) async => [
          {
            'id': 1,
            'name': 'Real Estate',
            'icon': '🏠',
            'image': null,
            'parentId': null,
            'level': 0,
            'children': [],
          },
          {
            'id': 2,
            'name': 'Vehicles',
            'icon': '🚗',
            'image': null,
            'parentId': null,
            'level': 0,
            'children': [],
          },
        ]);
        when(mockCacheService.cacheCategories(any))
            .thenAnswer((_) async => {});

        // Act
        final result = await repository.getCategories();

        // Assert
        expect(result.length, 2);
        expect(result[0].name, 'Real Estate');
        verify(mockApiClient.get<List<dynamic>>('/categories')).called(1);
        verify(mockCacheService.cacheCategories(any)).called(1);
      });

      test('throws NetworkException when offline and no cache', () async {
        // Arrange
        when(mockCacheService.getCachedCategories())
            .thenAnswer((_) async => null);
        when(mockConnectivityService.isConnected())
            .thenAnswer((_) async => false);

        // Act & Assert
        expect(
          () => repository.getCategories(),
          throwsA(isA<NetworkException>()),
        );
      });

      test('returns fallback cache when API fails', () async {
        // Arrange
        when(mockCacheService.getCachedCategories())
            .thenAnswer((_) async => null);
        when(mockConnectivityService.isConnected())
            .thenAnswer((_) async => true);
        when(mockApiClient.get<List<dynamic>>('/categories'))
            .thenThrow(ApiException('Failed', 500));
        when(mockCacheService.getCachedCategories())
            .thenAnswer((_) async => mockCategories);

        // Act
        final result = await repository.getCategories();

        // Assert
        expect(result, mockCategories);
      });
    });

    group('getGovernorates', () {
      final mockGovernorates = [
        Governorate(id: 1, name: 'Cairo', isActive: true, order: 1),
        Governorate(id: 2, name: 'Giza', isActive: true, order: 2),
      ];

      test('returns cached governorates when available', () async {
        // Arrange
        when(mockCacheService.getCachedGovernorates())
            .thenAnswer((_) async => mockGovernorates);

        // Act
        final result = await repository.getGovernorates();

        // Assert
        expect(result, mockGovernorates);
        verify(mockCacheService.getCachedGovernorates()).called(1);
      });

      test('fetches from API when cache is empty', () async {
        // Arrange
        when(mockCacheService.getCachedGovernorates())
            .thenAnswer((_) async => null);
        when(mockConnectivityService.isConnected())
            .thenAnswer((_) async => true);
        when(mockApiClient.get<List<dynamic>>('/governorates'))
            .thenAnswer((_) async => [
          {'id': 1, 'name': 'Cairo', 'isActive': true, 'order': 1},
          {'id': 2, 'name': 'Giza', 'isActive': true, 'order': 2},
        ]);
        when(mockCacheService.cacheGovernorates(any))
            .thenAnswer((_) async => {});

        // Act
        final result = await repository.getGovernorates();

        // Assert
        expect(result.length, 2);
        expect(result[0].name, 'Cairo');
      });
    });

    group('caching with TTL', () {
      test('refreshes expired cache from API', () async {
        // Arrange - simulate expired cache
        when(mockCacheService.getCachedCategories())
            .thenAnswer((_) async => null); // Cache expired
        when(mockConnectivityService.isConnected())
            .thenAnswer((_) async => true);

        final mockCategories = [
          Category(
            id: 1,
            name: 'Updated Category',
            icon: '📦',
            image: null,
            parentId: null,
            level: 0,
            children: [],
          ),
        ];

        when(mockApiClient.get<List<dynamic>>('/categories'))
            .thenAnswer((_) async => [
          {
            'id': 1,
            'name': 'Updated Category',
            'icon': '📦',
            'image': null,
            'parentId': null,
            'level': 0,
            'children': [],
          },
        ]);
        when(mockCacheService.cacheCategories(any))
            .thenAnswer((_) async => {});

        // Act
        final result = await repository.getCategories();

        // Assert
        expect(result[0].name, 'Updated Category');
        verify(mockApiClient.get<List<dynamic>>('/categories')).called(1);
        verify(mockCacheService.cacheCategories(any)).called(1);
      });
    });
  });
}
