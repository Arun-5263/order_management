import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../global_function/global_function.dart';
import '../provider/cart_provider.dart';
import '../provider/product_provider.dart';
import '../model/product_model.dart';
import 'add_product_screen.dart';
import 'cart_screen.dart';
import 'product_details_scree.dart'; // Import CartScreen

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final numberFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹');

    // Filter products based on the search query
    final filteredProducts = productProvider.products.where((product) {
      return product.name.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
        actions: [
          // Cart icon with item count badge
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  // Navigate to Cart Screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartScreen(),
                    ),
                  );
                },
              ),
              if (cartProvider.cartItemCount > 0)
                Positioned(
                  right: 0,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.red,
                    child: Text(
                      cartProvider.cartItemCount.toString(),
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search Products',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
            ),
          ),

          // Product List
          Expanded(
            child: filteredProducts.isEmpty
                ? Center(child: Text('No products available.'))
                : ListView.builder(
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];

                      return Card(
                        child: ListTile(
                          contentPadding: EdgeInsets.all(10.0),
                          title: Text(product.name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Display product price in rupees
                              Text(
                                'Price: ${numberFormat.format(product.price)}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              // Display product images
                              SizedBox(height: 5),
                              product.images.isNotEmpty
                                  ? SizedBox(
                                      height: 50, // Thumbnail height
                                      child: GestureDetector(
                                        onTap: () {
                                          Twl.forceNavigateTo(
                                              context,
                                              ProductDetailsScreen(
                                                product: product,
                                              ));
                                        },
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: product.images.length,
                                          itemBuilder: (context, imageIndex) {
                                            return Padding(
                                              padding: const EdgeInsets.only(right: 8.0),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(8.0),
                                                child: Image.file(
                                                  File(product.images[imageIndex]),
                                                  width: 50.0,
                                                  height: 50.0,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    )
                                  : Text('No images available'),
                            ],
                          ),
                          trailing: Column(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Edit button
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
                              // SizedBox(
                              //   height: 5,
                              // ),
                              // // Delete button with confirmation dialog
                              // IconButton(
                              //   icon: Icon(Icons.delete),
                              //   onPressed: () {
                              //     _showDeleteConfirmationDialog(context, product, productProvider);
                              //   },
                              // ),
                            ],
                          ),
                          // Add to Cart Button
                          onTap: () {
                            // Add to cart functionality
                            if (cartProvider.getCartItemQuantity(product.id) < product.quantity) {
                              cartProvider.addProductToCart(product);
                            }
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
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
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
