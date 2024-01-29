import 'package:blood_donation/services/dio.dart';
import 'package:blood_donation/constants/constants.dart';
import 'package:blood_donation/models/common.dart';
import 'package:blood_donation/models/notification.dart';

class NotificationService {
  static Future<GetAllNotificationResponse> getNotifications({
    required int page,
    required int limit,
  }) async {
    try {
      final dio = await getDioClient();
      const url = '$apiUrl/api/v1/notification';

      final response = await dio.get(
        url,
        queryParameters: {'page': page, 'limit': limit},
      );

      if (response.statusCode != 200) {
        var errorResponse = ErrorResponse.fromJson(response.data);
        throw errorResponse.error;
      }
      return GetAllNotificationResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  static Future<NotificationCountResponse> getUnreadCount() async {
    try {
      final dio = await getDioClient();
      const url = '$apiUrl/api/v1/notification/count';
      final response = await dio.get(url);

      if (response.statusCode != 200) {
        var errorResponse = ErrorResponse.fromJson(response.data);
        throw errorResponse.error;
      }
      return NotificationCountResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
