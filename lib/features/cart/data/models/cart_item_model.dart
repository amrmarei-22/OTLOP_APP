class CartItemModel {
  final int id;
  final String productName;
  final double price;
  final String pictureUrl;
  final String category;
  final String brand;
  int quantity;

  CartItemModel({
    required this.id,
    required this.productName,
    required this.price,
    required this.pictureUrl,
    required this.category,
    required this.brand,
    required this.quantity,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'] as int,
      productName: json['productName'] as String,
      price: (json['price'] as num).toDouble(),
      pictureUrl: json['pictureUrl'] as String,
      category: json['category'] as String,
      brand: json['brand'] as String,
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
    );
  }
}
