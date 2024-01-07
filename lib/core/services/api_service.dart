import 'package:http/http.dart' as http;
import 'package:thakafah_reports/core/model/leave_model.dart';
import 'package:thakafah_reports/core/model/leaves_type.dart';
import 'package:thakafah_reports/core/model/report_details.dart';
import 'package:thakafah_reports/core/model/task_model.dart';
import 'package:thakafah_reports/core/model/update_task_model.dart';
import 'package:thakafah_reports/core/services/timesheet_prefrence.dart';
import 'dart:async';
import 'dart:convert';
import '../model/login_result.dart';
import '../model/profile_model.dart';
import '../model/title_model.dart';
import '../model/update_result.dart';

class ApiService {
  static const endpoint = 'https://timesheet.thakafah.com';
  static var auth = "";
  static var userID = "";
  static var db = "timesheet";

  static Map<String, String> headers(String auth) {
    return {
      "Content-Type": "application/json",
      "Accept": "application/json",
      'X-openerp': auth,
      'Cookie': 'session_id=$auth',
    };
  }

  Future<LoginResult> login(String email, String password) async {
    try {
      Map<String, dynamic> requestObject = {
        'jsonrpc': '2.0',
        'params': {'db': db, 'login': email, 'password': password},
      };
      var response = await http.post(
        Uri.parse('$endpoint/web/session/authenticate'),
        headers: ApiService.headers(""),
        body: jsonEncode(requestObject),
      );

      String rawCookie = response.headers['set-cookie']!;

      RegExp sessionIdRegex = RegExp(r'session_id=([^;]+)');
      String sessionId = sessionIdRegex.firstMatch(rawCookie)?.group(1) ?? '';
      auth = sessionId;
      TimeSheetPreference.setAuth(auth);
      return LoginResult.fromJson(json.decode(response.body));
    } catch (e) {
      // if (e is SocketException) {
      //   SnackbarShare.showMessage(Strings.noInternet);
      // } else if (e is TimeoutException) {
      //   SnackbarShare.showMessage(Strings.systemError);
      // } else {
      //   SnackbarShare.showMessage(Strings.systemError);
      // }
      return LoginResult();
    }
  }

  Future<UpdateResult> checkSession(String userAuth) async {
    try {
      Map<String, dynamic> data = {"jsonrpc": "2.0", "params": {}};
      var response = await http.post(
        Uri.parse('$endpoint/user/check_session'),
        headers: ApiService.headers(userAuth),
        body: jsonEncode(data),
      );
      auth = userAuth;
      return UpdateResult.fromJson(json.decode(response.body));
    } catch (e) {
      return UpdateResult();
    }
  }

  Future<TaskResult> getTask(int year, int month, int day) async {
    try {
      Map<String, dynamic> data = {
        "jsonrpc": "2.0",
        "params": {
          "user_id": int.parse(userID),
          "year": year,
          "month": month,
          "day": day
        }
      };
      var response = await http.post(
        Uri.parse('$endpoint/timesheet/line/get'),
        headers: ApiService.headers(auth),
        body: jsonEncode(data),
      );
      return TaskResult.fromJson(json.decode(response.body));
    } catch (e) {
      return TaskResult();
    }
  }

  Future<TitleModel> getTitle() async {
    try {
      Map<String, dynamic> data = {
        "jsonrpc": "2.0",
        "params": {
          "user_id": int.parse(userID),
        }
      };
      var response = await http.post(
        Uri.parse('$endpoint/user/title/get'),
        headers: ApiService.headers(auth),
        body: jsonEncode(data),
      );
      return TitleModel.fromJson(json.decode(response.body));
    } catch (e) {
      return TitleModel();
    }
  }

  Future<UpdateTask> addTask(
      int titleID, String desc, String date, double duration) async {
    try {
      Map<String, dynamic> data = {
        "jsonrpc": "2.0",
        "params": {
          "user_id": int.parse(userID),
          "title_id": titleID,
          "desc": desc,
          "date": date,
          "duration": duration
        }
      };
      var response = await http.post(
        Uri.parse('$endpoint/timesheet/line/add'),
        headers: ApiService.headers(auth),
        body: jsonEncode(data),
      );
      return UpdateTask.fromJson(json.decode(response.body));
    } catch (e) {
      return UpdateTask();
    }
  }

  Future<UpdateResult> editTask(int taskID, int titleID, String desc,
      String date, double duration) async {
    try {
      Map<String, dynamic> data = {
        "jsonrpc": "2.0",
        "params": {
          "user_id": int.parse(userID),
          "task_id": taskID,
          "title_id": titleID,
          "desc": desc,
          "date": date,
          "duration": duration
        }
      };
      var response = await http.post(
        Uri.parse('$endpoint/timesheet/line/edit'),
        headers: ApiService.headers(auth),
        body: jsonEncode(data),
      );
      return UpdateResult.fromJson(json.decode(response.body));
    } catch (e) {
      return UpdateResult();
    }
  }

  Future<UpdateResult> deleteTask(int taskID) async {
    try {
      Map<String, dynamic> data = {
        "jsonrpc": "2.0",
        "params": {
          "task_id": taskID,
        }
      };
      var response = await http.post(
        Uri.parse('$endpoint/timesheet/line/delete'),
        headers: ApiService.headers(auth),
        body: jsonEncode(data),
      );
      return UpdateResult.fromJson(json.decode(response.body));
    } catch (e) {
      return UpdateResult();
    }
  }

