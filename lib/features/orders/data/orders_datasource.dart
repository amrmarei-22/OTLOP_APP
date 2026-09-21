import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:otlop_app/features/auth/data/auth_session.dart';
import 'package:otlop_app/features/orders/data/models/delivery_method_model.dart';
import 'package:otlop_app/features/orders/data/models/order_model.dart';

class OrdersRemoteDataSource {
  final Dio dio = Dio();
  static const String baseUrl = 'https://talabat639.runasp.net/api';

  Options get _options => Options(
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': AuthSession.authorizationHeader,
    },
  );

  Future<List<OrderModel>> getOrders() async {
    try {
      final response = await dio.get('$baseUrl/Orders', options: _options);
      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        final orders = data['orders'];
        if (orders is List) {
          return orders
              .whereType<Map<String, dynamic>>()
              .map(OrderModel.fromJson)
              .toList();
        }
        if (orders == null || data.isEmpty) return [];
        return [OrderModel.fromJson(data)];
      } else if (response.data is List) {
        return (response.data as List)
            .whereType<Map<String, dynamic>>()
            .map(OrderModel.fromJson)
            .toList();
      } else {
        throw Exception('Unexpected response format: ${response.data}');
      }
    } on DioException catch (error) {
      log('Orders error: ${error.response?.data ?? error.message}');
      if (error.response?.statusCode == 404 ||
          error.response?.statusCode == 500) {
        return [];
      }
      throw Exception(_message(error));
    }
  }

  Future<List<DeliveryMethodModel>> getDeliveryMethods() async {
    try {
      final response = await dio.get(
        '$baseUrl/Orders/DeliverMethods',
        options: _options,
      );
      return (response.data as List)
          .whereType<Map<String, dynamic>>()
          .map(DeliveryMethodModel.fromJson)
          .toList();
    } on DioException catch (error) {
      log('Delivery methods error: ${error.response?.data ?? error.message}');
      throw Exception(_message(error));
    }
  }

  Future<OrderModel> postOrder({required int deliveryMethodId}) async {
    try {
      final response = await dio.post(
        '$baseUrl/Orders',
        data: {
          'deliverMethodID': deliveryMethodId,
          'shippingAddress': {
            'city': 'string',
            'country': 'string',
            'firstName': 'string',
            'lastName': 'string',
            'street': 'string',
          },
        },
        options: _options,
      );
      return OrderModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (error) {
      log('Post order error: ${error.response?.data ?? error.message}');
      throw Exception(_message(error));
    }
  }

  Future<OrderModel> getOrder(int orderId) async {
    try {
      final response = await dio.get(
        '$baseUrl/Orders/$orderId',
        options: _options,
      );
      return OrderModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (error) {
      log('Get order error: ${error.response?.data ?? error.message}');
      throw Exception(_message(error));
    }
  }

  String _message(DioException error) {
    final data = error.response?.data;
    if (data is Map && data['message'] != null) {
      return data['message'].toString();
    }
    return error.message ?? 'Request failed';
  }
}
