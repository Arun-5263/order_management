class ProductModel {
  final String id;
  final String name;
  final String category;
  final String description;
  final double price;
  final double offerPrice;
  final dynamic quantity;
  final List<String> images; // List of image paths

  ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    required this.offerPrice,
    required this.quantity,
    required this.images,
  });

  // To map from database to Product model
  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'],
      name: map['name'],
      category: map['category'],
      description: map['description'],
      price: (map['price'] as num).toDouble(),
      offerPrice: (map['offerPrice'] as num).toDouble(),
      quantity: map['quantity'], // Ensure proper data type in DB
      images: List<String>.from(map['images']), // Expect array support
    );
  }
  // To map Product model to database format
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'description': description,
      'price': price,
      'offerPrice': offerPrice,
      'quantity': quantity,
      'images': images, // Store as a list if the database supports arrays
    };
  }
}
