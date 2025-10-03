import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'btth02.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Users table for registration
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        fullName TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        phoneNumber TEXT NOT NULL,
        password TEXT NOT NULL,
        birthDate TEXT NOT NULL,
        gender TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');

    // Addresses table
    await db.execute('''
      CREATE TABLE addresses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        recipientName TEXT NOT NULL,
        phoneNumber TEXT NOT NULL,
        province TEXT NOT NULL,
        district TEXT NOT NULL,
        ward TEXT NOT NULL,
        detailAddress TEXT NOT NULL,
        latitude REAL,
        longitude REAL,
        createdAt TEXT NOT NULL
      )
    ''');

    // Products table
    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        price REAL NOT NULL,
        description TEXT,
        category TEXT NOT NULL,
        isDiscounted INTEGER NOT NULL DEFAULT 0,
        createdAt TEXT NOT NULL
      )
    ''');

    // Product images table
    await db.execute('''
      CREATE TABLE product_images (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        productId INTEGER NOT NULL,
        imagePath TEXT NOT NULL,
        FOREIGN KEY (productId) REFERENCES products (id) ON DELETE CASCADE
      )
    ''');
  }

  // User operations
  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.insert('users', user);
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }

  // Address operations
  Future<int> insertAddress(Map<String, dynamic> address) async {
    final db = await database;
    return await db.insert('addresses', address);
  }

  Future<List<Map<String, dynamic>>> getAllAddresses() async {
    final db = await database;
    return await db.query('addresses', orderBy: 'createdAt DESC');
  }

  Future<int> updateAddress(int id, Map<String, dynamic> address) async {
    final db = await database;
    return await db.update(
      'addresses',
      address,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAddress(int id) async {
    final db = await database;
    return await db.delete(
      'addresses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Product operations
  Future<int> insertProduct(Map<String, dynamic> product) async {
    final db = await database;
    return await db.insert('products', product);
  }

  Future<List<Map<String, dynamic>>> getAllProducts() async {
    final db = await database;
    return await db.query('products', orderBy: 'createdAt DESC');
  }

  Future<int> updateProduct(int id, Map<String, dynamic> product) async {
    final db = await database;
    return await db.update(
      'products',
      product,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteProduct(int id) async {
    final db = await database;
    // Delete associated images first
    await db.delete(
      'product_images',
      where: 'productId = ?',
      whereArgs: [id],
    );
    // Delete product
    return await db.delete(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Product image operations
  Future<int> insertProductImage(int productId, String imagePath) async {
    final db = await database;
    return await db.insert('product_images', {
      'productId': productId,
      'imagePath': imagePath,
    });
  }

  Future<List<Map<String, dynamic>>> getProductImages(int productId) async {
    final db = await database;
    return await db.query(
      'product_images',
      where: 'productId = ?',
      whereArgs: [productId],
    );
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