  Future<ReportDetails> getReportDetails(int year, int month) async {
    try {
      Map<String, dynamic> data = {
        "jsonrpc": "2.0",
        "params": {"user_id": int.parse(userID), "year": year, "month": month}
      };
      var response = await http.post(
        Uri.parse('$endpoint/timesheet/report/details'),
        headers: ApiService.headers(auth),
        body: jsonEncode(data),
      );
      return ReportDetails.fromJson(json.decode(response.body));
    } catch (e) {
      return ReportDetails();
    }
  }

  Future<UpdateResult> confirmSheet(int year, int month) async {
    try {
      Map<String, dynamic> data = {
        "jsonrpc": "2.0",
        "params": {"user_id": int.parse(userID), "year": year, "month": month}
      };
      var response = await http.post(
        Uri.parse('$endpoint/timesheet/report/confirm'),
        headers: ApiService.headers(auth),
        body: jsonEncode(data),
      );
      return UpdateResult.fromJson(json.decode(response.body));
    } catch (e) {
      return UpdateResult();
    }
  }

  Future<UpdateResult> requestDayOff(
      String date, String dayOffType, String dayOffNote, int dayNumber) async {
    try {
      Map<String, dynamic> data = {
        "jsonrpc": "2.0",
        "params": {
          "date": date,
          "user_id": int.parse(userID),
          "day_off_type": dayOffType,
          "day_off_note": dayOffNote,
          "days_number": dayNumber
        }
      };
      var response = await http.post(
        Uri.parse('$endpoint/timesheet/request/dayoff'),
        headers: ApiService.headers(auth),
        body: jsonEncode(data),
      );
      return UpdateResult.fromJson(json.decode(response.body));
    } catch (e) {
      return UpdateResult();
    }
  }

  Future<UpdateResult> requestLeave(
      String date, String note, double duration) async {
    try {
      Map<String, dynamic> data = {
        "jsonrpc": "2.0",
        "params": {
          "user_id": int.parse(userID),
          "date": date,
          "leave_note": note,
          "leave_duration": duration
        }
      };
      var response = await http.post(
        Uri.parse('$endpoint/timesheet/request/leave'),
        headers: ApiService.headers(auth),
        body: jsonEncode(data),
      );
      return UpdateResult.fromJson(json.decode(response.body));
    } catch (e) {
      return UpdateResult();
    }
  }

  Future<Profile> getUserProfile() async {
    try {
      Map<String, dynamic> data = {
        "jsonrpc": "2.0",
        "params": {
          "user_id": userID,
        }
      };
      var response = await http.post(
        Uri.parse('$endpoint/user/info/get'),
        headers: ApiService.headers(auth),
        body: jsonEncode(data),
      );
      return Profile.fromJson(json.decode(response.body));
    } catch (e) {
      return Profile();
    }
  }

  Future<UpdateResult> deleteLeave(int requestID) async {
    try {
      Map<String, dynamic> data = {
        "jsonrpc": "2.0",
        "params": {
          "user_id": userID,
          "request_id": requestID,
        }
      };
      var response = await http.post(
        Uri.parse('$endpoint/timesheet/request/delete'),
        headers: ApiService.headers(auth),
        body: jsonEncode(data),
      );
      return UpdateResult.fromJson(json.decode(response.body));
    } catch (e) {
      return UpdateResult();
    }
  }

  Future<LeaveType> getLeaveTypes() async {
    try {
      Map<String, dynamic> data = {"jsonrpc": "2.0", "params": {}};
      var response = await http.post(
        Uri.parse('$endpoint/leave/type/valid'),
        headers: ApiService.headers(auth),
        body: jsonEncode(data),
      );
      var a = LeaveType.fromJson(json.decode(response.body));
      return LeaveType.fromJson(json.decode(response.body));
    } catch (e) {
      return LeaveType();
    }
  }

  Future<UpdateResult> createLeave(int leaveType, String dateFrom, String dateTo,
      String hourFrom, String hourTo, String description) async {
    try {
      Map<String, dynamic> data = {
        "jsonrpc": "2.0",
        "params": {
          "user_id": int.parse(userID),
          "leave_type_id": leaveType,
          "request_date_from": dateFrom,
          "request_date_to": dateTo,
          "request_hour_from": hourFrom,
          "request_hour_to": hourTo,
          "name": description
        }
      };
      var response = await http.post(
        Uri.parse('$endpoint/leave/leave/create'),
        headers: ApiService.headers(auth),
        body: jsonEncode(data),
      );
      var a = UpdateResult.fromJson(json.decode(response.body));
      return UpdateResult.fromJson(json.decode(response.body));
    } catch (e) {
      return UpdateResult();
    }
  }

  Future<LeaveModel> getLeave(
      String dateFrom, String dateTo, String state, int type,bool selectDate) async {
    try {
      Map<String, dynamic> data = {
        "jsonrpc": "2.0",
        "params": {
          "user_id": int.parse(userID), // or false
          "date_from": selectDate==true ? dateFrom : false,
          "date_to":   selectDate==true ? dateTo : false,
          "state": state, // "confirm" or "refuse" or "validate1" or "validate"
          "type_id": type == 0 ? false : type // or false
        }
      };
      var response = await http.post(
        Uri.parse('$endpoint/leave/leave/get'),
        headers: ApiService.headers(auth),
        body: jsonEncode(data),
      );
      var a = LeaveModel.fromJson(json.decode(response.body));
      return LeaveModel.fromJson(json.decode(response.body));
    } catch (e) {
      return LeaveModel();
    }
  }
}
