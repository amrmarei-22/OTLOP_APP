// features/home/data/data_source/home_remote_data_source.dart
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:otlop_app/features/home/data/models/product_model.dart';

class HomeRemoteDataSource {
  final Dio dio = Dio();
  List<ProductModel> products = [];
  Future<List<ProductModel>> getProducts({int? brandId, int? categoryId}) async {
    try {
      final Response response = await dio.get(
        "https://talabat639.runasp.net/api/Products",
        queryParameters: {
          'PageSize': 20,
          'PageIndex': 1,
          'brandId': brandId,
          'categoryId': categoryId,
        },
      );
      for (var product in response.data['data']) {
        final productModel = ProductModel.fromJson(product);
        products.add(productModel);
      }
      return products;
    } on DioException catch (e) {
      log("Error: ${e.response?.data['message']}");
      throw Exception(e.response?.data['message']);
    }
  }

  Future<List> getCategories() async {
    try {
      final Response response = await dio.get(
        "https://talabat639.runasp.net/api/Products/categories",
      );
      return response.data;
    
    } on DioException catch (e) {
      log("Error: ${e.response?.data}");
      throw Exception(e.response?.data['message']);
    }
  }

  


Future<void> addToCart(int productId) async {
    try {
      final Response response = await dio.post(
        "https://talabat639.runasp.net/api/Basket",
        data: {"productId": productId, "quantity": 1},
        options: Options(
          headers: {
            "Authorization":
                "Bearer eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9naXZlbm5hbWUiOiJhbXIxNTUiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9lbWFpbGFkZHJlc3MiOiJhbXIxNTVAZ21haWwuY29tIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiI5ODFiOTA4NS1hYmQ5LTQ3NjUtOTc3ZC1iN2ZiMjY1YjhmYjgiLCJleHAiOjE3ODg1NTI1ODUsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0OjcyNjQiLCJhdWQiOiJNeVNlY3VyZWRBUElVc2VycyJ9.vZGeCAkfNoF-TEe6uTTGHKzDB_mgBTkZAE_bdja6irE",
          },
        ),
      );
      return response.data;
    } on DioException catch (e) {
      log("Error: ${e.response!.data}");
      throw Exception(e.response?.data['message']);
    }
  }

  Future<List> getBrands() async {
    try {
      final Response response = await dio.get(
        "https://talabat639.runasp.net/api/Products/brands",
      );
      return response.data;
    } on DioException catch (e) {
      log("Error: ${e.response?.data}");
      throw Exception(e.response?.data['message']);
    }
  }
  
}

