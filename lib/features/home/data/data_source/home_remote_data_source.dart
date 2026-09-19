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

