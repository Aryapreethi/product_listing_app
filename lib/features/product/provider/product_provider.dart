import 'package:flutter/material.dart';
import '../model/product_model.dart';
import '../repository/product_repo.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepository repository;

  ProductProvider(this.repository);

  List<Product> _products = [];
  List<Product> filtered = [];

  bool loading = false;

  Future<void> loadProducts() async {
    loading = true;
    notifyListeners();

    _products = await repository.fetchProducts();
    filtered = _products;

    loading = false;
    notifyListeners();
  }

  void search(String query) {
    filtered = _products
        .where((p) => p.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }

  void sortLowToHigh() {
    filtered.sort((a, b) => a.price.compareTo(b.price));
    notifyListeners();
  }

  void sortHighToLow() {
    filtered.sort((a, b) => b.price.compareTo(a.price));
    notifyListeners();
  }
}
