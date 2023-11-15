import '../../locator.dart';
import '../base_model.dart';
import '../model/report_details.dart';
import '../services/api_service.dart';
import '../viewstate.dart';

class TimesheetVModel extends BaseModel {
  final ApiService _api = locator<ApiService>();
  late Details detailsObj;
  bool visibleReportDetails = false;
  int selectedMonth =DateTime.now().month;
  List<int> monthList = [1,2,3,4,5,6,7,8,9,10,11,12];
  Future getDetailsTask() async {
    try {
      setState(ViewState.busy);
      var obj =
          await _api.getReportDetails(DateTime.now().year, selectedMonth);
      if (obj.result != null && obj.result!.success! == true) {
        detailsObj = obj.result!.details!;
      } else {
        print("444");
        detailsObj = Details();
      }
      setState(ViewState.idle);
    } catch (e) {
      setState(ViewState.idle);
    }
  }
  Future<bool> confirmSheet() async {
    bool success = false;
    try {
      var obj =
      await _api.confirmSheet(DateTime.now().year, selectedMonth);
      if (obj.result != null && obj.result!.success! == true) {
        success = true;
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
  String durationInTime(double duration) {
    List<String> durationParts = duration.toStringAsFixed(2).split('.');
    String integerPart = durationParts[0]
        .padLeft(2, '0'); // Add leading zeros to the integer part
    String decimalPart = durationParts[1];

    return "$integerPart:$decimalPart";
  }

  setVisibleDetails(bool visible) {
    visibleReportDetails = visible;
    notifyListeners();
  }
  setMonth(int month) {
    selectedMonth = month;
    notifyListeners();
  }

}
