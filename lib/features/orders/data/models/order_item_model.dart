class OrderItemModel {
  final String pictureUrl;
  final int quantity;

  const OrderItemModel({required this.pictureUrl, required this.quantity});

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      pictureUrl: (json['pictureUrl'] ?? '').toString(),
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
    );
  }
}
