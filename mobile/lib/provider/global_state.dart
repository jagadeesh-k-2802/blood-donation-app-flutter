import 'package:flutter/foundation.dart';
import 'package:blood_donation/models/auth.dart';

class GlobalState with ChangeNotifier {
  UserResponse? _userResponse;

  UserResponseData? get user => _userResponse?.data;

  void setUserResponse(UserResponse? userResponse) {
    _userResponse = userResponse;
    notifyListeners();
  }
}
