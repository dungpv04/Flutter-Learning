import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import '../../widgets/common/product_card.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/error_widget.dart';
import '../add_edit_product/add_edit_product_screen.dart';
import '../../../core/constants/string_constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().loadProducts(refresh: true);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (_searchQuery.isEmpty) {
        context.read<ProductProvider>().loadProducts();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(StringConstants.products),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<ProductProvider>().loadProducts(refresh: true);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: StringConstants.search,
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: Consumer<ProductProvider>(
              builder: (context, provider, child) {
                if (provider.state == ProductState.initial ||
                    (provider.state == ProductState.loading && provider.products.isEmpty)) {
                  return const LoadingWidget();
                }

                if (provider.hasError && provider.products.isEmpty) {
                  return CustomErrorWidget(
                    message: provider.errorMessage,
                    onRetry: () => provider.loadProducts(refresh: true),
                  );
                }

                final displayProducts = _searchQuery.isEmpty
                    ? provider.products
                    : provider.searchProducts(_searchQuery);

                if (displayProducts.isEmpty) {
                  return const Center(
                    child: Text(StringConstants.noProducts),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => provider.loadProducts(refresh: true),
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: displayProducts.length + (provider.hasMore && _searchQuery.isEmpty ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= displayProducts.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final product = displayProducts[index];
                      return ProductCard(
                        product: product,
                        onTap: () => _navigateToEditProduct(product),
                        onEdit: () => _navigateToEditProduct(product),
                        onDelete: () => _showDeleteDialog(product),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddProduct,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _navigateToAddProduct() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddEditProductScreen(),
      ),
    );
  }

  void _navigateToEditProduct(product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditProductScreen(product: product),
      ),
    );
  }

  void _showDeleteDialog(product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(StringConstants.deleteProduct),
          content: Text('${StringConstants.deleteConfirmation}\n"${product.name}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(StringConstants.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<ProductProvider>().deleteProduct(product.id!);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(StringConstants.productDeleted),
                  ),
                );
              },
              child: const Text(StringConstants.delete),
            ),
          ],
        );
      },
    );
  }
}
