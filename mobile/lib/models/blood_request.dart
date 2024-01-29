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
  String patientName;
  String age;
  String bloodType;
  String location;
  String contactNumber;
  int unitsRequired;
  String notes;
  String createdBy;
  String? acceptedBy;
  DateTime createdAt;

  GetAllBloodRequestResponseData({
    required this.patientName,
    required this.age,
    required this.bloodType,
    required this.location,
    required this.contactNumber,
    required this.unitsRequired,
    required this.notes,
    required this.createdBy,
    required this.acceptedBy,
    required this.createdAt,
  });

  factory GetAllBloodRequestResponseData.fromJson(Map<String, dynamic> json) {
    return GetAllBloodRequestResponseData(
      patientName: json['patientName'],
      age: json['age'],
      bloodType: json['bloodType'],
      location: json['location'],
      contactNumber: json['contactNumber'],
      unitsRequired: json['unitsRequired'],
      notes: json['notes'],
      createdBy: json['createdBy'],
      acceptedBy: json['acceptedBy'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
