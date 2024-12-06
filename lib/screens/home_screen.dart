// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:order_management_application/provider/product_provider.dart';
// import 'package:order_management_application/screens/add_product_screen.dart';
// import 'package:order_management_application/screens/product_list_screen.dart';
// import 'package:provider/provider.dart';

// import '../global_function/global_function.dart';
// import '../model/product_model.dart';

// class HomeScreen extends StatefulWidget {
//   final Product? product;

//   // Constructor to accept a product for editing
//   const HomeScreen({super.key, this.product});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _categoryController = TextEditingController();
//   final _priceController = TextEditingController();
//   final _offerPriceController = TextEditingController();
//   final _quantityController = TextEditingController();
//   final _descriptionController = TextEditingController();
//   List<File> _images = [];

//   @override
//   void initState() {
//     super.initState();
//     if (widget.product != null) {
//       // Populate fields if editing an existing product
//       _nameController.text = widget.product!.name;
//       _categoryController.text = widget.product!.category;
//       _priceController.text = widget.product!.price.toString();
//       _offerPriceController.text = widget.product!.offerPrice.toString();
//       _quantityController.text = widget.product!.quantity.toString();
//       _descriptionController.text = widget.product!.description;
//       // Add logic to load images if required
//     }
//   }

//   void _saveProduct() {
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }

//     // Check if widget.product is null
//     if (widget.product == null) {
//       // Handle the case where there's no existing product (new product)
//       final newProduct = Product(
//         id: DateTime.now().toString(), // Generate a new ID for the new product
//         name: _nameController.text,
//         category: _categoryController.text,
//         description: _descriptionController.text,
//         price: double.parse(_priceController.text),
//         offerPrice: double.parse(_offerPriceController.text),
//         quantity: int.parse(_quantityController.text),
//         images: _images.map((image) => image.path).toList(),
//       );
//       // Add the new product
//       Provider.of<ProductProvider>(context, listen: false).addProduct(newProduct);
//     } else {
//       // If there's an existing product, update it
//       final updatedProduct = Product(
//         id: widget.product!.id, // Keep the same ID for updates
//         name: _nameController.text,
//         category: _categoryController.text,
//         description: _descriptionController.text,
//         price: double.parse(_priceController.text),
//         offerPrice: double.parse(_offerPriceController.text),
//         quantity: int.parse(_quantityController.text),
//         images: _images.map((image) => image.path).toList(),
//       );
//       // Update the product
//       Provider.of<ProductProvider>(context, listen: false).updateProduct(updatedProduct);
//     }

//     // Navigate back to Product List screen
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => ProductListScreen()),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Product Management System'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 Twl.forceNavigateTo(context, ProductListScreen());
//               },
//               child: const Text('View Products'),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 Twl.forceNavigateTo(context, AddEditProductScreen());
//               },
//               child: const Text('Add New Product'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
