import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginState {
  final String selectedCountryCode;
  final bool isPhoneFocused;
  final String phoneNumber;
  final bool isAnimating;

  LoginState({
    this.selectedCountryCode = '+1',
    this.isPhoneFocused = false,
    this.phoneNumber = '',
    this.isAnimating = true,
  });

  LoginState copyWith({
    String? selectedCountryCode,
    bool? isPhoneFocused,
    String? phoneNumber,
    bool? isAnimating,
  }) {
    return LoginState(
      selectedCountryCode: selectedCountryCode ?? this.selectedCountryCode,
      isPhoneFocused: isPhoneFocused ?? this.isPhoneFocused,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isAnimating: isAnimating ?? this.isAnimating,
    );
  }
}

class LoginNotifier extends StateNotifier<LoginState> {
  LoginNotifier() : super(LoginState()) {
    _initializeAnimations();
  }

  void _initializeAnimations() {
    Future.delayed(const Duration(milliseconds: 100), () {
      state = state.copyWith(isAnimating: false);
    });
  }

  void updateCountryCode(String code) {
    state = state.copyWith(selectedCountryCode: code);
  }

  void updatePhoneFocus(bool focused) {
    state = state.copyWith(isPhoneFocused: focused);
  }

  void updatePhoneNumber(String number) {
    state = state.copyWith(phoneNumber: number);
  }

  String getFullPhoneNumber() {
    return '${state.selectedCountryCode}${state.phoneNumber}';
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    if (value.length < 10) {
      return 'Phone number must be at least 10 digits';
    }
    return null;
  }
}

final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>((ref) {
  return LoginNotifier();
});
