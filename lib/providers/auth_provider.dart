import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthState {
  final String? phoneNumber;
  final bool isAuthenticated;
  final bool isLoading;
  final String? error;

  AuthState({
    this.phoneNumber,
    this.isAuthenticated = false,
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    String? phoneNumber,
    bool? isAuthenticated,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState());

  void login() {
    state = state.copyWith(isAuthenticated: true);
  }

  // Mock OTP for demo purposes - In production, this would come from your backend
  String? _storedOTP;

  Future<void> sendOTP(String phoneNumber) async {
    state = state.copyWith(isLoading: true, error: null);

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    // Generate a 6-digit OTP (in production, this would be sent via SMS)
    _storedOTP = DateTime.now().millisecondsSinceEpoch.toString().substring(7, 13);
    
    // For demo purposes, print the OTP to console
    print('OTP for $phoneNumber: $_storedOTP');

    state = state.copyWith(
      phoneNumber: phoneNumber,
      isLoading: false,
    );
  }

  Future<bool> verifyOTP(String otp) async {
    state = state.copyWith(isLoading: true, error: null);

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    // For now, accept any OTP (6 digits)
    if (otp.length == 6) {
      state = state.copyWith(
        isAuthenticated: true,
        isLoading: false,
        error: null,
      );
      return true;
    } else {
      state = state.copyWith(
        isLoading: false,
        error: 'Invalid OTP. Please try again.',
      );
      return false;
    }
  }

  void logout() {
    _storedOTP = null;
    state = AuthState();
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
