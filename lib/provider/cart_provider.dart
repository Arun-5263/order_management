import 'package:flutter/material.dart';
import '../model/product_model.dart';

class CartProvider with ChangeNotifier {
  Map<String, int> _cartItems = {}; // Map to store product IDs and their quantities

  // Get the total number of items in the cart
  int get cartItemCount {
    return _cartItems.values.fold(0, (previousValue, quantity) => previousValue + quantity);
  }

  // Get the quantity of a specific product in the cart
  int getCartItemQuantity(String productId) {
    return _cartItems[productId] ?? 0;
  }

  // Add product to the cart
  void addProductToCart(ProductModel product) {
    if (_cartItems.containsKey(product.id)) {
      _cartItems[product.id] = _cartItems[product.id]! + 1;
    } else {
      _cartItems[product.id] = 1;
    }
    notifyListeners();
  }

  // Calculate total cart value
  double get totalCartValue {
    return cartItems.fold(0, (previousValue, cartItem) {
      return previousValue + cartItem.subtotal;
    });
  }

  // Remove product from the cart
  void removeProductFromCart(ProductModel product) {
    if (_cartItems.containsKey(product.id)) {
      _cartItems.remove(product.id);
      notifyListeners();
    }
  }

  // Delete product (also removes it from the cart)
  void deleteProduct(ProductModel product) {
    _cartItems.remove(product.id);
    notifyListeners();
  }

  // Clear the cart
  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  // Getter to return cart items as a list of CartItem objects
  List<CartItem> get cartItems {
    return _cartItems.entries.map((entry) {
      // Find the product from its id (this assumes you have access to the products list somewhere)
      // If you have a list of products, you can find the product here.
      ProductModel product = ProductModel(
          id: entry.key,
          name: '',
          category: '',
          description: '',
          price: 0,
          offerPrice: 0,
          quantity: 0,
          images: []); // Replace with your actual product lookup
      return CartItem(product: product, quantity: entry.value);
    }).toList();
  }

  // Increase quantity of a product in the cart
  void increaseQuantity(ProductModel product) {
    if (_cartItems.containsKey(product.id)) {
      if (_cartItems[product.id]! < product.quantity) {
        _cartItems[product.id] = _cartItems[product.id]! + 1;
        notifyListeners();
      }
    }
  }

  // Decrease quantity of a product in the cart
  void decreaseQuantity(ProductModel product) {
    if (_cartItems.containsKey(product.id) && _cartItems[product.id]! > 1) {
      _cartItems[product.id] = _cartItems[product.id]! - 1;
      notifyListeners();
    }
  }
}

class CartItem {
  final ProductModel product;
  final int quantity;
  double get subtotal => product.offerPrice * quantity; // Calculate subtotal for this item
  CartItem({required this.product, required this.quantity});
}
