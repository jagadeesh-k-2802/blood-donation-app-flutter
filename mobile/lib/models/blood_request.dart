class GetBloodRequestResponse {
  bool success;
  GetBloodRequestResponseData data;

  GetBloodRequestResponse({
    required this.success,
    required this.data,
  });

  factory GetBloodRequestResponse.fromJson(Map<String, dynamic> json) {
    return GetBloodRequestResponse(
      success: json['success'],
      data: GetBloodRequestResponseData.fromJson(json['data']),
    );
  }
}

class GetBloodRequestResponseData {
  String id;
  String patientName;
  String age;
  String bloodType;
  String location;
  List<double> locationCoordinates;
  String status;
  String contactNumber;
  int unitsRequired;
  DateTime timeUntil;
  String? notes;
  BloodRequestCreatedBy createdBy;
  BloodRequestAcceptedBy? acceptedBy;
  DateTime createdAt;

  GetBloodRequestResponseData({
    required this.id,
    required this.patientName,
    required this.age,
    required this.bloodType,
    required this.location,
    required this.locationCoordinates,
    required this.status,
    required this.contactNumber,
    required this.unitsRequired,
    required this.timeUntil,
    required this.notes,
    required this.createdBy,
    required this.acceptedBy,
    required this.createdAt,
  });

