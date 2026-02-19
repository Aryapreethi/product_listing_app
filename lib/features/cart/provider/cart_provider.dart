import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../hive/cart_item_model.dart';

class CartProvider extends ChangeNotifier {
  final Box<CartItem> box;

  CartProvider(this.box);

  List<CartItem> get items => box.values.toList();

  int get count =>
      items.fold(0, (sum, item) => sum + item.quantity);

  double get total =>
      items.fold(0, (sum, item) => sum + (item.price * item.quantity));

  void addToCart(CartItem item) {
    final existing = box.get(item.id);

    if (existing != null) {
      existing.quantity++;
      existing.save();
    } else {
      box.put(item.id, item);
    }

    notifyListeners();
  }

  void decrease(int id) {
    final item = box.get(id);
    if (item == null) return;

    if (item.quantity > 1) {
      item.quantity--;
      item.save();
    } else {
      box.delete(id);
    }

    notifyListeners();
  }

  void clearCart() {
    box.clear();
    notifyListeners();
  }
  void removeItem(int id) {
    box.delete(id);
    notifyListeners();
  }

}


