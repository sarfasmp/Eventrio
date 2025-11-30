import 'package:event_and_voucher/core/network/network_service.dart';
import 'package:event_and_voucher/core/network/api_endpoints.dart';
import 'package:event_and_voucher/core/network/api_response.dart';
import 'package:event_and_voucher/models/voucher.dart';

/// Service for handling voucher-related API calls
class VoucherService extends NetworkService {
  VoucherService(super.apiClient);

  // Static mock data for backward compatibility
  static final List<Voucher> _mockVouchers = [
    Voucher(
      id: '1',
      title: 'Restaurant Voucher',
      description: 'Enjoy a delicious meal at any participating restaurant. Valid for dine-in or takeout.',
      imageUrl: 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=800',
      price: 50.00,
      discount: 20,
      discountType: 'percentage',
      validUntil: DateTime.now().add(const Duration(days: 90)),
      category: 'Dining',
      availableQuantity: 100,
    ),
    Voucher(
      id: '2',
      title: 'Shopping Discount',
      description: 'Get amazing discounts on your favorite brands. Perfect for fashion and lifestyle shopping.',
      imageUrl: 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=800',
      price: 100.00,
      discount: 30,
      discountType: 'percentage',
      validUntil: DateTime.now().add(const Duration(days: 60)),
      category: 'Shopping',
      availableQuantity: 200,
    ),
    Voucher(
      id: '3',
      title: 'Spa & Wellness',
      description: 'Relax and rejuvenate with our spa voucher. Includes massage, facial, and access to wellness facilities.',
      imageUrl: 'https://images.unsplash.com/photo-1540555700478-4be289fbecef?w=800',
      price: 150.00,
      discount: 50,
      discountType: 'fixed',
      validUntil: DateTime.now().add(const Duration(days: 120)),
      category: 'Wellness',
      availableQuantity: 50,
    ),
    Voucher(
      id: '4',
      title: 'Movie Theater Pass',
      description: 'Watch the latest movies with this theater voucher. Valid for any showtime at participating theaters.',
      imageUrl: 'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?w=800',
      price: 25.00,
      discount: 10,
      discountType: 'fixed',
      validUntil: DateTime.now().add(const Duration(days: 180)),
      category: 'Entertainment',
      availableQuantity: 300,
    ),
    Voucher(
      id: '5',
      title: 'Fitness Center Access',
      description: 'Stay fit with access to gym facilities, group classes, and personal training sessions.',
      imageUrl: 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=800',
      price: 80.00,
      discount: 25,
      discountType: 'percentage',
      validUntil: DateTime.now().add(const Duration(days: 365)),
      category: 'Fitness',
      availableQuantity: 150,
    ),
    Voucher(
      id: '6',
      title: 'Beauty Salon Package',
      description: 'Look your best with haircut, styling, and beauty treatments from top salons.',
      imageUrl: 'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=800',
      price: 75.00,
      discount: 20,
      discountType: 'fixed',
      validUntil: DateTime.now().add(const Duration(days: 90)),
      category: 'Beauty',
      availableQuantity: 100,
    ),
  ];

  // Static methods for backward compatibility (returns mock data)
  static List<Voucher> getAllVouchers() => _mockVouchers;

  static Voucher? getVoucherById(String id) {
    try {
      return _mockVouchers.firstWhere((voucher) => voucher.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<Voucher> getVouchersByCategory(String category) {
    return _mockVouchers.where((voucher) => voucher.category == category).toList();
  }

  /// Get all vouchers (API)
  Future<ApiResponse<List<Voucher>>> getAllVouchersApi() async {
    return get<List<Voucher>>(
      ApiEndpoints.vouchers,
      fromJson: (json) {
        if (json is List) {
          return json.map((item) => Voucher.fromJson(item as Map<String, dynamic>)).toList();
        }
        return [Voucher.fromJson(json as Map<String, dynamic>)];
      },
    );
  }

  /// Get voucher by ID (API)
  Future<ApiResponse<Voucher>> getVoucherByIdApi(String id) async {
    return get<Voucher>(
      ApiEndpoints.voucherById(id),
      fromJson: (json) => Voucher.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Get vouchers by category (API)
  Future<ApiResponse<List<Voucher>>> getVouchersByCategoryApi(String category) async {
    return get<List<Voucher>>(
      ApiEndpoints.vouchersByCategory(category),
      fromJson: (json) {
        if (json is List) {
          return json.map((item) => Voucher.fromJson(item as Map<String, dynamic>)).toList();
        }
        return [Voucher.fromJson(json as Map<String, dynamic>)];
      },
    );
  }

  /// Create a new voucher (admin only)
  Future<ApiResponse<Voucher>> createVoucher(Voucher voucher) async {
    return post<Voucher>(
      ApiEndpoints.vouchers,
      data: voucher.toJson(),
      fromJson: (json) => Voucher.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Update an existing voucher (admin only)
  Future<ApiResponse<Voucher>> updateVoucher(String id, Voucher voucher) async {
    return put<Voucher>(
      ApiEndpoints.voucherById(id),
      data: voucher.toJson(),
      fromJson: (json) => Voucher.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Delete a voucher (admin only)
  Future<ApiResponse<void>> deleteVoucher(String id) async {
    return delete<void>(ApiEndpoints.voucherById(id));
  }
}
