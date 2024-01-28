import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:blood_donation/constants/constants.dart';

Future<Dio> getDioClient() async {
  final dio = Dio();
  dio.options.validateStatus = (status) => status != null ? status < 500 : true;
  dio.options.baseUrl = apiUrl;
  dio.options.connectTimeout = const Duration(seconds: 7);
  dio.options.receiveTimeout = const Duration(seconds: 7);

  final prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString(tokenKey);

  dio.options.headers = {
    'Authorization': 'Bearer $token',
  };

  return dio;
}
