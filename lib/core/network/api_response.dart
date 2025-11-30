/// Standard API response wrapper
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final int? statusCode;
  final dynamic error;

  ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.statusCode,
    this.error,
  });

  factory ApiResponse.success({
    T? data,
    String? message,
    int? statusCode,
  }) {
    return ApiResponse<T>(
      success: true,
      data: data,
      message: message,
      statusCode: statusCode,
    );
  }

  factory ApiResponse.failure({
    String? message,
    int? statusCode,
    dynamic error,
  }) {
    return ApiResponse<T>(
      success: false,
      message: message ?? 'An error occurred',
      statusCode: statusCode,
      error: error,
    );
  }

  bool get isSuccess => success;
  bool get isFailure => !success;
}
