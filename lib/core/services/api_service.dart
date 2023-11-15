import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
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
    //"test.user@thakafah.org"   "test"

    try {
      // SnackbarShare.init(context);
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

      //RegExp expiresRegex = RegExp(r'Expires=([^;]+)');
      // String expiresString = expiresRegex.firstMatch(rawCookie)?.group(1) ?? '';

      // DateFormat inputFormat = DateFormat("EEE, dd-MMM-yyyy HH:mm:ss 'GMT'");
      // DateTime expires = inputFormat.parseUtc(expiresString);

      auth = sessionId;
      TimeSheetPreference.setAuth(auth);
      // TimeSheetPreference.setExpireSession(expires);
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
      var a = UpdateResult.fromJson(json.decode(response.body));
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
          "user_id":  int.parse(userID),
          "year": year,
          "month": month,
          "day":day
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
          "user_id":  int.parse(userID),
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
      var a = UpdateTask.fromJson(json.decode(response.body));
      return UpdateTask.fromJson(json.decode(response.body));
    } catch (e) {
      return UpdateTask();
    }
  }

  Future<UpdateResult> editTask(
      int taskID,  int titleID, String desc, String date, double duration) async {
    try {
      Map<String, dynamic> data = {
        "jsonrpc": "2.0",
        "params": {
          "user_id":  int.parse(userID),
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
        "params": {
          "user_id":  int.parse(userID),
          "year":year,
          "month":month
        }
      };
      var response = await http.post(
        Uri.parse('$endpoint/timesheet/report/details'),
        headers: ApiService.headers(auth),
        body: jsonEncode(data),
      );
      var a = ReportDetails.fromJson(json.decode(response.body));
      return ReportDetails.fromJson(json.decode(response.body));
    } catch (e) {
      return ReportDetails();
    }
  }

  Future<UpdateResult> confirmSheet(int year, int month) async {
    try {
      Map<String, dynamic> data = {
        "jsonrpc": "2.0",
        "params": {
          "user_id": int.parse(userID),
          "year":year,
          "month":month
        }
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
  Future<UpdateResult> requestDayOff(String date,String dayOffType,String dayOffNote,int dayNumber) async {
    try {
      Map<String, dynamic> data = {
        "jsonrpc": "2.0",
        "params": {
          "date": date,
          "user_id": int.parse(userID),
          "day_off_type": dayOffType,
          "day_off_note":dayOffNote,
          "days_number":dayNumber
        }
      };
      var response = await http.post(
        Uri.parse('$endpoint/timesheet/request/dayoff'),
        headers: ApiService.headers(auth),
        body: jsonEncode(data),
      );
      var a = UpdateResult.fromJson(json.decode(response.body));
      return UpdateResult.fromJson(json.decode(response.body));
    } catch (e) {
      return UpdateResult();
    }
  }
  Future<UpdateResult> requestLeave(String date,String note,double duration) async {
    try {
      Map<String, dynamic> data = {
        "jsonrpc": "2.0",
        "params": {
          "user_id": int.parse(userID),
          "date":date,
          "leave_note":note,
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


}
