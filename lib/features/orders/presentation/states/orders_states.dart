import 'package:otlop_app/features/orders/data/models/order_model.dart';

sealed class OrdersState {}

class OrdersInitialState extends OrdersState {}

class OrdersLoadingState extends OrdersState {}

class OrdersSuccessState extends OrdersState {
  final List<OrderModel> orders;
  OrdersSuccessState({required this.orders});
}

class OrdersFailureState extends OrdersState {
  final String error;
  OrdersFailureState({required this.error});
}
