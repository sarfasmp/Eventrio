import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Request interceptor for logging and adding headers
class RequestInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add common headers
    options.headers.addAll({
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });

    // Add auth token if available
    // You can get this from your auth provider or secure storage
    // final token = getAuthToken();
    // if (token != null) {
    //   options.headers['Authorization'] = 'Bearer $token';
    // }

    // Log request in debug mode
    if (kDebugMode) {
      print('??????????????????????????????????????????????????????????');
      print('? REQUEST: ${options.method} ${options.uri}');
      print('? Headers: ${options.headers}');
      if (options.data != null) {
        print('? Data: ${options.data}');
      }
      if (options.queryParameters.isNotEmpty) {
        print('? Query Parameters: ${options.queryParameters}');
      }
      print('??????????????????????????????????????????????????????????');
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      print('??????????????????????????????????????????????????????????');
      print('? ERROR: ${err.requestOptions.method} ${err.requestOptions.uri}');
      print('? Status Code: ${err.response?.statusCode}');
      print('? Message: ${err.message}');
      if (err.response?.data != null) {
        print('? Response Data: ${err.response?.data}');
      }
      print('??????????????????????????????????????????????????????????');
    }

    handler.next(err);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      print('??????????????????????????????????????????????????????????');
      print('? RESPONSE: ${response.requestOptions.method} ${response.requestOptions.uri}');
      print('? Status Code: ${response.statusCode}');
      print('? Data: ${response.data}');
      print('??????????????????????????????????????????????????????????');
    }

    handler.next(response);
  }
}

/// Token refresh interceptor for handling 401 errors
class TokenRefreshInterceptor extends Interceptor {
  final Dio dio;
  final Future<String?> Function()? onRefreshToken;

  TokenRefreshInterceptor({
    required this.dio,
    this.onRefreshToken,
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 && onRefreshToken != null) {
      try {
        final newToken = await onRefreshToken!();
        if (newToken != null) {
          // Retry the original request with new token
          final opts = err.requestOptions;
          opts.headers['Authorization'] = 'Bearer $newToken';
          
          final response = await dio.fetch(opts);
          handler.resolve(response);
          return;
        }
      } catch (e) {
        // Token refresh failed, proceed with error
      }
    }
    handler.next(err);
  }
}

/// Retry interceptor for handling network failures
class RetryInterceptor extends Interceptor {
  final int maxRetries;
  final Duration retryDelay;

  RetryInterceptor({
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 1),
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_shouldRetry(err) && err.requestOptions.extra['retryCount'] == null) {
      err.requestOptions.extra['retryCount'] = 0;
    }

    final retryCount = err.requestOptions.extra['retryCount'] as int? ?? 0;

    if (retryCount < maxRetries && _shouldRetry(err)) {
      err.requestOptions.extra['retryCount'] = retryCount + 1;

      await Future.delayed(retryDelay * (retryCount + 1));

      try {
        final response = await Dio().fetch(err.requestOptions);
        handler.resolve(response);
        return;
      } catch (e) {
        if (retryCount + 1 >= maxRetries) {
          handler.next(err);
        } else {
          handler.reject(err);
        }
        return;
      }
    }

    handler.next(err);
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError ||
        (err.response?.statusCode != null &&
            err.response!.statusCode! >= 500);
  }
}
