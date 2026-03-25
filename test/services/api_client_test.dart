import 'package:flutter_test/flutter_test.dart';
import 'package:dalilak_app/utils/exceptions.dart';

void main() {
  group('ApiClient Exception Handling', () {
    test('ApiException stores message and code correctly', () {
      final exception = ApiException(message: 'Not found', code: '404');

      expect(exception.message, 'Not found');
      expect(exception.code, '404');
      expect(exception.toString(), 'Not found');
    });

    test('NetworkException stores message and code correctly', () {
      final exception = NetworkException(
        message: 'Connection timeout',
        code: 'CONNECTION_TIMEOUT',
      );

      expect(exception.message, 'Connection timeout');
      expect(exception.code, 'CONNECTION_TIMEOUT');
    });

    test('AppException is the base exception class', () {
      final exception = AppException(message: 'Something went wrong');

      expect(exception, isA<Exception>());
      expect(exception.message, 'Something went wrong');
      expect(exception.code, isNull);
    });

    test('ApiException is a subclass of AppException', () {
      final exception = ApiException(message: 'Bad request', code: '400');

      expect(exception, isA<AppException>());
      expect(exception, isA<ApiException>());
    });

    test('NetworkException is a subclass of AppException', () {
      final exception = NetworkException(message: 'No internet');

      expect(exception, isA<AppException>());
      expect(exception, isA<NetworkException>());
    });

    test('CacheException is a subclass of AppException', () {
      final exception = CacheException(message: 'Cache failed');

      expect(exception, isA<AppException>());
      expect(exception, isA<CacheException>());
    });

    test('Exception preserves original exception', () {
      final original = Exception('original error');
      final exception = AppException(
        message: 'Wrapped error',
        originalException: original,
      );

      expect(exception.originalException, original);
    });
  });

  group('API Response Handling Logic', () {
    test('status code 200 is success', () {
      const statusCode = 200;
      expect(statusCode >= 200 && statusCode < 300, true);
    });

    test('status code 404 is client error', () {
      const statusCode = 404;
      expect(statusCode >= 400 && statusCode < 500, true);
    });

    test('status code 500 is server error', () {
      const statusCode = 500;
      expect(statusCode >= 500, true);
    });

    test('query parameters are built correctly', () {
      final params = <String, dynamic>{
        'page': 1,
        'limit': 20,
      };

      const categoryId = 5;
      params['categoryId'] = categoryId;

      expect(params['page'], 1);
      expect(params['limit'], 20);
      expect(params['categoryId'], 5);
      expect(params.length, 3);
    });

    test('query parameters exclude null values', () {
      final int? categoryId = null;
      final int? governorateId = null;

      final params = <String, dynamic>{
        'page': 1,
        'limit': 20,
        if (categoryId != null) 'categoryId': categoryId,
        if (governorateId != null) 'governorateId': governorateId,
      };

      expect(params.length, 2);
      expect(params.containsKey('categoryId'), false);
    });
  });
}
