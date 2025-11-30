/// API endpoints configuration
class ApiEndpoints {
  // Base URL - Update this with your actual API base URL
  static const String baseUrl = 'https://api.example.com/v1';

  // Auth endpoints
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String sendOTP = '/auth/send-otp';
  static const String verifyOTP = '/auth/verify-otp';
  static const String refreshToken = '/auth/refresh';

  // Event endpoints
  static const String events = '/events';
  static String eventById(String id) => '/events/$id';
  static String eventsByCategory(String category) => '/events/category/$category';

  // Voucher endpoints
  static const String vouchers = '/vouchers';
  static String voucherById(String id) => '/vouchers/$id';
  static String vouchersByCategory(String category) => '/vouchers/category/$category';

  // User endpoints
  static const String profile = '/user/profile';
  static const String orders = '/user/orders';
  static String orderById(String id) => '/user/orders/$id';

  // Helper method to get full URL
  static String getFullUrl(String endpoint) {
    return '$baseUrl$endpoint';
  }
}
