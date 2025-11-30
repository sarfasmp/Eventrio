/// Custom exception classes for API errors
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic originalError;

  ApiException({
    required this.message,
    this.statusCode,
    this.originalError,
  });

  @override
  String toString() => message;
}

class NetworkException extends ApiException {
  NetworkException({
    super.message = 'No internet connection',
    super.statusCode,
    super.originalError,
  });
}

class BadRequestException extends ApiException {
  BadRequestException({
    super.message = 'Bad request',
    super.statusCode = 400,
    super.originalError,
  });
}

class UnauthorizedException extends ApiException {
  UnauthorizedException({
    super.message = 'Unauthorized access',
    super.statusCode = 401,
    super.originalError,
  });
}

class NotFoundException extends ApiException {
  NotFoundException({
    super.message = 'Resource not found',
    super.statusCode = 404,
    super.originalError,
  });
}

class ServerException extends ApiException {
  ServerException({
    super.message = 'Server error',
    super.statusCode = 500,
    super.originalError,
  });
}

class TimeoutException extends ApiException {
  TimeoutException({
    super.message = 'Request timeout',
    super.statusCode,
    super.originalError,
  });
}

class CancelException extends ApiException {
  CancelException({
    super.message = 'Request cancelled',
    super.statusCode,
    super.originalError,
  });
}

class UnknownException extends ApiException {
  UnknownException({
    super.message = 'An unknown error occurred',
    super.statusCode,
    super.originalError,
  });
}
