# Advanced Network Request Handling with Dio

This project uses Dio for advanced network request handling with the following features:

## Features

### 1. **API Client (`api_client.dart`)**
- Centralized Dio instance with configurable timeouts
- Automatic request/response logging in debug mode
- Custom exception handling
- Support for GET, POST, PUT, PATCH, DELETE requests
- File upload and download support

### 2. **Interceptors (`api_interceptors.dart`)**
- **RequestInterceptor**: Logs requests, adds headers, handles authentication tokens
- **TokenRefreshInterceptor**: Automatically refreshes expired tokens on 401 errors
- **RetryInterceptor**: Automatically retries failed requests (network errors, timeouts, 5xx errors)

### 3. **Error Handling (`api_exceptions.dart`)**
Custom exception classes:
- `NetworkException` - No internet connection
- `BadRequestException` - 400 errors
- `UnauthorizedException` - 401 errors
- `NotFoundException` - 404 errors
- `ServerException` - 500+ errors
- `TimeoutException` - Request timeouts
- `CancelException` - Cancelled requests

### 4. **Response Wrapper (`api_response.dart`)**
Standardized `ApiResponse<T>` wrapper with:
- Success/failure status
- Data payload
- Error messages
- Status codes

### 5. **Network Service Base Class (`network_service.dart`)**
Abstract base class for all services with:
- Common request handling
- Automatic JSON parsing
- Error handling
- Type-safe responses

### 6. **API Endpoints (`api_endpoints.dart`)**
Centralized endpoint configuration

## Usage

### Basic Usage

```dart
// Get API client from provider
final apiClient = ref.read(apiClientProvider);

// Make a request
final response = await apiClient.get('/events');

// Handle response
if (response.statusCode == 200) {
  final data = response.data;
  // Process data
}
```

### Using Services

```dart
// Get service from provider
final eventService = ref.read(eventServiceProvider);

// Make API call
final result = await eventService.getAllEvents();

// Handle ApiResponse
if (result.isSuccess) {
  final events = result.data; // List<Event>
  // Use events
} else {
  print('Error: ${result.message}');
}
```

### Error Handling

```dart
try {
  final result = await eventService.getAllEvents();
  if (result.isSuccess) {
    // Handle success
  } else {
    // Handle API error
    print('Error: ${result.message}');
  }
} on NetworkException catch (e) {
  // Handle network error
  print('No internet: ${e.message}');
} on UnauthorizedException catch (e) {
  // Handle auth error
  print('Unauthorized: ${e.message}');
} catch (e) {
  // Handle other errors
  print('Unexpected error: $e');
}
```

### Authentication

```dart
// Set auth token
final apiClient = ref.read(apiClientProvider);
apiClient.setAuthToken('your-token-here');

// Clear token on logout
apiClient.clearAuthToken();
```

### Token Refresh

To enable automatic token refresh, configure the provider:

```dart
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClientSingleton.getInstance(
    onRefreshToken: () async {
      // Implement your token refresh logic
      final refreshToken = await getRefreshToken();
      final response = await refreshToken(refreshToken);
      return response.data['accessToken'];
    },
  );
});
```

### Custom Configuration

```dart
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClientSingleton.getInstance(
    baseUrl: 'https://your-api.com/api/v1',
    connectTimeout: Duration(seconds: 30),
    receiveTimeout: Duration(seconds: 30),
    sendTimeout: Duration(seconds: 30),
  );
});
```

## File Structure

```
lib/
  core/
    network/
      api_client.dart          # Main Dio client
      api_client_provider.dart # Riverpod provider
      api_endpoints.dart       # Endpoint configuration
      api_exceptions.dart      # Custom exceptions
      api_interceptors.dart    # Request/Response interceptors
      api_response.dart        # Response wrapper
      network_service.dart     # Base service class
      service_providers.dart   # Service providers
  services/
    event_service.dart         # Event API service
    voucher_service.dart       # Voucher API service
    auth_service.dart          # Auth API service
  models/
    event.dart                 # Event model with fromJson/toJson
    voucher.dart               # Voucher model with fromJson/toJson
```

## Configuration

Update `api_endpoints.dart` with your actual API base URL:

```dart
static const String baseUrl = 'https://your-api.com/v1';
```

## Best Practices

1. **Always use services** - Don't call API client directly, use service classes
2. **Handle errors** - Always check `result.isSuccess` before accessing data
3. **Use providers** - Use Riverpod providers to access services
4. **Type safety** - Use generic types for better type safety
5. **Logging** - Requests are automatically logged in debug mode