  factory GetBloodRequestResponseData.fromJson(Map<String, dynamic> json) {
    return GetBloodRequestResponseData(
      id: json['id'],
      patientName: json['patientName'],
      age: json['age'],
      bloodType: json['bloodType'],
      location: json['location'],
      locationCoordinates: (json['locationCoordinates']['coordinates'] as List)
          .map((v) => v as double)
          .toList(),
      status: json['status'],
      contactNumber: json['contactNumber'],
      unitsRequired: json['unitsRequired'],
      notes: json['notes'],
      timeUntil: DateTime.parse(json['timeUntil']),
      createdBy: BloodRequestCreatedBy.fromJson(json['createdBy']),
      acceptedBy: json['acceptedBy'] != null
          ? BloodRequestAcceptedBy.fromJson(json['acceptedBy'])
          : null,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class BloodRequestCreatedBy {
  String id;
  String name;
  String avatar;

  BloodRequestCreatedBy({
    required this.id,
    required this.name,
    required this.avatar,
  });

  factory BloodRequestCreatedBy.fromJson(Map<String, dynamic> json) {
    return BloodRequestCreatedBy(
      id: json['_id'],
      name: json['name'],
      avatar: json['avatar'],
    );
  }
}

class BloodRequestAcceptedBy {
  String id;
  String name;
  String avatar;

  BloodRequestAcceptedBy({
    required this.id,
    required this.name,
    required this.avatar,
  });

  factory BloodRequestAcceptedBy.fromJson(Map<String, dynamic> json) {
    return BloodRequestAcceptedBy(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'],
    );
  }
}

class GetAllBloodRequestResponse {
  bool success;
  List<GetAllBloodRequestResponseData> data;

  GetAllBloodRequestResponse({
    required this.success,
    required this.data,
  });

  factory GetAllBloodRequestResponse.fromJson(Map<String, dynamic> json) {
    return GetAllBloodRequestResponse(
      success: json['success'],
      data: (json['data'] as List)
          .map((v) => GetAllBloodRequestResponseData.fromJson(v))
          .toList(),
    );
  }
}

class GetAllBloodRequestResponseData {
  String id;
  String patientName;
  String age;
  String bloodType;
  String location;
  String contactNumber;
  String status;
  int unitsRequired;
  DateTime timeUntil;
  String? notes;
  String createdBy;
  String? acceptedBy;
  DateTime createdAt;

  GetAllBloodRequestResponseData({
    required this.id,
    required this.patientName,
    required this.age,
    required this.bloodType,
    required this.location,
    required this.contactNumber,
    required this.status,
    required this.unitsRequired,
    required this.timeUntil,
    required this.notes,
    required this.createdBy,
    required this.acceptedBy,
    required this.createdAt,
  });

  factory GetAllBloodRequestResponseData.fromJson(Map<String, dynamic> json) {
    return GetAllBloodRequestResponseData(
      id: json['id'],
      patientName: json['patientName'],
      age: json['age'],
      bloodType: json['bloodType'],
      location: json['location'],
      contactNumber: json['contactNumber'],
      status: json['status'],
      unitsRequired: json['unitsRequired'],
      notes: json['notes'],
      timeUntil: DateTime.parse(json['timeUntil']),
      createdBy: json['createdBy'],
      acceptedBy: json['acceptedBy'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class GetNearbyBloodRequestResponse {
  bool success;
  List<GetNearbyBloodRequestResponseData> data;

  GetNearbyBloodRequestResponse({
    required this.success,
    required this.data,
  });

  factory GetNearbyBloodRequestResponse.fromJson(Map<String, dynamic> json) {
    return GetNearbyBloodRequestResponse(
      success: json['success'],
      data: (json['data'] as List)
          .map((v) => GetNearbyBloodRequestResponseData.fromJson(v))
          .toList(),
    );
  }
}

class GetNearbyBloodRequestResponseData {
  String id;
  String patientName;
  String age;
  String bloodType;
  String location;
  String contactNumber;
  String status;
  int unitsRequired;
  DateTime timeUntil;
  String? notes;
  String createdBy;
  String? acceptedBy;
  DateTime createdAt;

  GetNearbyBloodRequestResponseData({
    required this.id,
    required this.patientName,
    required this.age,
    required this.bloodType,
    required this.location,
    required this.contactNumber,
    required this.status,
    required this.unitsRequired,
    required this.timeUntil,
    required this.notes,
    required this.createdBy,
    required this.acceptedBy,
    required this.createdAt,
  });

  factory GetNearbyBloodRequestResponseData.fromJson(
    Map<String, dynamic> json,
  ) {
    return GetNearbyBloodRequestResponseData(
      id: json['id'],
      patientName: json['patientName'],
      age: json['age'],
      bloodType: json['bloodType'],
      location: json['location'],
      contactNumber: json['contactNumber'],
      status: json['status'],
      unitsRequired: json['unitsRequired'],
      timeUntil: DateTime.parse(json['timeUntil']),
      notes: json['notes'],
      createdBy: json['createdBy'],
      acceptedBy: json['acceptedBy'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class GetBloodRequestStatsResponse {
  bool success;
  GetBloodRequestStatsResponseData data;

  GetBloodRequestStatsResponse({
    required this.success,
    required this.data,
  });

  factory GetBloodRequestStatsResponse.fromJson(Map<String, dynamic> json) {
    return GetBloodRequestStatsResponse(
      success: json['success'],
      data: GetBloodRequestStatsResponseData.fromJson(json['data']),
    );
  }
}

class GetBloodRequestStatsResponseData {
  String totalRequests;
  String totalDonated;
  String averageRating;

  GetBloodRequestStatsResponseData({
    required this.totalRequests,
    required this.totalDonated,
    required this.averageRating,
  });

  factory GetBloodRequestStatsResponseData.fromJson(Map<String, dynamic> json) {
    return GetBloodRequestStatsResponseData(
      totalRequests: json['totalRequests'].toString(),
      totalDonated: json['totalDonated'].toString(),
      averageRating: json['averageRating'].toString(),
    );
  }
}

class CreateBloodRequestResponse {
  bool success;
  CreateBloodRequestResponseData data;

  CreateBloodRequestResponse({
    required this.success,
    required this.data,
  });

  factory CreateBloodRequestResponse.fromJson(Map<String, dynamic> json) {
    return CreateBloodRequestResponse(
      success: json['success'],
      data: CreateBloodRequestResponseData.fromJson(json['data']),
    );
  }
}

class CreateBloodRequestResponseData {
  String id;

  CreateBloodRequestResponseData({
    required this.id,
  });

  factory CreateBloodRequestResponseData.fromJson(Map<String, dynamic> json) {
    return CreateBloodRequestResponseData(
      id: json['id'],
    );
  }
}
