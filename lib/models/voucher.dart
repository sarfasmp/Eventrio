class Voucher {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  final double discount;
  final String discountType; // 'percentage' or 'fixed'
  final DateTime validUntil;
  final String category;
  final int availableQuantity;

  Voucher({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.discount,
    required this.discountType,
    required this.validUntil,
    required this.category,
    required this.availableQuantity,
  });

  double get finalPrice {
    if (discountType == 'percentage') {
      return price * (1 - discount / 100);
    } else {
      return (price - discount).clamp(0.0, double.infinity);
    }
  }

  bool get isAvailable => availableQuantity > 0 && DateTime.now().isBefore(validUntil);

  factory Voucher.fromJson(Map<String, dynamic> json) {
    return Voucher(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? json['image_url'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      discount: (json['discount'] ?? 0.0).toDouble(),
      discountType: json['discountType'] ?? json['discount_type'] ?? 'percentage',
      validUntil: json['validUntil'] is String
          ? DateTime.parse(json['validUntil'])
          : json['valid_until'] is String
              ? DateTime.parse(json['valid_until'])
              : json['validUntil'] is DateTime
                  ? json['validUntil']
                  : DateTime.now(),
      category: json['category'] ?? '',
      availableQuantity: json['availableQuantity'] ?? json['available_quantity'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
      'discount': discount,
      'discountType': discountType,
      'validUntil': validUntil.toIso8601String(),
      'category': category,
      'availableQuantity': availableQuantity,
    };
  }
}
