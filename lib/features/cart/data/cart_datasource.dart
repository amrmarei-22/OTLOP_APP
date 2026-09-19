import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:otlop_app/features/cart/data/models/cart_item_model.dart';

class CartRemoteDataSource {
  final Dio dio = Dio();

  Future<List<CartItemModel>> getCartItems() async {
    try {
      final Response response = await dio.get(
        "https://talabat639.runasp.net/api/Basket",
        options: Options(
          headers: {
            "Authorization":
                "Bearer eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9naXZlbm5hbWUiOiJhbXIxMjMiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9lbWFpbGFkZHJlc3MiOiJhbXIxMjNAZ21haWwuY29tIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiJjNjJiODQzYi0wOWVlLTQxNWYtOWMwMC1kMmRkODViYmE1YmUiLCJleHAiOjE3ODk4NTY0NjksImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0OjcyNjQiLCJhdWQiOiJNeVNlY3VyZWRBUElVc2VycyJ9.XdhXAEmuScxTFDD45EMA675K4fYT5V64bLuNXUOYOXc",
          },
        ),
      );
      return (response.data['items'] as List)
          .map((item) => CartItemModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      log("Error: ${e.response!.data}");
      throw Exception(e.response?.data['message']);
    }
  }

  Future<void> addToCart(int id, int quantity) async {
  
    try {
      final Response response = await dio.post(
        "https://talabat639.runasp.net/api/Basket",
        data: {"productId": id, "quantity": quantity},
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization":
                "Bearer eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9naXZlbm5hbWUiOiJhbXIxMjMiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9lbWFpbGFkZHJlc3MiOiJhbXIxMjNAZ21haWwuY29tIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiJjNjJiODQzYi0wOWVlLTQxNWYtOWMwMC1kMmRkODViYmE1YmUiLCJleHAiOjE3ODk4NTY0NjksImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0OjcyNjQiLCJhdWQiOiJNeVNlY3VyZWRBUElVc2VycyJ9.XdhXAEmuScxTFDD45EMA675K4fYT5V64bLuNXUOYOXc",
          },
        ),
      );
    } on DioException catch (e) {
      log("Error: ${e.response!.data}");
      throw Exception(e.response?.data['message']);
    }
  }

  Future<void> removeFromCart(int id) async {
    try {
      final Response response = await dio.delete(
        "https://talabat639.runasp.net/api/Basket",
        options: Options(
          headers: {
            "Authorization":
                "Bearer eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9naXZlbm5hbWUiOiJhbXIxMjMiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9lbWFpbGFkZHJlc3MiOiJhbXIxMjNAZ21haWwuY29tIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiJjNjJiODQzYi0wOWVlLTQxNWYtOWMwMC1kMmRkODViYmE1YmUiLCJleHAiOjE3ODk4NTY0NjksImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0OjcyNjQiLCJhdWQiOiJNeVNlY3VyZWRBUElVc2VycyJ9.XdhXAEmuScxTFDD45EMA675K4fYT5V64bLuNXUOYOXc",
          },
        ),
      );
    } on DioException catch (e) {
      log("Error: ${e.response!.data}");
      throw Exception(e.response?.data['message']);
    }
  }
}
