import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:blood_donation/constants/constants.dart';
import 'package:blood_donation/services/dio.dart';
import 'package:blood_donation/models/auth.dart';
import 'package:blood_donation/models/common.dart';

class AuthService {
  static Future<TokenResponse> login({
    required String email,
    required String password,
    required String fcmToken,
  }) async {
    try {
      final dio = await getDioClient();
      const url = '$apiUrl/api/v1/auth/login';
      var data = {'email': email, 'password': password, 'fcmToken': fcmToken};

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
    required List<double> coordinates,
    required String bloodType,
    required String phone,
    required String fcmToken,
  }) async {
    try {
      final dio = await getDioClient();
      const url = '$apiUrl/api/v1/auth/register';

      var data = {
        'name': name,
        'email': email,
        'phone': phone,
        'bloodType': bloodType,
        'address': address,
        'coordinates': coordinates,
        'password': password,
        'fcmToken': fcmToken,
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
      const url = '$apiUrl/api/v1/auth/logout';

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

  static Future<MessageResponse> updateUserDetails({
    required String name,
    required String email,
    required String address,
    required List<double> coordinates,
    required String bloodType,
    required String phone,
  }) async {
    try {
      final dio = await getDioClient();
      const url = '$apiUrl/api/v1/auth/update-details';

      var data = {
        'name': name,
        'email': email,
        'phone': phone,
        'bloodType': bloodType,
        'address': address,
        'coordinates': coordinates,
      };

      final response = await dio.post(url, data: data);

      if (response.statusCode != 200) {
        var errorResponse = ErrorResponse.fromJson(response.data);
        throw errorResponse.error;
      }

      var messageResponse = MessageResponse.fromJson(response.data);
      return messageResponse;
    } catch (e) {
      rethrow;
    }
  }

  static Future<TokenResponse> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final dio = await getDioClient();
      const url = '$apiUrl/api/v1/auth/update-password';

      var data = {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
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

  static Future<MessageResponse> updateAvatar({
    required String localFilePath,
  }) async {
    try {
      final dio = await getDioClient();
      const url = '$apiUrl/api/v1/auth/update-avatar';
      FormData data = FormData.fromMap({});

      data = FormData.fromMap({
        'avatar': await MultipartFile.fromFile(localFilePath),
      });

      final response = await dio.post(url, data: data);

      if (response.statusCode != 200) {
        var errorResponse = ErrorResponse.fromJson(response.data);
        throw errorResponse.error;
      }

      return MessageResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  static Future<MessageResponse> forgotPassword({
    required String email,
  }) async {
    try {
      final dio = await getDioClient();
      const url = '$apiUrl/api/v1/auth/forgot-password';
      var data = {'email': email};
      final response = await dio.post(url, data: data);

      if (response.statusCode != 200) {
        var errorResponse = ErrorResponse.fromJson(response.data);
        throw errorResponse.error;
      }

      var messageResponse = MessageResponse.fromJson(response.data);
      return messageResponse;
    } catch (e) {
      rethrow;
    }
  }

  static Future<MessageResponse> resetPassword({
    required String token,
    required String password,
  }) async {
    try {
      final dio = await getDioClient();
      const url = '$apiUrl/api/v1/auth/reset-password';
      var data = {'token': token, 'password': password};
      final response = await dio.post(url, data: data);

      if (response.statusCode != 200) {
        var errorResponse = ErrorResponse.fromJson(response.data);
        throw errorResponse.error;
      }

      var messageResponse = MessageResponse.fromJson(response.data);
      return messageResponse;
    } catch (e) {
      rethrow;
    }
  }

  static Future<UserResponse> getMe() async {
    try {
      final dio = await getDioClient();
      const url = '$apiUrl/api/v1/auth/me';
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
