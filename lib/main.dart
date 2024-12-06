import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider/product_provider.dart';
import 'provider/cart_provider.dart'; // Import CartProvider
import 'screens/add_product_screen.dart';
import 'screens/home_screen.dart';
import 'screens/product_list_screen.dart'; // Import the provider

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize both ProductProvider and CartProvider
  final productProvider = ProductProvider();
  final cartProvider = CartProvider();

  // Initialize the product database
  await productProvider.initDb();

  runApp(
    MultiProvider(
      // Use MultiProvider to provide multiple providers
      providers: [
        ChangeNotifierProvider(create: (context) => productProvider),
        ChangeNotifierProvider(create: (context) => cartProvider), // Add CartProvider here
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Product App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AddEditProductScreen(),
    );
  }
}
