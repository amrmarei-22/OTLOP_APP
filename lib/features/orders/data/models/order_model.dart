import 'package:otlop_app/features/orders/data/models/order_item_model.dart';

class OrderModel {
  final int id;
  final String status;
  final DateTime orderDate;
  final List<OrderItemModel> items;
  final String deliveryMethod;
  final double total;

  const OrderModel({
    required this.id,
    required this.status,
    required this.orderDate,
    required this.items,
    required this.deliveryMethod,
    required this.total,
  });

  OrderModel copyWith({double? total}) {
    return OrderModel(
      id: id,
      status: status,
      orderDate: orderDate,
      items: items,
      deliveryMethod: deliveryMethod,
      total: total ?? this.total,
    );
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      status: (json['status'] ?? 'Pending').toString(),
      orderDate:
          DateTime.tryParse(json['orderDate'].toString()) ?? DateTime.now(),
      items: (json['items'] as List? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(OrderItemModel.fromJson)
          .toList(),
      deliveryMethod: (json['deliveryMethod'] ?? 'Delivery').toString(),
      total: (json['total'] as num?)?.toDouble() ?? 0,
    );
  }
}
