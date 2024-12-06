import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/product_model.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../provider/product_provider.dart';
import 'product_list_screen.dart';

class AddEditProductScreen extends StatefulWidget {
  final ProductModel? product;

  const AddEditProductScreen({this.product});

  @override
  _AddEditProductScreenState createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _priceController = TextEditingController();
  final _offerPriceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _descriptionController = TextEditingController();
  List<File> _images = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _nameController.text = widget.product!.name;
      _categoryController.text = widget.product!.category;
      _priceController.text = widget.product!.price.toString();
      _offerPriceController.text = widget.product!.offerPrice.toString();
      _quantityController.text = widget.product!.quantity.toString();
      _descriptionController.text = widget.product!.description;
      _images = widget.product!.images.map((path) => File(path)).toList();
    }
  }

  // Function to pick image either from gallery or camera
  void _pickImage() async {
    final pickedFile = await showDialog<XFile?>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Image Source'),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context, await _picker.pickImage(source: ImageSource.camera));
            },
            child: const Text('Camera'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context, await _picker.pickImage(source: ImageSource.gallery));
            },
            child: const Text('Gallery'),
          ),
        ],
      ),
    );

    if (pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path));
      });
    }
  }

  // Save or update the product
  void _saveProduct() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Check if widget.product is null
    if (widget.product == null) {
      // Handle the case where there's no existing product (new product)
      final newProduct = ProductModel(
        id: DateTime.now().toString(), // Generate a new ID for the new product
        name: _nameController.text,
        category: _categoryController.text,
        description: _descriptionController.text,
        price: double.parse(_priceController.text),
        offerPrice: double.parse(_offerPriceController.text),
        quantity: int.parse(_quantityController.text),
        images: _images.map((image) => image.path).toList(),
      );
      // Add the new product
      Provider.of<ProductProvider>(context, listen: false).addProduct(newProduct);
    } else {
      // If there's an existing product, update it
      final updatedProduct = ProductModel(
        id: widget.product!.id, // Keep the same ID for updates
        name: _nameController.text,
        category: _categoryController.text,
        description: _descriptionController.text,
        price: double.parse(_priceController.text),
        offerPrice: double.parse(_offerPriceController.text),
        quantity: int.parse(_quantityController.text),
        images: _images.map((image) => image.path).toList(),
      );
      // Update the product
      Provider.of<ProductProvider>(context, listen: false).updateProduct(updatedProduct);
    }

    // Navigate back to Product List screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ProductListScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Add Product' : 'Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product name.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter category.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Price'),
                validator: (value) {
                  if (value == null || value.isEmpty || double.tryParse(value) == null) {
                    return 'Please enter valid price.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _offerPriceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Offer Price'),
                validator: (value) {
                  if (value == null || value.isEmpty || double.tryParse(value) == null) {
                    return 'Please enter valid offer price.';
                  }
                  if (double.parse(value) > double.parse(_priceController.text)) {
                    return 'Offer price cannot be higher than price.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Quantity'),
                validator: (value) {
                  if (value == null || value.isEmpty || int.tryParse(value) == null) {
                    return 'Please enter valid quantity.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Pick Images'),
              ),
              const SizedBox(height: 10),
              // Display picked images as thumbnails
              Wrap(
                spacing: 8.0,
                children: _images.map((image) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.file(
                      image,
                      width: 100.0,
                      height: 100.0,
                      fit: BoxFit.cover,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _saveProduct,
                child: Text(widget.product == null ? 'Add Product' : 'Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
