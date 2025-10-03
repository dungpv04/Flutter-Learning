import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OrderWizardScreen extends StatefulWidget {
  const OrderWizardScreen({super.key});

  @override
  State<OrderWizardScreen> createState() => _OrderWizardScreenState();
}

class _OrderWizardScreenState extends State<OrderWizardScreen> {
  int _currentStep = 0;

  // Step 1: Customer Information
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  // Step 2: Delivery Address (similar to address form from Bài 2)
  String? _selectedProvince;
  String? _selectedDistrict;
  String? _selectedWard;
  final _detailAddressController = TextEditingController();

  // Step 3: Payment & Confirmation
  String _paymentMethod = 'cash'; // cash, credit, transfer
  bool _confirmOrder = false;

  final Map<String, List<String>> _locations = {
    'Hà Nội': ['Ba Đình', 'Hoàn Kiếm', 'Tây Hồ', 'Long Biên', 'Cầu Giấy', 'Đống Đa'],
    'TP.HCM': ['Quận 1', 'Quận 2', 'Quận 3', 'Quận 4', 'Quận 5', 'Quận 7'],
    'Đà Nẵng': ['Hải Châu', 'Thanh Khê', 'Sơn Trà', 'Ngũ Hành Sơn', 'Liên Chiểu'],
  };

