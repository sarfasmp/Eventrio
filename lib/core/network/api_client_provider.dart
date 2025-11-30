import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:event_and_voucher/core/network/api_client.dart';
import 'package:event_and_voucher/core/network/api_endpoints.dart';

/// Provider for API client instance
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClientSingleton.getInstance(
    baseUrl: ApiEndpoints.baseUrl,
    // Add token refresh callback if needed
    // onRefreshToken: () async {
    //   // Implement token refresh logic here
    //   return null;
    // },
  );
});
