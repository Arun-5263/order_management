import 'dart:io';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart'; // Add this dependency in pubspec.yaml
import 'package:provider/provider.dart';
import '../global_function/global_function.dart';
import '../provider/cart_provider.dart';
import '../provider/product_provider.dart';
import '../model/product_model.dart';
import 'add_product_screen.dart';
import 'cart_screen.dart';
import 'product_list_screen.dart';

class ProductDetailsScreen extends StatelessWidget {
  final ProductModel product;

  ProductDetailsScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return WillPopScope(
      onWillPop: () {
        return Twl.forceNavigateTo(context, ProductListScreen());
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Product Details'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Carousel of images
                CarouselSlider(
                  items: product.images.map((image) {
                    return Image.file(
                      File(image),
                      fit: BoxFit.cover,
                      width: double.infinity,
                    );
                  }).toList(),
                  options: CarouselOptions(
                    height: 300,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    viewportFraction: 1.0,
                  ),
                ),

                SizedBox(height: 20),

                // Product Name
                Text(
                  product.name,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),

                // Price Section
                Row(
                  children: [
                    Text(
                      '₹${product.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 18,
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(width: 10),
                    // Text(
                    //   '₹${(product.price - product.discount).toStringAsFixed(2)}',
                    //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                    // ),
                  ],
                ),
                SizedBox(height: 10),

                // Available Quantity
                Text(
                  'Available Quantity: ${product.quantity}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),

                // Category
                Text(
                  'Category: ${product.category}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),

                // Product Description
                Text(
                  'Description: ${product.description}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),

                // Edit and Delete Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddEditProductScreen(product: product),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _showDeleteConfirmationDialog(context, product, Provider.of<ProductProvider>(context, listen: false));
                      },
                    ),
                  ],
                ),

                SizedBox(height: 20),

                // Add to Cart Button
                ElevatedButton(
                  onPressed: () {
                    // Safely check if the quantity in the cart is less than the available quantity
                    if (cartProvider.getCartItemQuantity(product.id) < product.quantity) {
                      cartProvider.addProductToCart(product); // Add product to the cart
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${product.name} added to cart')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Cannot add more items than available quantity')),
                      );
                    }
                  },
                  child: Text('Add to Cart'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Show confirmation dialog for product deletion
  Future<void> _showDeleteConfirmationDialog(
    BuildContext context,
    ProductModel product,
    ProductProvider productProvider,
  ) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Product'),
          content: Text('Are you sure you want to delete this product?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                productProvider.deleteProduct(product.id); // Delete the product
                Navigator.of(context).pop(); // Close the dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Product deleted successfully')),
                );
                Navigator.of(context).pop(); // Go back to the previous screen
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
