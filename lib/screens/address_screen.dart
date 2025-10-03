import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import 'address_list_screen.dart';
import 'map_picker_screen.dart';

class AddressScreen extends StatefulWidget {
  final Map<String, dynamic>? addressData;
  final bool isEdit;

  const AddressScreen({
    super.key,
    this.addressData,
    this.isEdit = false,
  });

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _detailAddressController = TextEditingController();

  final DatabaseHelper _dbHelper = DatabaseHelper();

  String? _selectedProvince;
  String? _selectedDistrict;
  String? _selectedWard;
  double? _latitude;
  double? _longitude;

  // Sample data - in real app, this would come from API
  final Map<String, List<String>> _locations = {
    'Hà Nội': ['Ba Đình', 'Hoàn Kiếm', 'Tây Hồ', 'Long Biên', 'Cầu Giấy', 'Đống Đa'],
    'TP.HCM': ['Quận 1', 'Quận 2', 'Quận 3', 'Quận 4', 'Quận 5', 'Quận 7'],
    'Đà Nẵng': ['Hải Châu', 'Thanh Khê', 'Sơn Trà', 'Ngũ Hành Sơn', 'Liên Chiểu'],
  };

  final Map<String, List<String>> _wards = {
    'Ba Đình': ['Phường Phúc Xá', 'Phường Trúc Bạch', 'Phường Vĩnh Phúc'],
    'Hoàn Kiếm': ['Phường Hàng Bạc', 'Phường Hàng Bài', 'Phường Hàng Trống'],
    'Quận 1': ['Phường Bến Nghé', 'Phường Bến Thành', 'Phường Cầu Kho'],
    'Quận 2': ['Phường An Phú', 'Phường Bình An', 'Phường Bình Trưng Đông'],
    'Hải Châu': ['Phường Hòa Thuận Tây', 'Phường Hòa Thuận Đông', 'Phường Nam Dương'],
  };

  @override
  void initState() {
    super.initState();
    if (widget.isEdit && widget.addressData != null) {
      _loadExistingData();
    }
  }

  void _loadExistingData() {
    final data = widget.addressData!;
    _nameController.text = data['recipientName'] ?? '';
    _phoneController.text = data['phoneNumber'] ?? '';
    _detailAddressController.text = data['detailAddress'] ?? '';
    _selectedProvince = data['province'];
    _selectedDistrict = data['district'];
    _selectedWard = data['ward'];
    _latitude = data['latitude'];
    _longitude = data['longitude'];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _detailAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? 'Chỉnh Sửa Địa Chỉ' : 'Thêm Địa Chỉ Mới'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddressListScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Recipient Name
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Tên Người Nhận *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Vui lòng nhập tên người nhận';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Phone Number
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Số Điện Thoại *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Vui lòng nhập số điện thoại';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Province
                DropdownButtonFormField<String>(
                  value: _selectedProvince,
                  decoration: const InputDecoration(
                    labelText: 'Tỉnh / Thành Phố *',
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
                  validator: (value) {
                    if (value == null) {
                      return 'Vui lòng chọn tỉnh/thành phố';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // District
                DropdownButtonFormField<String>(
                  value: _selectedDistrict,
                  decoration: const InputDecoration(
                    labelText: 'Quận / Huyện *',
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
                  validator: (value) {
                    if (value == null) {
                      return 'Vui lòng chọn quận/huyện';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Ward
                DropdownButtonFormField<String>(
                  value: _selectedWard,
                  decoration: const InputDecoration(
                    labelText: 'Phường / Xã *',
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
                  validator: (value) {
                    if (value == null) {
                      return 'Vui lòng chọn phường/xã';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Detail Address
                TextFormField(
                  controller: _detailAddressController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Địa Chỉ Chi Tiết *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.home),
                    hintText: 'Số nhà, tên đường...',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Vui lòng nhập địa chỉ chi tiết';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Map Picker
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.map),
                    title: Text(
                      _latitude != null && _longitude != null
                          ? 'Vị trí đã chọn: ${_latitude!.toStringAsFixed(6)}, ${_longitude!.toStringAsFixed(6)}'
                          : 'Chọn vị trí trên bản đồ (tùy chọn)',
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MapPickerScreen(
                            initialLatitude: _latitude,
                            initialLongitude: _longitude,
                          ),
                        ),
                      );
                      
                      if (result != null) {
                        setState(() {
                          _latitude = result['latitude'];
                          _longitude = result['longitude'];
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // Save Button
                ElevatedButton(
                  onPressed: _saveAddress,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    widget.isEdit ? 'Cập Nhật' : 'Lưu Địa Chỉ',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveAddress() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      final addressData = {
        'recipientName': _nameController.text.trim(),
        'phoneNumber': _phoneController.text.trim(),
        'province': _selectedProvince!,
        'district': _selectedDistrict!,
        'ward': _selectedWard!,
        'detailAddress': _detailAddressController.text.trim(),
        'latitude': _latitude,
        'longitude': _longitude,
        'createdAt': DateTime.now().toIso8601String(),
      };

      if (widget.isEdit && widget.addressData != null) {
        await _dbHelper.updateAddress(widget.addressData!['id'], addressData);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Địa chỉ đã được cập nhật')),
        );
      } else {
        await _dbHelper.insertAddress(addressData);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Địa chỉ đã được lưu thành công')),
        );
      }

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e')),
      );
    }
  }
}
