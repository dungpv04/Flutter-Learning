import '../models/product_model.dart';
import '../services/api_service.dart';
import '../../core/errors/failures.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts({int? skip, int? limit});
  Future<Product> getProduct(int id);
  Future<Product> createProduct(CreateProductRequest request);
  Future<Product> updateProduct(int id, UpdateProductRequest request);
  Future<void> deleteProduct(int id);
}

class ProductRepositoryImpl implements ProductRepository {
  final ApiService _apiService;

  ProductRepositoryImpl({required ApiService apiService})
      : _apiService = apiService;

  @override
  Future<List<Product>> getProducts({int? skip, int? limit}) async {
    try {
      return await _apiService.getProducts(skip: skip, limit: limit);
    } catch (e) {
      throw _handleException(e);
    }
  }

  @override
  Future<Product> getProduct(int id) async {
    try {
      return await _apiService.getProduct(id);
    } catch (e) {
      throw _handleException(e);
    }
  }

  @override
  Future<Product> createProduct(CreateProductRequest request) async {
    try {
      return await _apiService.createProduct(request);
    } catch (e) {
      throw _handleException(e);
    }
  }

  @override
  Future<Product> updateProduct(int id, UpdateProductRequest request) async {
    try {
      return await _apiService.updateProduct(id, request);
    } catch (e) {
      throw _handleException(e);
    }
  }

  @override
  Future<void> deleteProduct(int id) async {
    try {
      await _apiService.deleteProduct(id);
    } catch (e) {
      throw _handleException(e);
    }
  }

  Exception _handleException(dynamic error) {
    if (error is Exception) {
      return error;
    } else {
      return Exception('Unexpected error: $error');
    }
  }
}
