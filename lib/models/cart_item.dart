import 'package:event_and_voucher/models/event.dart';
import 'package:event_and_voucher/models/voucher.dart';

enum CartItemType { event, voucher }

class CartItem {
  final String id;
  final CartItemType type;
  final Event? event;
  final Voucher? voucher;
  final int quantity;

  CartItem({
    required this.id,
    required this.type,
    this.event,
    this.voucher,
    this.quantity = 1,
  });

  double get price {
    if (type == CartItemType.event && event != null) {
      return event!.price * quantity;
    } else if (type == CartItemType.voucher && voucher != null) {
      return voucher!.finalPrice * quantity;
    }
    return 0.0;
  }

  String get title {
    if (type == CartItemType.event && event != null) {
      return event!.title;
    } else if (type == CartItemType.voucher && voucher != null) {
      return voucher!.title;
    }
    return '';
  }

  String get imageUrl {
    if (type == CartItemType.event && event != null) {
      return event!.imageUrl;
    } else if (type == CartItemType.voucher && voucher != null) {
      return voucher!.imageUrl;
    }
    return '';
  }
}
