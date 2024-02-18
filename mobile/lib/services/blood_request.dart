import 'package:blood_donation/constants/constants.dart';
import 'package:blood_donation/models/blood_request.dart';
import 'package:blood_donation/models/common.dart';
import 'package:blood_donation/services/dio.dart';

class BloodRequestService {
  static Future<GetAllBloodRequestResponse> getBloodRequests({
    required int page,
    required int limit,
  }) async {
    try {
      final dio = await getDioClient();
      const url = '$apiUrl/api/v1/blood-request';

      final response = await dio.get(
        url,
        queryParameters: {'page': page, 'limit': limit},
      );

      if (response.statusCode != 200) {
        var errorResponse = ErrorResponse.fromJson(response.data);
        throw errorResponse.error;
      }
      return GetAllBloodRequestResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  static Future<GetBloodRequestResponse> getBloodRequest({
    required String id,
  }) async {
    try {
      final dio = await getDioClient();
      String url = '$apiUrl/api/v1/blood-request/$id';
      final response = await dio.get(url);

      if (response.statusCode != 200) {
        var errorResponse = ErrorResponse.fromJson(response.data);
        throw errorResponse.error;
      }

      return GetBloodRequestResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  static Future<GetNearbyBloodRequestResponse> getNearbyBloodRequests({
    required int requestRadius,
  }) async {
    try {
      final dio = await getDioClient();
      const url = '$apiUrl/api/v1/blood-request/nearby';

      final response = await dio.get(
        url,
        queryParameters: {'requestRadius': requestRadius},
      );

      if (response.statusCode != 200) {
        var errorResponse = ErrorResponse.fromJson(response.data);
        throw errorResponse.error;
      }
      return GetNearbyBloodRequestResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  static Future<GetBloodRequestStatsResponse> getBloodRequestStats() async {
    try {
      final dio = await getDioClient();
      const url = '$apiUrl/api/v1/blood-request/stats';
      final response = await dio.get(url);

      if (response.statusCode != 200) {
        var errorResponse = ErrorResponse.fromJson(response.data);
        throw errorResponse.error;
      }
      return GetBloodRequestStatsResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  static Future<MessageResponse> sendDonateRequest({
    required String id,
  }) async {
    try {
      final dio = await getDioClient();
      String url = '$apiUrl/api/v1/blood-request/donate/$id';
      final response = await dio.get(url);

      if (response.statusCode != 200) {
        var errorResponse = ErrorResponse.fromJson(response.data);
        throw errorResponse.error;
      }
      return MessageResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  static Future<MessageResponse> replyToDonateRequest({
    required String id,
    required String notificationId,
    required bool accept,
  }) async {
    try {
      final dio = await getDioClient();
      String url = '$apiUrl/api/v1/blood-request/reply/$id';
      var data = {'accept': accept, 'notificationId': notificationId};
      final response = await dio.put(url, data: data);

      if (response.statusCode != 200) {
        var errorResponse = ErrorResponse.fromJson(response.data);
        throw errorResponse.error;
      }
      return MessageResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  static Future<MessageResponse> markRequestCompleted({
    required String id,
    required List<double> coordinates,
  }) async {
    try {
      final dio = await getDioClient();
      String url = '$apiUrl/api/v1/blood-request/complete/$id';
      var data = {'coordinates': coordinates};
      final response = await dio.put(url, data: data);

      if (response.statusCode != 200) {
        var errorResponse = ErrorResponse.fromJson(response.data);
        throw errorResponse.error;
      }
      return MessageResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  static Future<MessageResponse> sendRating({
    required String id,
    required double rating,
    required String review,
    required String notificationId,
  }) async {
    try {
      final dio = await getDioClient();
      String url = '$apiUrl/api/v1/blood-request/rate/$id';

      var data = {
        'rating': rating,
        'review': review,
        'notificationId': notificationId,
      };

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

  static Future<CreateBloodRequestResponse> createBloodRequest({
    required String patientName,
    required String age,
    required String bloodType,
    required String location,
    required List<double> coordinates,
    required String contactNumber,
    required int unitsRequired,
    required String timeUntil,
    required String notes,
  }) async {
    try {
      final dio = await getDioClient();
      const url = '$apiUrl/api/v1/blood-request';

      var data = {
        'patientName': patientName,
        'age': age,
        'bloodType': bloodType,
        'location': location,
        'coordinates': coordinates,
        'contactNumber': contactNumber,
        'unitsRequired': unitsRequired,
        'timeUntil': timeUntil,
        'notes': notes,
      };

      final response = await dio.post(url, data: data);

      if (response.statusCode != 200) {
        var errorResponse = ErrorResponse.fromJson(response.data);
        throw errorResponse.error;
      }

      return CreateBloodRequestResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  static Future<MessageResponse> updateBloodRequest({
    required String id,
    required String patientName,
    required String age,
    required String bloodType,
    required String location,
    required List<double> coordinates,
    required String contactNumber,
    required int unitsRequired,
    required String timeUntil,
    required String notes,
  }) async {
    try {
      final dio = await getDioClient();
      String url = '$apiUrl/api/v1/blood-request/$id';

      var data = {
        'patientName': patientName,
        'age': age,
        'bloodType': bloodType,
        'location': location,
        'coordinates': coordinates,
        'contactNumber': contactNumber,
        'unitsRequired': unitsRequired,
        'timeUntil': timeUntil,
        'notes': notes,
      };

      final response = await dio.put(url, data: data);

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

  static Future<MessageResponse> deleteRequest({
    required String id,
  }) async {
    try {
      final dio = await getDioClient();
      String url = '$apiUrl/api/v1/blood-request/$id';
      final response = await dio.delete(url);

      if (response.statusCode != 200) {
        var errorResponse = ErrorResponse.fromJson(response.data);
        throw errorResponse.error;
      }
      return MessageResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
