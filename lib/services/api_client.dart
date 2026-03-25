import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/app_constants.dart';
import '../utils/exceptions.dart';

class ApiClient {
  late Dio _dio;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.apiBaseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        contentType: 'application/json',
        responseType: ResponseType.json,
      ),
    );

    // Add interceptors
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: _onRequest,
        onResponse: _onResponse,
        onError: _onError,
      ),
    );
  }

  Future<T> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic) fromJson,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
      );
      return fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw AppException(message: 'Unexpected error: $e');
    }
  }

  Future<T> post<T>(
    String endpoint, {
    required dynamic data,
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic) fromJson,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );
      return fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw AppException(message: 'Unexpected error: $e');
    }
  }

  Future<T> put<T>(
    String endpoint, {
    required dynamic data,
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic) fromJson,
  }) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );
      return fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw AppException(message: 'Unexpected error: $e');
    }
  }

  Future<T> delete<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic) fromJson,
  }) async {
    try {
      final response = await _dio.delete(
        endpoint,
        queryParameters: queryParameters,
      );
      return fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw AppException(message: 'Unexpected error: $e');
    }
  }

  void _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    if (kDebugMode) {
      debugPrint('');
      debugPrint('╔══════════════════════════════════════════════════════════');
      debugPrint('║ REQUEST: ${options.method} ${options.uri}');
      debugPrint('╠══════════════════════════════════════════════════════════');
      if (options.queryParameters.isNotEmpty) {
        debugPrint('║ Query Params: ${options.queryParameters}');
      }
      if (options.data != null) {
        debugPrint('║ Body: ${options.data}');
      }
      debugPrint('║ Headers: ${options.headers}');
      debugPrint('╚══════════════════════════════════════════════════════════');
    }
    handler.next(options);
  }

  void _onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    final uri = response.requestOptions.uri;
    final method = response.requestOptions.method;
    final statusCode = response.statusCode;

    if (kDebugMode) {
      debugPrint('');
      debugPrint('╔══════════════════════════════════════════════════════════');
      debugPrint('║ RESPONSE: $method $uri');
      debugPrint('╠══════════════════════════════════════════════════════════');
      debugPrint('║ Status Code: $statusCode');
      debugPrint('║ Raw Data Type: ${response.data.runtimeType}');
      debugPrint('║ Raw Data: ${_truncate(response.data.toString(), 500)}');
    }

    // Unwrap API response {success, data, meta}
    if (response.data is Map && response.data['success'] == true) {
      if (response.data['meta'] != null) {
        if (kDebugMode) {
          debugPrint('║ Meta: ${response.data['meta']}');
        }
        response.data = {
          'data': response.data['data'],
          'meta': response.data['meta'],
        };
      } else {
        response.data = response.data['data'];
      }
    }
    if (kDebugMode) {
      debugPrint('║ Unwrapped Type: ${response.data.runtimeType}');
      debugPrint('║ Unwrapped Data: ${_truncate(response.data.toString(), 500)}');
      debugPrint('╚══════════════════════════════════════════════════════════');
    }
    handler.next(response);
  }

  Future<void> _onError(
    DioException e,
    ErrorInterceptorHandler handler,
  ) async {
    if (kDebugMode) {
      debugPrint('');
      debugPrint('╔══════════════════════════════════════════════════════════');
      debugPrint('║ ERROR: ${e.requestOptions.method} ${e.requestOptions.uri}');
      debugPrint('╠══════════════════════════════════════════════════════════');
      debugPrint('║ Type: ${e.type}');
      debugPrint('║ Message: ${e.message}');
      if (e.response != null) {
        debugPrint('║ Status Code: ${e.response?.statusCode}');
        debugPrint('║ Response: ${_truncate(e.response?.data.toString() ?? '', 500)}');
      }
      debugPrint('╚══════════════════════════════════════════════════════════');
    }
    handler.next(e);
  }

  String _truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}... [truncated]';
  }

  AppException _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return NetworkException(
          message: 'Connection timeout',
          code: 'CONNECTION_TIMEOUT',
        );
      case DioExceptionType.sendTimeout:
        return NetworkException(
          message: 'Send timeout',
          code: 'SEND_TIMEOUT',
        );
      case DioExceptionType.receiveTimeout:
        return NetworkException(
          message: 'Receive timeout',
          code: 'RECEIVE_TIMEOUT',
        );
      case DioExceptionType.badResponse:
        return _handleBadResponse(error.response);
      case DioExceptionType.cancel:
        return AppException(message: 'Request cancelled');
      case DioExceptionType.unknown:
        return NetworkException(
          message: 'Unknown error occurred',
          originalException: error,
        );
      default:
        return AppException(
          message: 'Error: ${error.message}',
          originalException: error,
        );
    }
  }

  AppException _handleBadResponse(Response? response) {
    if (response == null) {
      return AppException(message: 'Bad response');
    }

    final statusCode = response.statusCode;
    final data = response.data;

    String message = 'Error: $statusCode';
    if (data is Map && data.containsKey('message')) {
      message = data['message'] as String;
    }

    return ApiException(
      message: message,
      code: statusCode.toString(),
    );
  }

  void close() {
    _dio.close();
  }
}
