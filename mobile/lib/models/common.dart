class MessageResponse {
  bool success;
  String message;

  MessageResponse({
    required this.success,
    required this.message,
  });

  factory MessageResponse.fromJson(Map<String, dynamic> json) {
    return MessageResponse(
      success: json['success'],
      message: json['message'],
    );
  }
}

class ErrorResponse {
  bool success;
  String error;

  ErrorResponse({
    required this.success,
    required this.error,
  });

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      success: json['success'],
      error: json['error'],
    );
  }
}
