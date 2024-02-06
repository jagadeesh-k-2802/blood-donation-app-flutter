class TokenResponse {
  final bool success;
  final String token;

  TokenResponse({required this.success, required this.token});

  factory TokenResponse.fromJson(Map<String, dynamic> json) {
    return TokenResponse(
      success: json['success'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['success'] = success;
    data['token'] = token;
    return data;
  }
}

class UserResponse {
  bool success;
  UserResponseData data;

  UserResponse({
    required this.success,
    required this.data,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      success: json['success'],
      data: UserResponseData.fromJson(json['data']),
    );
  }
}

class UserResponseData {
  String id;
  String avatar;
  String name;
  String email;
  String phone;
  String address;
  String bloodType;
  String fcmToken;
  String createdAt;

  UserResponseData({
    required this.id,
    required this.avatar,
    required this.name,
    required this.email,
    required this.phone,
    required this.bloodType,
    required this.fcmToken,
    required this.address,
    required this.createdAt,
  });

  factory UserResponseData.fromJson(Map<String, dynamic> json) {
    return UserResponseData(
      id: json['id'],
      avatar: json['avatar'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      bloodType: json['bloodType'],
      fcmToken: json['fcmToken'],
      address: json['address'],
      createdAt: json['createdAt'],
    );
  }
}
