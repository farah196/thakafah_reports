import 'package:table_calendar/table_calendar.dart';
import 'package:thakafah_reports/core/model/task_model.dart';
import 'package:thakafah_reports/core/model/title_model.dart';
import 'package:thakafah_reports/core/services/api_service.dart';
import 'package:thakafah_reports/core/viewstate.dart';
import '../../locator.dart';
import '../../pages/main_page.dart';
import '../base_model.dart';

class CalendarModel extends BaseModel {
  final ApiService _api = locator<ApiService>();
  List<Task> tasks = [];
  List<TitleM> titles = [];
  DateTime focusedDay = DateTime.now();


  Future getTask() async {
    try {
      var obj = await _api.getTask(
          selectedDay.year, selectedDay.month, selectedDay.day);
      if (obj.result != null && obj.result!.success! == true) {
        tasks = obj.result!.task!;
      } else {
        print("444");
        tasks = [];
      }
      notifyListeners();
    } catch (e) {
      notifyListeners();
    }
  }

  String returnTitleFromID(int id) {
    String title = "";
    for (var i in titles) {
      if (i.id == id) {
        title = i.name!;
      }
    }
    return title;
  }

  Future getTitle() async {
    setState(ViewState.busy);
    try {
      getTask();
      var obj = await _api.getTitle();
      if (obj.result != null && obj.result!.success! == true) {
        titles = obj.result!.titles!;

      } else {
        print("444");
        titles = [];
      }
      setState(ViewState.idle);
    } catch (e) {
      setState(ViewState.idle);
    }
    setState(ViewState.idle);
  }

  Future<bool> deleteTask(int taskID,int index) async {

    bool success = false;
    try {
      var obj = await _api.deleteTask(taskID);
      removeTask(index);
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

  void onDaySelected(DateTime day, DateTime focused) {
    if (!isSameDay(selectedDay, day)) {
      selectedDay = day;
      focusedDay = focused;
      getTask();

      print(day);
      notifyListeners();
    }
  }

  removeTask(int index){
    print("DISSSMMIIIS");
    print(index);
    tasks.removeAt(index);
    notifyListeners();
  }

}
