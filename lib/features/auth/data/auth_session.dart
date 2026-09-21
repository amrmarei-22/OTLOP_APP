import 'package:hive/hive.dart';

class AuthSession {
  AuthSession._();

  static String? accessToken;
  static String? displayName;
  static String? email;

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

  static Future<void> saveProfile({String? name, String? userEmail}) async {
    displayName = name;
    email = userEmail;
    final box = await Hive.openBox('app_session');
    if (name != null && name.isNotEmpty) await box.put('displayName', name);
    if (userEmail != null && userEmail.isNotEmpty) {
      await box.put('email', userEmail);
    }
  }

  static void init() async {
    final box = await Hive.openBox('app_session');
    accessToken = box.get('token');
    displayName = box.get('displayName');
    email = box.get('email');
  }

  static Future<void> clearAccessToken() async {
    accessToken = null;
    displayName = null;
    email = null;
    final box = await Hive.openBox('app_session');
    await box.delete('token');
    await box.delete('displayName');
    await box.delete('email');
  }
}
