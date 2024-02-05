import 'package:blood_donation/constants/constants.dart';
import 'package:blood_donation/models/common.dart';
import 'package:blood_donation/models/user.dart';
import 'package:blood_donation/services/dio.dart';

class UserService {
  static Future<GetProfileResponse> getProfile({required String id}) async {
    try {
      final dio = await getDioClient();
      String url = '$apiUrl/api/v1/user/$id';
      final response = await dio.get(url);

      if (response.statusCode != 200) {
        var errorResponse = ErrorResponse.fromJson(response.data);
        throw errorResponse.error;
      }

      return GetProfileResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
