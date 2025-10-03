class User {
  final int? id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String password;
  final DateTime birthDate;
  final String gender;
  final DateTime createdAt;

  User({
    this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.password,
    required this.birthDate,
    required this.gender,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'password': password,
      'birthDate': birthDate.toIso8601String(),
      'gender': gender,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      fullName: map['fullName'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      password: map['password'],
      birthDate: DateTime.parse(map['birthDate']),
      gender: map['gender'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}

class Address {
  final int? id;
  final String recipientName;
  final String phoneNumber;
  final String province;
  final String district;
  final String ward;
  final String detailAddress;
  final double? latitude;
  final double? longitude;
  final DateTime createdAt;

  Address({
    this.id,
    required this.recipientName,
    required this.phoneNumber,
    required this.province,
    required this.district,
    required this.ward,
    required this.detailAddress,
    this.latitude,
    this.longitude,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'recipientName': recipientName,
      'phoneNumber': phoneNumber,
      'province': province,
      'district': district,
      'ward': ward,
      'detailAddress': detailAddress,
      'latitude': latitude,
      'longitude': longitude,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      id: map['id'],
      recipientName: map['recipientName'],
      phoneNumber: map['phoneNumber'],
      province: map['province'],
      district: map['district'],
      ward: map['ward'],
      detailAddress: map['detailAddress'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  String get fullAddress {
    return '$detailAddress, $ward, $district, $province';
  }
}

class Product {
  final int? id;
  final String name;
  final double price;
  final String? description;
  final String category;
  final bool isDiscounted;
  final DateTime createdAt;
  final List<String>? imagePaths;

  Product({
    this.id,
    required this.name,
    required this.price,
    this.description,
    required this.category,
    this.isDiscounted = false,
    required this.createdAt,
    this.imagePaths,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
      'category': category,
      'isDiscounted': isDiscounted ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      price: map['price'].toDouble(),
      description: map['description'],
      category: map['category'],
      isDiscounted: (map['isDiscounted'] ?? 0) == 1,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}

class ProductImage {
  final int? id;
  final int productId;
  final String imagePath;

  ProductImage({
    this.id,
    required this.productId,
    required this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'imagePath': imagePath,
    };
  }

  factory ProductImage.fromMap(Map<String, dynamic> map) {
    return ProductImage(
      id: map['id'],
      productId: map['productId'],
      imagePath: map['imagePath'],
    );
  }
}
