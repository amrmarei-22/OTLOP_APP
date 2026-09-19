class DeliveryMethodModel {
  final int id;
  final String name;
  final double cost;

  const DeliveryMethodModel({
    required this.id,
    required this.name,
    required this.cost,
  });

  factory DeliveryMethodModel.fromJson(Map<String, dynamic> json) {
    return DeliveryMethodModel(
      id: (json['id'] as num).toInt(),
      name: (json['shortName'] ?? 'Delivery').toString(),
      cost: (json['cost'] as num?)?.toDouble() ?? 0,
    );
  }
}
