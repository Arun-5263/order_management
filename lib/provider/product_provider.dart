// Assuming the ProductProvider class is something like this
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../model/product_model.dart';

class ProductProvider with ChangeNotifier {
  late Database _db;

  // Initialize database
  Future<void> initDb() async {
    _db = await openDatabase(
      'product_database.db',
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE products(id TEXT PRIMARY KEY, name TEXT, category TEXT, description TEXT, price REAL, offerPrice REAL, quantity INTEGER, images TEXT)',
        );
      },
    );
  }

  List<ProductModel> _products = [];
  List<ProductModel> get products => _products;

  // Method to add a product
  Future<void> addProduct(ProductModel product) async {
    await _db.insert(
      'products',
      {
        'id': product.id,
        'name': product.name,
        'category': product.category,
        'description': product.description,
        'price': product.price,
        'offerPrice': product.offerPrice,
        'quantity': product.quantity,
        'images': product.images.join(','),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    fetchProducts(); // Re-fetch products after adding
  }

  // Method to update an existing product
  Future<void> updateProduct(ProductModel product) async {
    await _db.update(
      'products',
      {
        'id': product.id,
        'name': product.name,
        'category': product.category,
        'description': product.description,
        'price': product.price,
        'offerPrice': product.offerPrice,
        'quantity': product.quantity,
        'images': product.images.join(','),
      },
      where: 'id = ?',
      whereArgs: [product.id],
    );
    fetchProducts(); // Re-fetch products after updating
  }

  // Method to fetch all products from the database
  Future<void> fetchProducts() async {
    final List<Map<String, dynamic>> productMaps = await _db.query('products');
    _products = List.generate(productMaps.length, (i) {
      return ProductModel(
        id: productMaps[i]['id'],
        name: productMaps[i]['name'],
        category: productMaps[i]['category'],
        description: productMaps[i]['description'],
        price: productMaps[i]['price'],
        offerPrice: productMaps[i]['offerPrice'],
        quantity: productMaps[i]['quantity'],
        images: List<String>.from(productMaps[i]['images'].split(',')),
      );
    });
    notifyListeners(); // Notify listeners after data is fetched
  }

  // Delete a product
  void deleteProduct(String productId) {
    _products.removeWhere((product) => product.id == productId);
    notifyListeners();
  }
}
