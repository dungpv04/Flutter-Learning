import 'package:flutter/material.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/product_repository.dart';
import '../../core/constants/string_constants.dart';

enum ProductState { initial, loading, loaded, error }

class ProductProvider with ChangeNotifier {
  final ProductRepository _repository;

  ProductProvider({required ProductRepository repository})
      : _repository = repository;

  // State
  ProductState _state = ProductState.initial;
  List<Product> _products = [];
  String _errorMessage = '';
  bool _hasMore = true;
  int _currentPage = 0;
  static const int _pageSize = 20;

  // Getters
  ProductState get state => _state;
  List<Product> get products => _products;
  String get errorMessage => _errorMessage;
  bool get hasMore => _hasMore;
  bool get isLoading => _state == ProductState.loading;
  bool get hasError => _state == ProductState.error;

  // Load products
  Future<void> loadProducts({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 0;
      _products.clear();
      _hasMore = true;
    }

    if (!_hasMore || _state == ProductState.loading) return;

    _setState(ProductState.loading);

    try {
      final newProducts = await _repository.getProducts(
        skip: _currentPage * _pageSize,
        limit: _pageSize,
      );

      if (newProducts.length < _pageSize) {
        _hasMore = false;
      }

      if (refresh) {
        _products = newProducts;
      } else {
        _products.addAll(newProducts);
      }

      _currentPage++;
      _setState(ProductState.loaded);
    } catch (e) {
      _setError(e.toString());
    }
  }

  // Get single product
  Future<Product?> getProduct(int id) async {
    try {
      return await _repository.getProduct(id);
    } catch (e) {
      _setError(e.toString());
      return null;
    }
  }

  // Create product
  Future<bool> createProduct({
    required String name,
    String? description,
    required double price,
  }) async {
    try {
      final request = CreateProductRequest(
        name: name,
        description: description,
        price: price,
      );

      final newProduct = await _repository.createProduct(request);
      _products.insert(0, newProduct);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  // Update product
  Future<bool> updateProduct({
    required int id,
    String? name,
    String? description,
    double? price,
  }) async {
    try {
      final request = UpdateProductRequest(
        name: name,
        description: description,
        price: price,
      );

      final updatedProduct = await _repository.updateProduct(id, request);
      final index = _products.indexWhere((p) => p.id == id);
      
      if (index != -1) {
        _products[index] = updatedProduct;
        notifyListeners();
      }
      
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  // Delete product
  Future<bool> deleteProduct(int id) async {
    try {
      await _repository.deleteProduct(id);
      _products.removeWhere((product) => product.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  // Search products
  List<Product> searchProducts(String query) {
    if (query.isEmpty) return _products;
    
    return _products.where((product) {
      return product.name.toLowerCase().contains(query.toLowerCase()) ||
          (product.description?.toLowerCase().contains(query.toLowerCase()) ?? false);
    }).toList();
  }

  // Clear error
  void clearError() {
    if (_state == ProductState.error) {
      _setState(ProductState.loaded);
    }
  }

  // Private methods
  void _setState(ProductState state) {
    _state = state;
    if (state != ProductState.error) {
      _errorMessage = '';
    }
    notifyListeners();
  }

  void _setError(String message) {
    _state = ProductState.error;
    _errorMessage = message.isEmpty ? StringConstants.unexpectedError : message;
    notifyListeners();
  }
}
