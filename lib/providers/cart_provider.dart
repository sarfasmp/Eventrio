import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:event_and_voucher/models/cart_item.dart';
import 'package:event_and_voucher/models/event.dart';
import 'package:event_and_voucher/models/voucher.dart';

class CartState {
  final List<CartItem> items;

  CartState({List<CartItem>? items}) : items = items ?? [];

  CartState copyWith({List<CartItem>? items}) {
    return CartState(items: items ?? this.items);
  }

  int get itemCount => items.length;

  double get totalPrice {
    return items.fold(0.0, (sum, item) => sum + item.price);
  }
}

class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(CartState());

  void addEvent(Event event, {int quantity = 1}) {
    final items = List<CartItem>.from(state.items);
    final existingIndex = items.indexWhere(
      (item) => item.type == CartItemType.event && item.event?.id == event.id,
    );

    if (existingIndex >= 0) {
      final existingItem = items[existingIndex];
      items[existingIndex] = CartItem(
        id: existingItem.id,
        type: CartItemType.event,
        event: event,
        quantity: existingItem.quantity + quantity,
      );
    } else {
      items.add(
        CartItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          type: CartItemType.event,
          event: event,
          quantity: quantity,
        ),
      );
    }
    state = state.copyWith(items: items);
  }

  void addVoucher(Voucher voucher, {int quantity = 1}) {
    final items = List<CartItem>.from(state.items);
    final existingIndex = items.indexWhere(
      (item) => item.type == CartItemType.voucher && item.voucher?.id == voucher.id,
    );

    if (existingIndex >= 0) {
      final existingItem = items[existingIndex];
      items[existingIndex] = CartItem(
        id: existingItem.id,
        type: CartItemType.voucher,
        voucher: voucher,
        quantity: existingItem.quantity + quantity,
      );
    } else {
      items.add(
        CartItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          type: CartItemType.voucher,
          voucher: voucher,
          quantity: quantity,
        ),
      );
    }
    state = state.copyWith(items: items);
  }

  void removeItem(String id) {
    final items = List<CartItem>.from(state.items);
    items.removeWhere((item) => item.id == id);
    state = state.copyWith(items: items);
  }

  void updateQuantity(String id, int quantity) {
    final items = List<CartItem>.from(state.items);
    final index = items.indexWhere((item) => item.id == id);
    if (index >= 0 && quantity > 0) {
      final item = items[index];
      items[index] = CartItem(
        id: item.id,
        type: item.type,
        event: item.event,
        voucher: item.voucher,
        quantity: quantity,
      );
      state = state.copyWith(items: items);
    }
  }

  void clear() {
    state = CartState();
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier();
});
