class GetAllNotificationResponse {
  bool success;
  List<GetAllNotificationResponseData> data;

  GetAllNotificationResponse({
    required this.success,
    required this.data,
  });

  factory GetAllNotificationResponse.fromJson(Map<String, dynamic> json) {
    return GetAllNotificationResponse(
      success: json['success'],
      data: (json['data'] as List)
          .map((v) => GetAllNotificationResponseData.fromJson(v))
          .toList(),
    );
  }
}

class GetAllNotificationResponseData {
  String title;
  String description;
  DateTime createdAt;

  GetAllNotificationResponseData({
    required this.title,
    required this.description,
    required this.createdAt,
  });

  factory GetAllNotificationResponseData.fromJson(Map<String, dynamic> json) {
    return GetAllNotificationResponseData(
      title: json['title'],
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class NotificationCountResponse {
  bool success;
  NotificationCountResponseData data;

  NotificationCountResponse({
    required this.success,
    required this.data,
  });

  factory NotificationCountResponse.fromJson(Map<String, dynamic> json) {
    return NotificationCountResponse(
      success: json['success'],
      data: NotificationCountResponseData.fromJson(json['data']),
    );
  }
}

class NotificationCountResponseData {
  int count;

  NotificationCountResponseData({
    required this.count,
  });

  factory NotificationCountResponseData.fromJson(Map<String, dynamic> json) {
    return NotificationCountResponseData(
      count: json['count'],
    );
  }
}
