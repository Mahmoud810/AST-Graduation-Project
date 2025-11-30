import 'package:flutter/material.dart';
import 'package:graduation_project/models/cart_item_model.dart';

class CartService {
  CartService._private();
  static final CartService _instance = CartService._private();
  factory CartService() => _instance;

  final ValueNotifier<List<CartItem>> items = ValueNotifier<List<CartItem>>([]);

  void addItem(CartItem item) {
    final list = List<CartItem>.from(items.value);
    final idx = list.indexWhere((e) => e.title == item.title);
    if (idx >= 0) {
      list[idx].quantity += item.quantity;
    } else {
      list.add(item);
    }
    items.value = list;
  }

  void removeItem(String title) {
    final list = List<CartItem>.from(items.value)
      ..removeWhere((e) => e.title == title);
    items.value = list;
  }

  void clear() {
    items.value = [];
  }

  int get count => items.value.fold(0, (p, n) => p + n.quantity);
}
