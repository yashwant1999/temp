import 'package:flutter_riverpod/flutter_riverpod.dart';

class Cart {
  final String id;
  final String name;
  final int quantity;

  Cart({required this.id, required this.name, required this.quantity});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
    };
  }

  Cart copyWith({String? id, String? name, int? quantity}) {
    return Cart(
        id: id ?? this.id,
        name: name ?? this.name,
        quantity: quantity ?? this.quantity);
  }

  @override
  String toString() {
    return '$id && $name && $quantity';
  }
}

class CartController extends StateNotifier<List<Cart>> {
  CartController() : super([]);

  // A private list field for holding the cart items.
  final List<Cart> _items = [];

  // Getter to access the items
  List<Cart> get items => _items;

  // Function to update the value according the quanity user is increased or decreased.
  void update({required Cart cartItem}) {
    if (_items.isEmpty) {
      _items.add(cartItem);
      state = _items;
    } else {
      final isContained = isContainItem(cartItem);
      if (!isContained) {
        _items.add(cartItem);
      }

      state = _items;
    }
  }

  // Function to check wheather same element is present or not when user press the counter.
  bool isContainItem(Cart cartItem) {
    for (int i = 0; i < _items.length; i++) {
      if (_items[i].id == cartItem.id) {
        _items[i] = cartItem;
        if (_items[i].quantity == 0) {
          _items.removeAt(i);
        }
        return true;
      }
    }

    return false;
  }
}

final cartControllerProvider =
    StateNotifierProvider<CartController, List<Cart>>((ref) {
  return CartController();
});
