// Response models for API calls
class ApiResponse<T> {
  final bool success;
  final T data;
  final String? message;

  ApiResponse({
    required this.success,
    required this.data,
    this.message,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?)? fromJson,
  ) {
    return ApiResponse(
      success: json['success'] as bool,
      data: fromJson != null ? fromJson(json['data']) : json['data'] as T,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson(Object? Function(T)? toJson) => {
    'success': success,
    'data': toJson != null ? toJson(data) : data,
    'message': message,
  };
}

class PaginatedResponse<T> {
  final bool success;
  final List<T> data;
  final int total;
  final int page;
  final int limit;
  final String? message;

  PaginatedResponse({
    required this.success,
    required this.data,
    required this.total,
    required this.page,
    required this.limit,
    this.message,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?)? fromJson,
  ) {
    return PaginatedResponse(
      success: json['success'] as bool,
      data: (json['data'] as List)
          .map((item) => fromJson != null ? fromJson(item) : item as T)
          .toList(),
      total: json['total'] as int,
      page: json['page'] as int,
      limit: json['limit'] as int,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson(Object? Function(T)? toJson) => {
    'success': success,
    'data': toJson != null ? data.map(toJson).toList() : data,
    'total': total,
    'page': page,
    'limit': limit,
    'message': message,
  };
}
