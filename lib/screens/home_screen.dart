import 'package:flutter/material.dart';
import 'registration_screen.dart';
import 'address_screen.dart';
import 'product_screen.dart';
import 'order_wizard_screen.dart';
import 'product_filter_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BTTH02 - Forms & Data Storage'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Flutter Forms & Data Storage Practice',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            
            // Exercise 1: Registration Form
            _buildMenuCard(
              context,
              'Bài 1: Form Đăng Ký',
              'Form đăng ký & xác minh - nhiều kiểu input',
              Icons.person_add,
              Colors.green,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RegistrationScreen()),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Exercise 2: Address Form
            _buildMenuCard(
              context,
              'Bài 2: Form Địa Chỉ',
              'Form nhập thông tin địa chỉ & bản đồ tích hợp',
              Icons.location_on,
              Colors.orange,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddressScreen()),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Exercise 3: Product Form
            _buildMenuCard(
              context,
              'Bài 3: Form Sản Phẩm',
              'Form nhập sản phẩm - đa loại control',
              Icons.shopping_bag,
              Colors.purple,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProductScreen()),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Exercise 4: Order Wizard (Stepper)
            _buildMenuCard(
              context,
              'Bài 4: Form Đơn Hàng',
              'Form đơn hàng nhiều bước (Wizard / Stepper)',
              Icons.shopping_cart,
              Colors.indigo,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OrderWizardScreen()),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Exercise 5: Product Filter
            _buildMenuCard(
              context,
              'Bài 5: Lọc Sản Phẩm',
              'Form tìm kiếm lọc + hiển thị kết quả động',
              Icons.filter_list,
              Colors.teal,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProductFilterScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[400],
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
