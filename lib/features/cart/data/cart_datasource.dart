import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:otlop_app/features/auth/data/auth_session.dart';
import 'package:otlop_app/features/cart/data/models/cart_item_model.dart';

class CartRemoteDataSource {
  final Dio dio = Dio();

  Options get _options => Options(
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': AuthSession.authorizationHeader,
    },
  );

  String? get _savedBaskedId {
    if(Hive.isBoxOpen('app_session')) {
      final box = Hive.box('app_session');
      return box.get('id') as String?;
    }
    return null;
  }

  Future<void> setSavedBasketId(String basketId) async {
    final box = await Hive.openBox('app_session');
    await box.put('id', basketId);
  }

  Future<List<CartItemModel>> getCartItems() async {
    try {
      final response = await dio.get(
        'https://talabat639.runasp.net/api/Basket',
        options: _options,
      );
      final data = response.data;
      final items = data is Map<String, dynamic> ? data['items'] : null;
      if (items is! List) {
        return [];
      }

      return items
          .map((item) => CartItemModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (error) {
      log('Error: ${error.response?.data}');
      final statusCode = error.response?.statusCode;
      if (statusCode == 400 || statusCode == 404) {
        return [];
      }
      throw Exception(_errorMessage(error));
    }
  }

  Future<void> addToCart(int id, int quantity) async {
    try {
      await dio.post(
        'https://talabat639.runasp.net/api/Basket',
        data: {'productId': id, 'quantity': quantity},
        options: _options,
      );
    } on DioException catch (error) {
      log('Error: ${error.response?.data}');
      throw Exception(_errorMessage(error));
    }
  }

  Future<void> removeFromCart(int id) async {
    try {
      await dio.delete(
        'https://talabat639.runasp.net/api/Basket',
        queryParameters: {'id': id},
        options: _options,
      );
    } on DioException catch (error) {
      log('Error: ${error.response?.data}');
      throw Exception(_errorMessage(error));
    }
  }

  String _errorMessage(DioException error) {
    final data = error.response?.data;
    if (data is Map && data['message'] != null) {
      return data['message'].toString();
    }
    return error.message ?? 'Cart request failed';
  }
}
