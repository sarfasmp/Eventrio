import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:event_and_voucher/core/network/service_providers.dart';
import 'package:event_and_voucher/core/network/api_client_provider.dart';
import 'package:event_and_voucher/core/network/api_exceptions.dart';

/// Example usage of the network layer
class NetworkUsageExample {
  final WidgetRef ref;

  NetworkUsageExample(this.ref);

  /// Example: Fetch all events
  Future<void> fetchEvents() async {
    final eventService = ref.read(eventServiceProvider);

    try {
      final result = await eventService.getAllEventsApi();

      if (result.isSuccess && result.data != null) {
        final events = result.data!;
        print('Fetched ${events.length} events');
        // Use events
      } else {
        print('Error fetching events: ${result.message}');
      }
    } on NetworkException catch (e) {
      print('Network error: ${e.message}');
      // Show network error message to user
    } on ServerException catch (e) {
      print('Server error: ${e.message}');
      // Show server error message to user
    } catch (e) {
      print('Unexpected error: $e');
    }
  }

  /// Example: Fetch event by ID
  Future<void> fetchEventById(String id) async {
    final eventService = ref.read(eventServiceProvider);

    final result = await eventService.getEventByIdApi(id);

    if (result.isSuccess) {
      final event = result.data;
      print('Event: ${event?.title}');
    } else {
      print('Error: ${result.message}');
    }
  }

  /// Example: Send OTP
  Future<void> sendOTP(String phoneNumber) async {
    final authService = ref.read(authServiceProvider);

    final result = await authService.sendOTP(phoneNumber);

    if (result.isSuccess) {
      print('OTP sent successfully');
    } else {
      print('Failed to send OTP: ${result.message}');
    }
  }

  /// Example: Verify OTP
  Future<bool> verifyOTP(String phoneNumber, String otp) async {
    final authService = ref.read(authServiceProvider);

    final result = await authService.verifyOTP(
      phoneNumber: phoneNumber,
      otp: otp,
    );

    if (result.isSuccess) {
      final responseData = result.data;
      // Extract token from response
      final token = responseData?['token'];
      if (token != null) {
        // Save token and set in API client
        final apiClient = ref.read(apiClientProvider);
        apiClient.setAuthToken(token);
        return true;
      }
    }

    return false;
  }

  /// Example: Handle API response with proper error handling
  Future<void> handleApiCall() async {
    final eventService = ref.read(eventServiceProvider);

    final result = await eventService.getAllEventsApi();

    switch (result.statusCode) {
      case 200:
        if (result.isSuccess && result.data != null) {
          // Handle success
          final events = result.data!;
          print('Loaded ${events.length} events');
        }
        break;
      case 401:
        // Handle unauthorized - redirect to login
        break;
      case 404:
        // Handle not found
        break;
      case 500:
        // Handle server error
        break;
      default:
        // Handle other errors
        break;
    }
  }
}
