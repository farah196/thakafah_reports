import 'dart:ui';

import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:flutter/material.dart';
import 'package:thakafah_reports/core/model/leave_model.dart';
import 'package:thakafah_reports/core/model/title_model.dart';
import '../../constant/app_strings.dart';
import '../../locator.dart';
import '../base_model.dart';
import '../model/leaves_type.dart';
import '../services/api_service.dart';
import 'package:intl/intl.dart';
import '../viewstate.dart';

class LeaveVModel extends BaseModel {
  final ApiService _api = locator<ApiService>();
  DateTime startSelectedDate = DateTime.now();
  DateTime endSelectedDate = DateTime.now();
  late var startFormattedDate;
  late var endFormattedDate;
  bool selectDate = false;

  String currentTime =
      DateFormat('kk:mm:ss \n EEE d MMM').format(DateTime.now());
  Time startHour = Time(hour: 0, minute: 00, second: 00);
  Time endHour = Time(hour: 0, minute: 00, second: 00);

  List<String> titleList = [Strings.normalReason, Strings.sickReason];
  List<int> dayList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13];

  String selectedTitle = Strings.normalReason;
  int selectedDay = 1;

  List<TypeL> leaveTypes = [];

  List<TitleM> statusLeave = [
    TitleM(
        id: 0, name: "بإنتظار موافقة", key: "confirm", color: Colors.grey),
    TitleM(id: 1, name: "تم الرفض", key: "refuse", color: Colors.redAccent),
    TitleM(
        id: 2,
        name: "الموافقة الثانية",
        key: "validate1",
        color: Colors.amberAccent),
    TitleM(id: 3, name: "تم الموافقة", key: "validate", color: Colors.green),
  ];

  TitleM selectedStatus = TitleM(name: "", key: "");

  List<Data> leaves = [];
  late double duration;
  TypeL selectedType = TypeL(id: 0, name: "");
  TypeL selectedTypeSheet = TypeL(id: 0, name: "");

  TitleM getLeaveStatus(String status) {
    TitleM st = TitleM(name: "", key: "");
    for (var i in statusLeave) {
      if (i.key == status) {
        st = i;
      }
    }
    return st;
  }

  init() {
    startFormattedDate = DateFormat("dd LLLL yyyy", "ar").format(startSelectedDate);
    endFormattedDate = DateFormat("dd LLLL yyyy", "ar").format(endSelectedDate);
    getLeaves();
    notifyListeners();
  }

  setSelectedType(TypeL type) {
    selectedType = type;
    notifyListeners();
  }

  setSelectedStatus(TitleM status) {
    selectedStatus = status;
    notifyListeners();
  }

  setSelectedTypeSheet(TypeL type) {
    selectedTypeSheet = type;
    notifyListeners();
  }

  setStartHour(Time start) {
    startHour = start;
    notifyListeners();
  }

  setEndHour(Time end) {
    endHour = end;
    notifyListeners();
  }

  updateStartFormattedDate(DateTime date) {
    startSelectedDate = date;
    var format = DateFormat("dd LLLL yyyy", "ar").format(date);
    startFormattedDate = format;
    selectDate = true;
    notifyListeners();
  }

  updateEndFormattedDate(DateTime date) {
    endSelectedDate = date;
    var format = DateFormat("dd LLLL yyyy", "ar").format(date);
    endFormattedDate = format;
    selectDate = true;
    notifyListeners();
  }

  setTitle(String title) {
    selectedTitle = title;
    notifyListeners();
  }

  setDay(int day) {
    selectedDay = day;
    notifyListeners();
  }

  String formattedInt(int time) {
    return time < 10 ? '0$time' : time.toString();
  }

  setDuration(int hour, int minute) {
    String h = formattedInt(hour);
    String m = formattedInt(minute);
    double combinedValue = double.parse('$h.$m');
    duration = combinedValue;
    notifyListeners();
  }

  Future<bool> requestLeave(String note) async {
    bool success = false;
    try {
      var obj =
          await _api.requestLeave(startSelectedDate.toString(), note, duration);
      if (obj.result != null && obj.result!.success! == true) {
        if (obj.result!.success!) {
          success = true;
        } else {
          success = false;
        }
      } else {
        print("444");
        success = false;
      }
      notifyListeners();
    } catch (e) {
      success = false;
      notifyListeners();
    }
    return success;
  }

  Future<bool> requestDayOff(String note) async {
    bool success = false;
    try {
      String type =
          (selectedTitle == Strings.normalReason) ? "normal" : "sickness";
      var obj = await _api.requestDayOff(
          startSelectedDate.toString(), type, note, selectedDay);

      if (obj.result != null && obj.result!.success! == true) {
        if (obj.result!.success!) {
          success = true;
        } else {
          success = false;
        }
      } else {
        print("444");
        success = false;
      }
      notifyListeners();
    } catch (e) {
      success = false;
      notifyListeners();
    }
    return success;
  }

  Future getLeaves() async {
    try {
      setState(ViewState.busy);

      var obj = await _api.getLeave(
          startSelectedDate.toString().split(" ").first,
          endSelectedDate.toString().split(" ").first,
          selectedStatus.key.toString(),
          selectedType.id!,
          selectDate);
      if (obj.result != null && obj.result!.success! == true) {
        leaves = obj.result!.data!;
      } else {
        print("444");
        leaves = [];
      }
      setState(ViewState.idle);
    } catch (e) {
      setState(ViewState.idle);
    }
  }

  Future getLeaveType() async {
    try {
      init();
      var obj = await _api.getLeaveTypes();
      if (obj.result != null && obj.result!.success! == true) {
        leaveTypes = obj.result!.type!;
        selectedTypeSheet = leaveTypes.first;
      } else {
        print("444");
        leaveTypes = [];
      }
      notifyListeners();
    } catch (e) {
      notifyListeners();
    }
  }

  Future<String> createLeave(
      String description, String hourFrom, String hourTo) async {
    String errorMsg = "";
    try {
      var obj = await _api.createLeave(
          selectedTypeSheet.id!,
          startSelectedDate.toString().split(" ").first,
          endSelectedDate.toString().split(" ").first,
          hourFrom,
          hourTo,
          description);

      if (obj.result != null && obj.result!.success! == true) {
        errorMsg = "";
      } else {
        if (obj.error != null && obj.error!.data!.message!.isNotEmpty) {
          if (obj.error!.data!.message!.contains("overlap")) {
            errorMsg =
                "لا يمكنك اضافة اجازة في هذا التاريخ لتعارضها مع اجازة اخرى بفترتها";
          } else if (obj.error!.data!.message!.contains("remaining")) {
            errorMsg = "لا يوجد لديك رصيد كافٍ لإضافة إجازة جديدة";
          }
        }
      }
      notifyListeners();
    } catch (e) {
      errorMsg = "Error";
      notifyListeners();
    }
    return errorMsg;
  }
}
