// features/auth/data/data_source/auth_remote_data_source.dart
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:otlop_app/features/auth/data/auth_session.dart';

class AuthRemoteDataSource {
  final Dio dio = Dio();

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      await dio.post(
        'https://talabat639.runasp.net/api/Account/Register',
        data: {
          'displayName': name,
          'email': email,
          'password': password,
          'phoneNumber': phone,
        },
      );
      await login(email: email, pass: password);
      await AuthSession.saveProfile(name: name, userEmail: email);
    } on DioException catch (error) {
      log(error.response?.data.toString() ?? 'Registration failed');
      throw Exception(_errorMessage(error));
    }
  }

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
      await AuthSession.saveAccessToken(token);
      final responseData = response.data is Map ? response.data as Map : null;
      final responseName =
          responseData?['displayName'] ?? responseData?['name'];
      await AuthSession.saveProfile(
        name: responseName is String && responseName.isNotEmpty
            ? responseName
            : email.split('@').first,
        userEmail: email,
      );
      log(response.data.toString());
    } on DioException catch (e) {
      log(e.response?.data.toString() ?? 'error');
      throw Exception(e.response?.data.toString());
    }
  }

  String _errorMessage(DioException error) {
    final data = error.response?.data;
    if (data is Map && data['message'] != null) {
      return data['message'].toString();
    }
    return error.message ?? 'Registration failed';
  }
}
