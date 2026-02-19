import '../../../service/api_service.dart';
import '../model/product_model.dart';

class ProductRepository {
  final ApiService apiService;

  ProductRepository(this.apiService);

  Future<List<Product>> fetchProducts() async {
    final data = await apiService.getProducts();
    return data.map((e) => Product.fromJson(e)).toList();
  }
}
