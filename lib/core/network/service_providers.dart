import 'package:event_and_voucher/services/event_service.dart';
import 'package:event_and_voucher/services/voucher_service.dart';
import 'package:event_and_voucher/services/auth_service.dart';
import 'package:event_and_voucher/core/network/api_client_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for EventService
final eventServiceProvider = Provider<EventService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return EventService(apiClient);
});

/// Provider for VoucherService
final voucherServiceProvider = Provider<VoucherService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return VoucherService(apiClient);
});

/// Provider for AuthService
final authServiceProvider = Provider<AuthService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthService(apiClient);
});
