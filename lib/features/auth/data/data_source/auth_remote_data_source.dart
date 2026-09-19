// features/auth/data/data_source/auth_remote_data_source.dart
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:otlop_app/features/auth/data/auth_session.dart';

class AuthRemoteDataSource {
  final Dio dio = Dio();

  Future<void> login({required String email, required String pass}) async {
    try {
      final Response response = await dio.post(
        'https://talabat639.runasp.net/api/Account/Login',

        data: {"email": email, "password": pass},
      );
      final token = response.data is Map ? response.data['token'] : null;
      if (token is! String || token.isEmpty) {
        throw Exception('Login response did not contain an access token');
      }
      AuthSession.accessToken = token;
      log(response.data.toString());
    } on DioException catch (e) {
      log(e.response?.data.toString() ?? 'error');
      throw Exception(e.response?.data.toString());
    }
  }
}
