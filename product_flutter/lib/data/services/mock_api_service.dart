import '../models/product_model.dart';

class MockApiService {
  static List<Product> _mockProducts = [
    Product(
      id: 1,
      name: 'Laptop Pro Max',
      description: 'A powerful laptop for professionals',
      price: 1500.99,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Product(
      id: 2,
      name: 'Wireless Mouse',
      description: 'Ergonomic wireless mouse with precision tracking',
      price: 29.99,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Product(
      id: 3,
      name: 'Mechanical Keyboard',
      description: 'Premium mechanical keyboard with RGB lighting',
      price: 149.99,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
  ];

  static int _nextId = 4;

  Future<List<Product>> getProducts({int? skip, int? limit}) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    final startIndex = skip ?? 0;
    final endIndex = limit != null ? startIndex + limit : null;
    
    if (startIndex >= _mockProducts.length) {
      return [];
    }
    
    return _mockProducts.sublist(
      startIndex,
      endIndex != null && endIndex < _mockProducts.length 
          ? endIndex 
          : _mockProducts.length,
    );
  }

  Future<Product> getProduct(int id) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    final product = _mockProducts.firstWhere(
      (p) => p.id == id,
      orElse: () => throw Exception('Product not found'),
    );
    
    return product;
  }

  Future<Product> createProduct(CreateProductRequest request) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    final newProduct = Product(
      id: _nextId++,
      name: request.name,
      description: request.description,
      price: request.price,
      createdAt: DateTime.now(),
    );
    
    _mockProducts.insert(0, newProduct);
    return newProduct;
  }

  Future<Product> updateProduct(int id, UpdateProductRequest request) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));
    
    final index = _mockProducts.indexWhere((p) => p.id == id);
    if (index == -1) {
      throw Exception('Product not found');
    }
    
    final existingProduct = _mockProducts[index];
    final updatedProduct = existingProduct.copyWith(
      name: request.name ?? existingProduct.name,
      description: request.description ?? existingProduct.description,
      price: request.price ?? existingProduct.price,
      updatedAt: DateTime.now(),
    );
    
    _mockProducts[index] = updatedProduct;
    return updatedProduct;
  }

  Future<void> deleteProduct(int id) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 400));
    
    final index = _mockProducts.indexWhere((p) => p.id == id);
    if (index == -1) {
      throw Exception('Product not found');
    }
    
    _mockProducts.removeAt(index);
  }
}
