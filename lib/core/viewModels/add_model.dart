

import '../../locator.dart';
import '../../pages/main_page.dart';
import '../base_model.dart';
import '../model/task_model.dart';
import '../model/title_model.dart';
import '../services/api_service.dart';
import '../viewstate.dart';
import 'package:intl/intl.dart';

class AddModel extends BaseModel {
  final ApiService _api = locator<ApiService>();
  List<TitleM> titles = [];

  TitleM selectedTitle = TitleM();
  late var selectedTitleID;

  late var formattedDate;
  late double duration;



  Future getTitle(bool edit, Task taskObj) async {
    setState(ViewState.busy);
    try {
      var obj = await _api.getTitle();

      if (obj.result != null && obj.result!.success! == true) {
        print("**********");

        titles = obj.result!.titles!;
        if (edit) {
          selectedDay = DateTime.parse(taskObj.date!);
          duration = taskObj.duration!;
          for (var i in titles) {
            if (taskObj.titleId! == i.id) {
              selectedTitleID = taskObj.titleId!;
              selectedTitle = i;
            }
          }
        } else {
          selectedTitle = titles.first;
          selectedTitleID = titles.first.id!;
        }
        formattedDate = DateFormat("dd LLLL yyyy", "ar").format(selectedDay);
        print(titles[0].name);
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

  updateFormattedDate(DateTime date) {
    selectedDay = date;
    var format = DateFormat("dd LLLL yyyy", "ar").format(date);
    formattedDate = format;
    notifyListeners();
  }

  setTitle(TitleM title) {
    selectedTitle = title;
    selectedTitleID = title.id!;
    notifyListeners();
  }

  setDuration(int hour, int minute) {
    String h = formattedInt(hour);
    String m = formattedInt(minute);
    double combinedValue = double.parse('$h.$m');
    duration = combinedValue;
    notifyListeners();
  }


  String formattedInt(int time) {
    return time < 10 ? '0$time' : time.toString();
  }

  Future<bool> addTask(String desc) async {
    bool success = false;
    try {
      var obj = await _api.addTask(
          selectedTitleID, desc, selectedDay.toString(), duration);
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
  Future<bool> editTask(Task taskObj,String desc) async {
    bool success = false;
    try {
      var obj = await _api.editTask(
         taskObj.taskId!, selectedTitleID, desc, selectedDay.toString(), duration);
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
}
