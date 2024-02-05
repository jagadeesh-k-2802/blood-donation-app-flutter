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
  String id;
  String title;
  String description;
  String notificationType;
  String? itemId;
  String? profileId;
  DateTime createdAt;

  GetAllNotificationResponseData({
    required this.id,
    required this.title,
    required this.description,
    required this.notificationType,
    required this.itemId,
    required this.profileId,
    required this.createdAt,
  });

  factory GetAllNotificationResponseData.fromJson(Map<String, dynamic> json) {
    return GetAllNotificationResponseData(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      notificationType: json['notificationType'],
      itemId: json['itemId'],
      profileId: json['profileId'],
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
