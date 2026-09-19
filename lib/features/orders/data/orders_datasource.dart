import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:otlop_app/features/orders/data/models/delivery_method_model.dart';
import 'package:otlop_app/features/orders/data/models/order_model.dart';

class OrdersRemoteDataSource {
  final Dio dio = Dio();
  static const String baseUrl = 'https://talabat639.runasp.net/api';

  Options get _options => Options(
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization':
          'Bearer eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9naXZlbm5hbWUiOiJhbXIxMjMiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9lbWFpbGFkZHJlc3MiOiJhbXIxMjNAZ21haWwuY29tIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiJjNjJiODQzYi0wOWVlLTQxNWYtOWMwMC1kMmRkODViYmE1YmUiLCJleHAiOjE3ODk4NTY0NjksImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0OjcyNjQiLCJhdWQiOiJNeVNlY3VyZWRBUElVc2VycyJ9.XdhXAEmuScxTFDD45EMA675K4fYT5V64bLuNXUOYOXc',
    },
  );

  Future<List<OrderModel>> getOrders(int orderId) async {
    try {
      final response = await dio.get(
        '$baseUrl/Orders/$orderId',
        options: _options,
      );
      if (response.data is Map<String, dynamic>) {
        return [OrderModel.fromJson(response.data as Map<String, dynamic>)];
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
