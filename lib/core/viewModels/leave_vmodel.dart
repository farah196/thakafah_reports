import '../../constant/app_strings.dart';
import '../../locator.dart';
import '../base_model.dart';
import '../services/api_service.dart';
import 'package:intl/intl.dart';
class LeaveVModel extends BaseModel {
  final ApiService _api = locator<ApiService>();
  DateTime selectedDate = DateTime.now();
  late var formattedDate;
  List<String> titleList = [Strings.normalReason, Strings.sickReason];
  List<int> dayList = [1,2,3,4,5,6,7,8,9,10,11,12,13];
  String selectedTitle = Strings.normalReason;
  int selectedDay = 1;
  bool error = false;
  late double duration;
  init(){
    formattedDate = DateFormat("dd LLLL yyyy", "ar").format(selectedDate);
    notifyListeners();
  }

  updateFormattedDate(DateTime date) {
    selectedDate = date;
    var format = DateFormat("dd LLLL yyyy", "ar").format(date);
    formattedDate = format;
    notifyListeners();
  }
  setTitle(String title) {
    selectedTitle = title;
    notifyListeners();
  }
  setError(bool er) {
    error = er;
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
      var obj = await _api.requestLeave(selectedDate.toString(), note, duration);
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
      String type = (selectedTitle==Strings.normalReason)?"normal":"sickness";
      var obj = await _api.requestDayOff(selectedDate.toString(), type, note, selectedDay);

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