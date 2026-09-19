import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otlop_app/features/orders/data/models/delivery_method_model.dart';
import 'package:otlop_app/features/orders/data/models/order_model.dart';
import 'package:otlop_app/features/orders/data/orders_datasource.dart';
import 'package:otlop_app/features/orders/presentation/states/orders_states.dart';

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit() : super(OrdersInitialState());
  final OrdersRemoteDataSource ordersRemoteDataSource =
      OrdersRemoteDataSource();

  Future<void> getOrders(int orderId) async {
    emit(OrdersLoadingState());
    try {
      emit(
        OrdersSuccessState(
          orders: await ordersRemoteDataSource.getOrders(orderId),
        ),
      );
    } catch (error) {
      log('Orders error: $error');
      emit(OrdersFailureState(error: error.toString()));
    }
  }

  Future<List<DeliveryMethodModel>> getDeliveryMethods() async {
    return ordersRemoteDataSource.getDeliveryMethods();
  }

  Future<OrderModel> postOrder({required int deliveryMethodId}) async {
    return ordersRemoteDataSource.postOrder(deliveryMethodId: deliveryMethodId);
  }

  Future<int?> postAndGetOrder() async {
    emit(OrdersLoadingState());
    try {
      final methods = await getDeliveryMethods();
      if (methods.isEmpty) {
        throw Exception('No delivery methods available');
      }
      final createdOrder = await postOrder(deliveryMethodId: methods.first.id);
      final order = await ordersRemoteDataSource.getOrder(createdOrder.id);
      emit(OrdersSuccessState(orders: [order]));
      return order.id;
    } catch (error) {
      log('Post and get order error: $error');
      emit(OrdersFailureState(error: error.toString()));
      return null;
    }
  }
}
