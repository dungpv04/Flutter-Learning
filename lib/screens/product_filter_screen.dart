import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import 'dart:io';

class ProductFilterScreen extends StatefulWidget {
  const ProductFilterScreen({super.key});

  @override
  State<ProductFilterScreen> createState() => _ProductFilterScreenState();
}

class _ProductFilterScreenState extends State<ProductFilterScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  
  // Filter controls
  final _minPriceController = TextEditingController();
  final _maxPriceController = TextEditingController();
  
  String? _selectedCategory;
  String _sortBy = 'name'; // name, price_asc, price_desc, date
  bool _showDiscountedOnly = false;
  bool _showAvailableOnly = false;
  
  // Results
  List<Map<String, dynamic>> _allProducts = [];
  List<Map<String, dynamic>> _filteredProducts = [];
  Map<int, List<String>> _productImages = {};
  bool _isLoading = true;

  final List<String> _categories = [
    'Tất cả',
    'Điện tử',
    'Thời trang',
    'Gia dụng',
    'Sách',
    'Thể thao',
    'Sức khỏe & Làm đẹp',
    'Ô tô & Xe máy',
    'Khác',
  ];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final products = await _dbHelper.getAllProducts();
      final Map<int, List<String>> images = {};
      
      // Load images for each product
      for (final product in products) {
        final productImages = await _dbHelper.getProductImages(product['id']);
        images[product['id']] = productImages.map((img) => img['imagePath'] as String).toList();
      }
      
      setState(() {
        _allProducts = products;
        _filteredProducts = products;
        _productImages = images;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi tải dữ liệu: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lọc Sản Phẩm'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _resetFilters();
            },
            tooltip: 'Đặt lại',
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Section
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[50],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Lọc sản phẩm',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildFilterControls(),
              ],
            ),
          ),
          
          // Results Section
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildProductResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterControls() {
    return Column(
      children: [
        // Price Range
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _minPriceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Từ giá',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                  isDense: true,
                ),
                onChanged: (value) => _applyFilters(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                controller: _maxPriceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Đến giá',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                  isDense: true,
                ),
                onChanged: (value) => _applyFilters(),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Category and Sort
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Danh mục',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category == 'Tất cả' ? null : category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                  _applyFilters();
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _sortBy,
                decoration: const InputDecoration(
                  labelText: 'Sắp xếp',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                items: const [
                  DropdownMenuItem(value: 'name', child: Text('Tên A-Z')),
                  DropdownMenuItem(value: 'price_asc', child: Text('Giá tăng dần')),
                  DropdownMenuItem(value: 'price_desc', child: Text('Giá giảm dần')),
                  DropdownMenuItem(value: 'date', child: Text('Mới nhất')),
                ],
                onChanged: (String? newValue) {
                  setState(() {
                    _sortBy = newValue!;
                  });
                  _applyFilters();
                },
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Checkboxes
        Row(
          children: [
            Expanded(
              child: CheckboxListTile(
                title: const Text(
                  'Ưu đãi',
                  style: TextStyle(fontSize: 14),
                ),
                value: _showDiscountedOnly,
                onChanged: (value) {
                  setState(() {
                    _showDiscountedOnly = value!;
                  });
                  _applyFilters();
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                dense: true,
              ),
            ),
            Expanded(
              child: CheckboxListTile(
                title: const Text(
                  'Còn hàng',
                  style: TextStyle(fontSize: 14),
                ),
                value: _showAvailableOnly,
                onChanged: (value) {
                  setState(() {
                    _showAvailableOnly = value!;
                  });
                  _applyFilters();
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                dense: true,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Apply Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _applyFilters,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
            ),
            child: const Text('Áp dụng'),
          ),
        ),
      ],
    );
  }

  Widget _buildProductResults() {
    if (_filteredProducts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Không tìm thấy sản phẩm',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Hãy thử điều chỉnh bộ lọc',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Results header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Colors.teal.withOpacity(0.1),
          child: Row(
            children: [
              Text(
                'Tìm thấy ${_filteredProducts.length} sản phẩm',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: _resetFilters,
                child: const Text('Đặt lại'),
              ),
            ],
          ),
        ),
        
        // Products list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _filteredProducts.length,
            itemBuilder: (context, index) {
              final product = _filteredProducts[index];
              final images = _productImages[product['id']] ?? [];
              
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: _buildProductImage(images),
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          product['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if ((product['isDiscounted'] ?? 0) == 1)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Ưu đãi',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        '${_formatCurrency(product['price'])} VNĐ',
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.teal.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          product['category'],
                          style: const TextStyle(
                            color: Colors.teal,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProductImage(List<String> images) {
    if (images.isEmpty) {
      return Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.shopping_bag,
          color: Colors.grey[600],
          size: 30,
        ),
      );
    }

    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(
          File(images.first),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[300],
              child: Icon(
                Icons.broken_image,
                color: Colors.grey[600],
                size: 24,
              ),
            );
          },
        ),
      ),
    );
  }

  void _applyFilters() {
    setState(() {
      _filteredProducts = _allProducts.where((product) {
        // Price filter
        final price = product['price']?.toDouble() ?? 0.0;
        final minPrice = double.tryParse(_minPriceController.text) ?? 0.0;
        final maxPrice = double.tryParse(_maxPriceController.text) ?? double.infinity;
        
        if (price < minPrice || price > maxPrice) {
          return false;
        }
        
        // Category filter
        if (_selectedCategory != null && product['category'] != _selectedCategory) {
          return false;
        }
        
        // Discount filter
        if (_showDiscountedOnly && (product['isDiscounted'] ?? 0) != 1) {
          return false;
        }
        
        // Available filter (for demo, assume all products are available)
        if (_showAvailableOnly) {
          // In real app, check stock availability
        }
        
        return true;
      }).toList();
      
      // Apply sorting
      _filteredProducts.sort((a, b) {
        switch (_sortBy) {
          case 'name':
            return a['name'].toString().compareTo(b['name'].toString());
          case 'price_asc':
            return (a['price'] ?? 0.0).compareTo(b['price'] ?? 0.0);
          case 'price_desc':
            return (b['price'] ?? 0.0).compareTo(a['price'] ?? 0.0);
          case 'date':
            return b['createdAt'].toString().compareTo(a['createdAt'].toString());
          default:
            return 0;
        }
      });
    });
  }

  void _resetFilters() {
    setState(() {
      _minPriceController.clear();
      _maxPriceController.clear();
      _selectedCategory = null;
      _sortBy = 'name';
      _showDiscountedOnly = false;
      _showAvailableOnly = false;
      _filteredProducts = _allProducts;
    });
  }

  String _formatCurrency(double? amount) {
    if (amount == null) return '0';
    return amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}
