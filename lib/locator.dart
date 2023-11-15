
import 'package:get_it/get_it.dart';
import 'package:thakafah_reports/core/viewModels/leave_vmodel.dart';
import 'package:thakafah_reports/core/viewModels/timesheet_vmodel.dart';

import 'core/services/api_service.dart';
import 'core/viewModels/add_model.dart';
import 'core/viewModels/calendar_model.dart';
import 'core/viewModels/login_model.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => ApiService());
  locator.registerFactory(() => LoginModel());
  locator.registerFactory(() => CalendarModel());
  locator.registerFactory(() => AddModel());
  locator.registerFactory(() => TimesheetVModel());
  locator.registerFactory(() => LeaveVModel());
}