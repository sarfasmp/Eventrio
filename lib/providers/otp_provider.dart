import 'package:flutter_riverpod/flutter_riverpod.dart';

class OTPState {
  final List<String> otpDigits;
  final int currentIndex;
  final int resendTimer;
  final bool canResend;

  OTPState({
    List<String>? otpDigits,
    this.currentIndex = 0,
    this.resendTimer = 60,
    this.canResend = false,
  }) : otpDigits = otpDigits ?? List.filled(6, '');

  OTPState copyWith({
    List<String>? otpDigits,
    int? currentIndex,
    int? resendTimer,
    bool? canResend,
  }) {
    return OTPState(
      otpDigits: otpDigits ?? this.otpDigits,
      currentIndex: currentIndex ?? this.currentIndex,
      resendTimer: resendTimer ?? this.resendTimer,
      canResend: canResend ?? this.canResend,
    );
  }

  String get otp => otpDigits.join();
  bool get isComplete => otpDigits.every((digit) => digit.isNotEmpty) && otp.length == 6;
}

class OTPNotifier extends StateNotifier<OTPState> {
  OTPNotifier() : super(OTPState()) {
    _startResendTimer();
  }

  void _startResendTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (state.resendTimer > 0) {
        state = state.copyWith(resendTimer: state.resendTimer - 1);
        _startResendTimer();
      } else {
        state = state.copyWith(canResend: true);
      }
    });
  }

  void updateOTPDigit(int index, String value) {
    final newDigits = List<String>.from(state.otpDigits);
    newDigits[index] = value;
    state = state.copyWith(
      otpDigits: newDigits,
      currentIndex: value.isNotEmpty && index < 5 ? index + 1 : index,
    );
  }

  void moveToNextField(int index) {
    if (index < 5) {
      state = state.copyWith(currentIndex: index + 1);
    }
  }

  void moveToPreviousField(int index) {
    if (index > 0) {
      state = state.copyWith(currentIndex: index - 1);
    }
  }

  void clearOTP() {
    state = OTPState(resendTimer: 60, canResend: false);
    _startResendTimer();
  }

  void resetResendTimer() {
    state = state.copyWith(resendTimer: 60, canResend: false);
    _startResendTimer();
  }
}

final otpProvider = StateNotifierProvider<OTPNotifier, OTPState>((ref) {
  return OTPNotifier();
});
