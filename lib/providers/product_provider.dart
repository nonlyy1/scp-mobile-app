import 'package:flutter/foundation.dart';
import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  List<Product> _featuredProducts = [];
  bool _isLoading = false;

  List<Product> get products => _products;
  List<Product> get featuredProducts => _featuredProducts;
  bool get isLoading => _isLoading;

  // Мок продукты для тестирования
  void loadMockProducts() {
    _isLoading = true;
    notifyListeners();

    Future.delayed(const Duration(seconds: 1), () {
      _products = [
        Product(
          id: 1,
          name: 'Fresh Red Tomatoes',
          description: 'Organic fresh red tomatoes',
          price: 1500.0,
          unit: 'kg',
          stockQuantity: 100,
          minOrderQuantity: 5,
          supplierId: 1,
          imageUrl: '',
        ),
        Product(
          id: 2,
          name: 'Potatoes',
          description: 'Fresh potatoes from local farms',
          price: 800.0,
          unit: 'kg',
          stockQuantity: 200,
          minOrderQuantity: 10,
          supplierId: 1,
          imageUrl: '',
        ),
        Product(
          id: 3,
          name: 'Carrots',
          description: 'Sweet fresh carrots',
          price: 1200.0,
          unit: 'kg',
          stockQuantity: 150,
          minOrderQuantity: 5,
          supplierId: 2,
          imageUrl: '',
        ),
      ];

      _featuredProducts = _products.take(2).toList();
      _isLoading = false;
      notifyListeners();
    });
  }

  Product? getProductById(int id) {
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Product> getProductsBySupplier(int supplierId) {
    return _products.where((product) => product.supplierId == supplierId).toList();
  }
}