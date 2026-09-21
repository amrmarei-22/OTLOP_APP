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
  List<OrderModel> orders = [];

  Future<void> getOrders() async {
    emit(OrdersLoadingState());
    try {
      final remoteOrders = await ordersRemoteDataSource.getOrders();
      final ordersById = <int, OrderModel>{
        for (final order in orders) order.id: order,
      };
      for (final order in remoteOrders) {
        ordersById[order.id] = order;
      }
      orders = ordersById.values.toList()
        ..sort((first, second) => second.orderDate.compareTo(first.orderDate));
      emit(OrdersSuccessState(orders: orders));
      if (orders.isEmpty) {
        log('Orders are empty');
      } else {
        log('Orders fetched successfully: ${orders.length} orders');
      }
    }  
    catch (error) {
      
      emit(OrdersFailureState(error: error.toString()));
    

  
    }
  }

  Future<List<DeliveryMethodModel>> getDeliveryMethods() async {
    return ordersRemoteDataSource.getDeliveryMethods();
  }

  Future<OrderModel> postOrder({required int deliveryMethodId}) async {
    return ordersRemoteDataSource.postOrder(deliveryMethodId: deliveryMethodId);
  }

  Future<int?> postAndGetOrder({double? total}) async {
    emit(OrdersLoadingState());
    try {
      final methods = await getDeliveryMethods();
      if (methods.isEmpty) {
        throw Exception('No delivery methods available');
      }
      final createdOrder = await postOrder(deliveryMethodId: methods.first.id);
      final order = await ordersRemoteDataSource.getOrder(createdOrder.id);
      final orderWithTotal = total == null
          ? order
          : order.copyWith(total: total);
      orders = [orderWithTotal, ...orders.where((item) => item.id != order.id)];
      emit(OrdersSuccessState(orders: orders));
      return orderWithTotal.id;
    } catch (error) {
      log('Post and get order error: $error');
      emit(OrdersFailureState(error: error.toString()));
      return null;
    }
  }
}
