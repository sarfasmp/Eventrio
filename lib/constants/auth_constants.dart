class AuthConstants {
  static const List<Map<String, String>> countryCodes = [
    {'code': '+1', 'name': 'US', 'flag': '????'},
    {'code': '+44', 'name': 'UK', 'flag': '????'},
    {'code': '+91', 'name': 'IN', 'flag': '????'},
    {'code': '+86', 'name': 'CN', 'flag': '????'},
    {'code': '+81', 'name': 'JP', 'flag': '????'},
    {'code': '+33', 'name': 'FR', 'flag': '????'},
    {'code': '+49', 'name': 'DE', 'flag': '????'},
    {'code': '+61', 'name': 'AU', 'flag': '????'},
  ];

  static const String demoMessage = 'For demo: OTP will be printed in console';
  static const String termsMessage = 'By continuing, you agree to our Terms of Service and Privacy Policy';
  static const int otpLength = 6;
  static const int resendTimerDuration = 60;
}
