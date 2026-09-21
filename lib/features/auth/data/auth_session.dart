import 'package:hive/hive.dart';
class AuthSession {
  AuthSession._();

  static String? accessToken;

  static String get authorizationHeader {
    final token = accessToken;
    if (token == null || token.isEmpty) {
      throw StateError('User is not authenticated');
    }
    return 'Bearer $token';
  }
  static Future<void> saveAccessToken(String token) async {
    accessToken = token;
    final box = await Hive.openBox('app_session');
    await box.put('token', token);
  }

  static void init() async {
    final box = await Hive.openBox('app_session');
    accessToken = box.get('token');
  }

  static Future<void> clearAccessToken() async {
    accessToken = null;
    final box = await Hive.openBox('app_session');
    await box.delete('token');
  }
  
}
