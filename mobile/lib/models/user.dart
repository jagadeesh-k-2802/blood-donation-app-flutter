class GetProfileResponse {
  bool success;
  GetProfileResponseData data;

  GetProfileResponse({
    required this.success,
    required this.data,
  });

  factory GetProfileResponse.fromJson(Map<String, dynamic> json) {
    return GetProfileResponse(
      success: json['success'],
      data: GetProfileResponseData.fromJson(json['data']),
    );
  }
}

class GetProfileResponseData {
  String id;
  String avatar;
  String name;
  String email;
  String phone;
  String address;
  String bloodType;
  String createdAt;
  String totalRequests;
  String totalDonated;
  String averageRating;
  List<ProfileReviewData> reviews;

  GetProfileResponseData({
    required this.id,
    required this.avatar,
    required this.name,
    required this.email,
    required this.phone,
    required this.bloodType,
    required this.address,
    required this.createdAt,
    required this.totalRequests,
    required this.totalDonated,
    required this.averageRating,
    required this.reviews,
  });

  factory GetProfileResponseData.fromJson(Map<String, dynamic> json) {
    return GetProfileResponseData(
      id: json['_id'],
      avatar: json['avatar'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      bloodType: json['bloodType'],
      address: json['address'],
      createdAt: json['createdAt'],
      totalRequests: json['totalRequests'].toString(),
      totalDonated: json['totalDonated'].toString(),
      averageRating: json['averageRating'].toString(),
      reviews: (json['reviews'] as List)
          .map((v) => ProfileReviewData.fromJson(v))
          .toList(),
    );
  }
}

class ProfileReviewData {
  int rating;
  String review;
  ProfileCreatedBy createdBy;
  DateTime createdAt;

  ProfileReviewData({
    required this.rating,
    required this.review,
    required this.createdBy,
    required this.createdAt,
  });

  factory ProfileReviewData.fromJson(Map<String, dynamic> json) {
    return ProfileReviewData(
      rating: json['rating'],
      review: json['review'],
      createdBy: ProfileCreatedBy.fromJson(json['createdBy']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class ProfileCreatedBy {
  String name;
  String avatar;

  ProfileCreatedBy({
    required this.name,
    required this.avatar,
  });

  factory ProfileCreatedBy.fromJson(Map<String, dynamic> json) {
    return ProfileCreatedBy(
      name: json['name'],
      avatar: json['avatar'],
    );
  }
}
