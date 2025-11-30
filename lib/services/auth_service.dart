import 'package:event_and_voucher/core/network/network_service.dart';
import 'package:event_and_voucher/core/network/api_endpoints.dart';
import 'package:event_and_voucher/core/network/api_response.dart';

/// Service for handling authentication-related API calls
class AuthService extends NetworkService {
  AuthService(super.apiClient);

  /// Send OTP to phone number
  Future<ApiResponse<Map<String, dynamic>>> sendOTP(String phoneNumber) async {
    return post<Map<String, dynamic>>(
      ApiEndpoints.sendOTP,
      data: {'phoneNumber': phoneNumber},
      fromJson: (json) => json as Map<String, dynamic>,
    );
  }

  /// Verify OTP
  Future<ApiResponse<Map<String, dynamic>>> verifyOTP({
    required String phoneNumber,
    required String otp,
  }) async {
    return post<Map<String, dynamic>>(
      ApiEndpoints.verifyOTP,
      data: {
        'phoneNumber': phoneNumber,
        'otp': otp,
      },
      fromJson: (json) => json as Map<String, dynamic>,
    );
  }

  /// Login with credentials
  Future<ApiResponse<Map<String, dynamic>>> login({
    required String email,
    required String password,
  }) async {
    return post<Map<String, dynamic>>(
      ApiEndpoints.login,
      data: {
        'email': email,
        'password': password,
      },
      fromJson: (json) => json as Map<String, dynamic>,
    );
  }

  /// Logout
  Future<ApiResponse<void>> logout() async {
    return post<void>(ApiEndpoints.logout);
  }

  /// Refresh access token
  Future<ApiResponse<Map<String, dynamic>>> refreshToken(String refreshToken) async {
    return post<Map<String, dynamic>>(
      ApiEndpoints.refreshToken,
      data: {'refreshToken': refreshToken},
      fromJson: (json) => json as Map<String, dynamic>,
    );
  }
}
