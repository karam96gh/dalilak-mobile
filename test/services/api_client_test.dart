import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:dalilak_app/services/api_client.dart';
import 'package:dalilak_app/utils/exceptions.dart';

// Generate mocks
class MockDio extends Mock implements Dio {}

void main() {
  group('ApiClient', () {
    late MockDio mockDio;
    late ApiClient apiClient;

    setUp(() {
      mockDio = MockDio();
      apiClient = ApiClient(dio: mockDio);
    });

    group('get method', () {
      test('returns data successfully on 200 response', () async {
        // Arrange
        const endpoint = '/test';
        const expectedData = {'id': 1, 'name': 'Test'};
        
        when(mockDio.get<Map<String, dynamic>>(
          endpoint,
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
        )).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: endpoint),
          statusCode: 200,
          data: expectedData,
        ));

        // Act
        final result = await apiClient.get<Map<String, dynamic>>(endpoint);

        // Assert
        expect(result, expectedData);
        verify(mockDio.get<Map<String, dynamic>>(
          endpoint,
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
        )).called(1);
      });

      test('throws ApiException on 404 error', () async {
        // Arrange
        const endpoint = '/not-found';
        when(mockDio.get<Map<String, dynamic>>(
          endpoint,
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
        )).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: endpoint),
            response: Response(
              requestOptions: RequestOptions(path: endpoint),
              statusCode: 404,
              data: {'message': 'Not found'},
            ),
          ),
        );

        // Act & Assert
        expect(
          () => apiClient.get<Map<String, dynamic>>(endpoint),
          throwsA(isA<ApiException>()),
        );
      });

      test('throws NetworkException on connection timeout', () async {
        // Arrange
        const endpoint = '/test';
        when(mockDio.get<Map<String, dynamic>>(
          endpoint,
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
        )).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: endpoint),
            type: DioExceptionType.connectionTimeout,
          ),
        );

        // Act & Assert
        expect(
          () => apiClient.get<Map<String, dynamic>>(endpoint),
          throwsA(isA<AppException>()),
        );
      });
    });

    group('post method', () {
      test('sends data and returns response successfully', () async {
        // Arrange
        const endpoint = '/create';
        const requestData = {'name': 'New Item'};
        const responseData = {'id': 1, 'name': 'New Item'};

        when(mockDio.post<Map<String, dynamic>>(
          endpoint,
          data: requestData,
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
        )).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: endpoint),
          statusCode: 201,
          data: responseData,
        ));

        // Act
        final result = await apiClient.post<Map<String, dynamic>>(
          endpoint,
          data: requestData,
        );

        // Assert
        expect(result, responseData);
        verify(mockDio.post<Map<String, dynamic>>(
          endpoint,
          data: requestData,
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
        )).called(1);
      });

      test('throws ApiException on 400 bad request', () async {
        // Arrange
        const endpoint = '/create';
        const requestData = {'name': ''};
        
        when(mockDio.post<Map<String, dynamic>>(
          endpoint,
          data: requestData,
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
        )).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: endpoint),
            response: Response(
              requestOptions: RequestOptions(path: endpoint),
              statusCode: 400,
              data: {'message': 'Bad request'},
            ),
          ),
        );

        // Act & Assert
        expect(
          () => apiClient.post<Map<String, dynamic>>(
            endpoint,
            data: requestData,
          ),
          throwsA(isA<ApiException>()),
        );
      });
    });

    group('put method', () {
      test('updates data and returns response successfully', () async {
        // Arrange
        const endpoint = '/update/1';
        const updateData = {'name': 'Updated Name'};
        const responseData = {'id': 1, 'name': 'Updated Name'};

        when(mockDio.put<Map<String, dynamic>>(
          endpoint,
          data: updateData,
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
        )).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: endpoint),
          statusCode: 200,
          data: responseData,
        ));

        // Act
        final result = await apiClient.put<Map<String, dynamic>>(
          endpoint,
          data: updateData,
        );

        // Assert
        expect(result, responseData);
      });
    });

    group('delete method', () {
      test('deletes resource successfully', () async {
        // Arrange
        const endpoint = '/delete/1';

        when(mockDio.delete<Map<String, dynamic>>(
          endpoint,
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
        )).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: endpoint),
          statusCode: 204,
          data: null,
        ));

        // Act
        final result = await apiClient.delete<Map<String, dynamic>>(endpoint);

        // Assert
        expect(result, isNull);
      });
    });

    test('handles server error (500)', () async {
      // Arrange
      const endpoint = '/error';
      when(mockDio.get<Map<String, dynamic>>(
        endpoint,
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
      )).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: endpoint),
          response: Response(
            requestOptions: RequestOptions(path: endpoint),
            statusCode: 500,
            data: {'message': 'Internal server error'},
          ),
        ),
      );

      // Act & Assert
      expect(
        () => apiClient.get<Map<String, dynamic>>(endpoint),
        throwsA(isA<ApiException>()),
      );
    });
  });
}
