import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/api.dart';
import '../core/storage.dart';
import '../models/user_model.dart';

class AuthService {
  static Future<bool> login(String email, String password) async {
    final res = await http.post(
      Uri.parse('${Api.baseUrl}/login'),
      headers: {
        'Accept': 'application/json',
      },
      body: {
        'email': email,
        'password': password,
      },
    );

    if (res.statusCode != 200) return false;

    final json = jsonDecode(res.body);

    // asumsi response:
    // { "token": "xxxx" }
    await SecureStorage.saveToken(json['token']);
    return true;
  }

  static Future<void> logout() async {
    await SecureStorage.logout();
  }


  static Future<UserModel?> getMe() async {
  try {
    final token = await SecureStorage.getToken();

    if (token == null || token.isEmpty) {
      return null;
    }

    final res = await http.get(
      Uri.parse('${Api.baseUrl}/me'),
      headers: Api.authHeader(token),
    );

    if (res.statusCode != 200) {
      return null;
    }

    final json = jsonDecode(res.body);
    return UserModel.fromJson(json);
  } catch (e) {
    print('getMe error: $e');
    return null;
  }
}


}
