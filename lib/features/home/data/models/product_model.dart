class ProductModel {
  final int id;
  final String name, image, description, category, brand;
  final double price;
  ProductModel({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
    required this.category,
    required this.brand,
    required this.price,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      image: json['pictureUrl'],
      description: json['description'],
      category: json['category'],
      brand: json['brand'],
      price: (json['price'] as num).toDouble(),
    );
  }
}
