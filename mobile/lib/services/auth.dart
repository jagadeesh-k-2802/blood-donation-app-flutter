import 'package:shared_preferences/shared_preferences.dart';
import 'package:blood_donation/constants/constants.dart';
import 'package:blood_donation/services/dio.dart';
import 'package:blood_donation/models/auth.dart';
import 'package:blood_donation/models/common.dart';

class AuthService {
  static Future<TokenResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final dio = await getDioClient();
      const url = '$apiUrl/auth/login';
      var data = {'email': email, 'password': password};

      final response = await dio.post(url, data: data);

      if (response.statusCode != 200) {
        var errorResponse = ErrorResponse.fromJson(response.data);
        throw errorResponse.error;
      }

      var tokenResponse = TokenResponse.fromJson(response.data);
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(tokenKey, tokenResponse.token);
      return tokenResponse;
    } catch (e) {
      rethrow;
    }
  }

  static Future<TokenResponse> register({
    required String name,
    required String email,
    required String password,
    required String address,
    required String bloodType,
    required String phone,
  }) async {
    try {
      final dio = await getDioClient();
      const url = '$apiUrl/auth/register';

      var data = {
        'name': name,
        'email': email,
        'phone': phone,
        'bloodType': bloodType,
        'address': address,
        'password': password,
      };

      final response = await dio.post(url, data: data);

      if (response.statusCode != 200) {
        var errorResponse = ErrorResponse.fromJson(response.data);
        throw errorResponse.error;
      }

      var tokenResponse = TokenResponse.fromJson(response.data);
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(tokenKey, tokenResponse.token);
      return tokenResponse;
    } catch (e) {
      rethrow;
    }
  }

  static Future<MessageResponse> logout() async {
    try {
      final dio = await getDioClient();
      const url = '$apiUrl/auth/logout';

      final response = await dio.get(url);

      if (response.statusCode != 200) {
        var errorResponse = ErrorResponse.fromJson(response.data);
        throw errorResponse.error;
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(tokenKey);
      return MessageResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  static Future<UserResponse> getMe() async {
    try {
      final dio = await getDioClient();
      const url = '$apiUrl/auth/me';
      final response = await dio.get(url);

      if (response.statusCode != 200) {
        var errorResponse = ErrorResponse.fromJson(response.data);
        throw errorResponse.error;
      }

      return UserResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
