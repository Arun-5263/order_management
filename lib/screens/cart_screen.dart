import 'package:flutter/material.dart';
import 'package:order_management_application/screens/product_details_scree.dart';
import 'package:provider/provider.dart';
import '../provider/cart_provider.dart';
import '../model/product_model.dart'; // Import your ProductModel

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.cartItems;

    double total = 0;

    // Calculate the total cart value
    cartItems.forEach((item) {
      total += item.subtotal; // Use the calculated subtotal from CartItem
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: cartItems.isEmpty
          ? Center(child: Text('Your cart is empty'))
          : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final cartItem = cartItems[index];
                final product = cartItem.product;
                final subtotal = cartItem.subtotal;

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    title: Text(product.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Price: ₹${product.offerPrice.toStringAsFixed(2)}'),
                        Row(
                          children: [
                            Text('Quantity: '),
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () {
                                if (cartItem.quantity > 1) {
                                  cartProvider.decreaseQuantity(product);
                                }
                              },
                            ),
                            Text('${cartItem.quantity}'),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                if (cartItem.quantity < product.quantity) {
                                  cartProvider.increaseQuantity(product);
                                }
                              },
                            ),
                          ],
                        ),
                        Text('Subtotal: ₹${subtotal.toStringAsFixed(2)}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        cartProvider.removeProductFromCart(product);
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailsScreen(product: product),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            // Proceed to checkout or handle cart actions here
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Total Cart Value'),
                  content: Text('Total: ₹${total.toStringAsFixed(2)}'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Close'),
                    ),
                  ],
                );
              },
            );
          },
          child: Text('Checkout (₹${total.toStringAsFixed(2)})'),
        ),
      ),
    );
  }
}