  final Map<String, List<String>> _wards = {
    'Ba Đình': ['Phường Phúc Xá', 'Phường Trúc Bạch', 'Phường Vĩnh Phúc'],
    'Hoàn Kiếm': ['Phường Hàng Bạc', 'Phường Hàng Bài', 'Phường Hàng Trống'],
    'Quận 1': ['Phường Bến Nghé', 'Phường Bến Thành', 'Phường Cầu Kho'],
  };

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _detailAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đơn Hàng Nhiều Bước'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepTapped: (step) {
          setState(() {
            _currentStep = step;
          });
        },
        controlsBuilder: (context, details) {
          return Row(
            children: [
              if (details.stepIndex < 2)
                ElevatedButton(
                  onPressed: () => _goToNextStep(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Tiếp tục'),
                ),
              if (details.stepIndex == 2)
                ElevatedButton(
                  onPressed: _submitOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Hoàn thành'),
                ),
              const SizedBox(width: 8),
              if (details.stepIndex > 0)
                TextButton(
                  onPressed: () => _goToPreviousStep(),
                  child: const Text('Quay lại'),
                ),
            ],
          );
        },
        steps: [
          // Step 1: Customer Information
          Step(
            title: const Text('Thông tin khách hàng'),
            content: _buildCustomerInfoStep(),
            isActive: _currentStep >= 0,
            state: _currentStep > 0 ? StepState.complete : StepState.indexed,
          ),
          
          // Step 2: Delivery Address
          Step(
            title: const Text('Địa chỉ giao hàng'),
            content: _buildDeliveryAddressStep(),
            isActive: _currentStep >= 1,
            state: _currentStep > 1 ? StepState.complete : 
                   _currentStep == 1 ? StepState.indexed : StepState.disabled,
          ),
          
          // Step 3: Payment & Confirmation
          Step(
            title: const Text('Thanh toán & xác nhận'),
            content: _buildPaymentConfirmationStep(),
            isActive: _currentStep >= 2,
            state: _currentStep == 2 ? StepState.indexed : StepState.disabled,
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerInfoStep() {
    return Column(
      children: [
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Họ và tên *',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.person),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Email *',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.email),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          decoration: const InputDecoration(
            labelText: 'Điện thoại *',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.phone),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildDeliveryAddressStep() {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          value: _selectedProvince,
          decoration: const InputDecoration(
            labelText: 'Tỉnh/Thành phố *',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.location_city),
          ),
          items: _locations.keys.map((String province) {
            return DropdownMenuItem<String>(
              value: province,
              child: Text(province),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedProvince = newValue;
              _selectedDistrict = null;
              _selectedWard = null;
            });
          },
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: _selectedDistrict,
          decoration: const InputDecoration(
            labelText: 'Quận/Huyện *',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.location_on),
          ),
          items: _selectedProvince != null
              ? _locations[_selectedProvince!]!.map((String district) {
                  return DropdownMenuItem<String>(
                    value: district,
                    child: Text(district),
                  );
                }).toList()
              : [],
          onChanged: (String? newValue) {
            setState(() {
              _selectedDistrict = newValue;
              _selectedWard = null;
            });
          },
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: _selectedWard,
          decoration: const InputDecoration(
            labelText: 'Phường/Xã *',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.place),
          ),
          items: _selectedDistrict != null && _wards.containsKey(_selectedDistrict!)
              ? _wards[_selectedDistrict!]!.map((String ward) {
                  return DropdownMenuItem<String>(
                    value: ward,
                    child: Text(ward),
                  );
                }).toList()
              : [],
          onChanged: (String? newValue) {
            setState(() {
              _selectedWard = newValue;
            });
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _detailAddressController,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Địa chỉ chi tiết *',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.home),
            hintText: 'Số nhà, tên đường...',
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildPaymentConfirmationStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Phương thức thanh toán',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        
        // Payment method selection
        RadioListTile<String>(
          title: const Text('Tiền mặt'),
          subtitle: const Text('Thanh toán khi nhận hàng'),
          value: 'cash',
          groupValue: _paymentMethod,
          onChanged: (value) {
            setState(() {
              _paymentMethod = value!;
            });
          },
        ),
        RadioListTile<String>(
          title: const Text('Thẻ tín dụng'),
          subtitle: const Text('Thanh toán online'),
          value: 'credit',
          groupValue: _paymentMethod,
          onChanged: (value) {
            setState(() {
              _paymentMethod = value!;
            });
          },
        ),
        RadioListTile<String>(
          title: const Text('Chuyển khoản'),
          subtitle: const Text('Chuyển khoản ngân hàng'),
          value: 'transfer',
          groupValue: _paymentMethod,
          onChanged: (value) {
            setState(() {
              _paymentMethod = value!;
            });
          },
        ),
        
        const SizedBox(height: 24),
        
        // Order summary
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Thông tin đơn hàng',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildSummaryRow('Khách hàng:', _nameController.text),
              _buildSummaryRow('Email:', _emailController.text),
              _buildSummaryRow('Điện thoại:', _phoneController.text),
              _buildSummaryRow('Địa chỉ:', _getFullAddress()),
              _buildSummaryRow('Thanh toán:', _getPaymentMethodText()),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Confirmation checkbox
        CheckboxListTile(
          title: const Text('Xác nhận đơn hàng'),
          subtitle: const Text('Tôi xác nhận thông tin đơn hàng là chính xác'),
          value: _confirmOrder,
          onChanged: (value) {
            setState(() {
              _confirmOrder = value!;
            });
          },
          controlAffinity: ListTileControlAffinity.leading,
        ),
        
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? '(Chưa nhập)' : value,
              style: TextStyle(
                color: value.isEmpty ? Colors.grey : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getFullAddress() {
    if (_selectedProvince == null || _selectedDistrict == null || _selectedWard == null) {
      return '';
    }
    final detail = _detailAddressController.text.trim();
    return '${detail.isNotEmpty ? '$detail, ' : ''}$_selectedWard, $_selectedDistrict, $_selectedProvince';
  }

  String _getPaymentMethodText() {
    switch (_paymentMethod) {
      case 'cash':
        return 'Tiền mặt';
      case 'credit':
        return 'Thẻ tín dụng';
      case 'transfer':
        return 'Chuyển khoản';
      default:
        return '';
    }
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _nameController.text.trim().isNotEmpty &&
               _emailController.text.trim().isNotEmpty &&
               _phoneController.text.trim().isNotEmpty;
      case 1:
        return _selectedProvince != null &&
               _selectedDistrict != null &&
               _selectedWard != null &&
               _detailAddressController.text.trim().isNotEmpty;
      case 2:
        return _confirmOrder;
      default:
        return false;
    }
  }

  void _goToNextStep() {
    if (_validateCurrentStep()) {
      if (_currentStep < 2) {
        setState(() {
          _currentStep++;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng điền đầy đủ thông tin')),
      );
    }
  }

  void _goToPreviousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  Future<void> _submitOrder() async {
    if (!_validateCurrentStep()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng xác nhận đơn hàng')),
      );
      return;
    }

    try {
      // In a real app, you would save the order to database
      // For now, just show success dialog
      
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 60,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Đặt hàng thành công!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Đơn hàng của ${_nameController.text} đã được ghi nhận.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Text(
                  'Hoàn thành',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e')),
      );
    }
  }
}
