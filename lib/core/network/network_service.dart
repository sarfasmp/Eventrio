import 'package:dio/dio.dart';
import 'api_client.dart';
import 'api_response.dart';
import 'api_exceptions.dart';

/// Base network service class with common functionality
abstract class NetworkService {
  final ApiClient apiClient;

  NetworkService(this.apiClient);

  /// Handle API response and convert to ApiResponse
  ApiResponse<T> handleResponse<T>(
    Response response, {
    T Function(dynamic)? fromJson,
  }) {
    try {
      if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
        final data = response.data;

        if (fromJson != null && data != null) {
          if (data is List) {
            // Handle list responses
            final mappedData = data.map((item) => fromJson(item)).toList();
            return ApiResponse.success(
              data: mappedData as T,
              statusCode: response.statusCode,
            );
          } else {
            // Handle single object responses
            final mappedData = fromJson(data);
            return ApiResponse.success(
              data: mappedData as T,
              statusCode: response.statusCode,
            );
          }
        }

        return ApiResponse.success(
          data: data as T?,
          statusCode: response.statusCode,
        );
      } else {
        return ApiResponse.failure(
          message: response.data?['message'] ?? 'Request failed',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return ApiResponse.failure(
        message: 'Failed to parse response',
        error: e,
      );
    }
  }

  /// Execute request with error handling
  Future<ApiResponse<T>> executeRequest<T>({
    required Future<Response> Function() request,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await request();
      return handleResponse<T>(response, fromJson: fromJson);
    } on ApiException catch (e) {
      return ApiResponse.failure(
        message: e.message,
        statusCode: e.statusCode,
        error: e,
      );
    } catch (e) {
      return ApiResponse.failure(
        message: 'An unexpected error occurred',
        error: e,
      );
    }
  }

  /// GET request helper
  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic)? fromJson,
  }) {
    return executeRequest<T>(
      request: () => apiClient.get(
        path,
        queryParameters: queryParameters,
        options: options,
      ),
      fromJson: fromJson,
    );
  }

  /// POST request helper
  Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic)? fromJson,
  }) {
    return executeRequest<T>(
      request: () => apiClient.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      ),
      fromJson: fromJson,
    );
  }

  /// PUT request helper
  Future<ApiResponse<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic)? fromJson,
  }) {
    return executeRequest<T>(
      request: () => apiClient.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      ),
      fromJson: fromJson,
    );
  }

  /// PATCH request helper
  Future<ApiResponse<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic)? fromJson,
  }) {
    return executeRequest<T>(
      request: () => apiClient.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      ),
      fromJson: fromJson,
    );
  }

  /// DELETE request helper
  Future<ApiResponse<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic)? fromJson,
  }) {
    return executeRequest<T>(
      request: () => apiClient.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      ),
      fromJson: fromJson,
    );
  }
}
