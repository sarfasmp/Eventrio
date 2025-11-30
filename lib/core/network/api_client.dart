import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'api_exceptions.dart';
import 'api_interceptors.dart';
import 'api_endpoints.dart';

/// Main API client class using Dio
class ApiClient {
  late final Dio _dio;

  ApiClient({
    String? baseUrl,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Duration? sendTimeout,
    List<Interceptor>? additionalInterceptors,
    Future<String?> Function()? onRefreshToken,
  }) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl ?? ApiEndpoints.baseUrl,
        connectTimeout: connectTimeout ?? const Duration(seconds: 30),
        receiveTimeout: receiveTimeout ?? const Duration(seconds: 30),
        sendTimeout: sendTimeout ?? const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors in order
    _dio.interceptors.addAll([
      RequestInterceptor(),
      RetryInterceptor(maxRetries: 3),
      if (onRefreshToken != null)
        TokenRefreshInterceptor(
          dio: _dio,
          onRefreshToken: onRefreshToken,
        ),
      if (additionalInterceptors != null) ...additionalInterceptors,
    ]);

    // Enable debug mode in development
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          requestHeader: true,
          responseHeader: false,
          error: true,
        ),
      );
    }
  }

  /// Get the underlying Dio instance
  Dio get dio => _dio;

  /// Set auth token
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  /// Clear auth token
  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  /// Handle Dio exceptions and convert to custom exceptions
  ApiException _handleDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException(
          message: 'Request timeout. Please check your connection.',
          originalError: error,
        );

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data?['message'] as String? ??
            error.response?.data?['error'] as String? ??
            'An error occurred';

        switch (statusCode) {
          case 400:
            return BadRequestException(
              message: message,
              originalError: error,
            );
          case 401:
            return UnauthorizedException(
              message: message,
              originalError: error,
            );
          case 404:
            return NotFoundException(
              message: message,
              originalError: error,
            );
          case 500:
          case 502:
          case 503:
            return ServerException(
              message: message,
              originalError: error,
            );
          default:
            return ApiException(
              message: message,
              statusCode: statusCode,
              originalError: error,
            );
        }

      case DioExceptionType.cancel:
        return CancelException(
          originalError: error,
        );

      case DioExceptionType.connectionError:
        return NetworkException(
          message: 'No internet connection. Please check your network.',
          originalError: error,
        );

      case DioExceptionType.badCertificate:
        return ApiException(
          message: 'Certificate error',
          originalError: error,
        );

      case DioExceptionType.unknown:
        return UnknownException(
          message: error.message ?? 'An unknown error occurred',
          originalError: error,
        );
    }
  }

  /// GET request
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// POST request
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// PUT request
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// PATCH request
  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// DELETE request
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// Download file
  Future<Response> download(
    String urlPath,
    String savePath, {
    ProgressCallback? onReceiveProgress,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    bool deleteOnError = true,
    String lengthHeader = Headers.contentLengthHeader,
    Options? options,
  }) async {
    try {
      return await _dio.download(
        urlPath,
        savePath,
        onReceiveProgress: onReceiveProgress,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        deleteOnError: deleteOnError,
        lengthHeader: lengthHeader,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// Upload file
  Future<Response<T>> uploadFile<T>(
    String path,
    String filePath, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
    Options? options,
  }) async {
    try {
      final formData = FormData.fromMap({
        ...?data,
        'file': await MultipartFile.fromFile(filePath),
      });

      return await _dio.post<T>(
        path,
        data: formData,
        queryParameters: queryParameters,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }
}

/// Singleton instance of ApiClient
class ApiClientSingleton {
  static ApiClient? _instance;

  static ApiClient getInstance({
    String? baseUrl,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Duration? sendTimeout,
    List<Interceptor>? additionalInterceptors,
    Future<String?> Function()? onRefreshToken,
  }) {
    _instance ??= ApiClient(
      baseUrl: baseUrl,
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
      sendTimeout: sendTimeout,
      additionalInterceptors: additionalInterceptors,
      onRefreshToken: onRefreshToken,
    );
    return _instance!;
  }

  static void reset() {
    _instance = null;
  }
}
