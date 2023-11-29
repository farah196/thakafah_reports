import 'package:flutter/material.dart';
import '../../locator.dart';
import '../base_model.dart';
import '../services/api_service.dart';
import '../services/timesheet_prefrence.dart';

class LoginModel extends BaseModel {
  final ApiService _api = locator<ApiService>();

  bool? isValid;

  var msg = "";
  bool isLoggedIn = false;
  bool isUserFocus = false;
  bool isPasswordFocus = false;
  var auth;

  setAuth(String sessionID) {
    auth = sessionID;
    notifyListeners();
  }

  Future<bool> login(
    String email,
    String password,
    BuildContext context,
  ) async {
    var loginResponse = await _api.login(email, password);

    var success = loginResponse.result != null;

    if (loginResponse.result != null) {
      auth = ApiService.auth;
      TimeSheetPreference.setUserID(loginResponse.result!.uid!);
      TimeSheetPreference.setShowDuration(true);
      TimeSheetPreference.setShowTaskItem(true);

      ApiService.userID = loginResponse.result!.uid!.toString();
    }
    notifyListeners();
    return success;
  }


}
