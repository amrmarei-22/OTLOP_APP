// features/auth/data/data_source/auth_remote_data_source.dart
import 'dart:developer';

import 'package:dio/dio.dart';

class AuthRemoteDataSource {
  final Dio dio = Dio();

  Future<void> login({required String email, required String pass}) async {
    try {
      final Response response = await dio.post(
        'https://talabat639.runasp.net/api/Account/Login',

        data: {"email": email, "password": pass},
      );
      log(response.data.toString());
    } on DioException catch (e) {
      log(e.response?.data.toString() ?? 'error');
      throw Exception(e.response?.data.toString());
    }
  }
}
