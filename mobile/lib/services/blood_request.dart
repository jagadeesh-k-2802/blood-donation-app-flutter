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

  static Future<MessageResponse> createBloodRequest({
    required String patientName,
    required String age,
    required String bloodType,
    required String location,
    required String contactNumber,
    required int unitsRequired,
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
        'contactNumber': contactNumber,
        'unitsRequired': unitsRequired,
        'notes': notes,
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
}
