class ReportDetails {
  String? jsonrpc;
  Result? result;

  ReportDetails({this.jsonrpc, this.result});

  ReportDetails.fromJson(Map<String, dynamic> json) {
    jsonrpc = json['jsonrpc'];
    result =
    json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['jsonrpc'] = this.jsonrpc;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class Result {
  bool? success;
  int? code;
  Details? details;

  Result({this.success, this.code, this.details});

  Result.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    details =
    json['message'] != null ? new Details.fromJson(json['message']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['code'] = this.code;
    if (this.details != null) {
      data['message'] = this.details!.toJson();
    }
    return data;
  }
}

class Details {
  int? reportId;
  double? mainExpectedHourInMonth;
  double? overtimeExpectedHourInMonth;
  double? doneMainHourInMonth;
  double? doneOvertimeHourInMonth;
  int? normalDaysOff;
  int? sicknessDaysOff;
  double? totalLeave;
  double? totalHoursShortage;
  List<ReportLine>? reportLine;

  Details(
      {this.reportId,
        this.mainExpectedHourInMonth,
        this.overtimeExpectedHourInMonth,
        this.doneMainHourInMonth,
        this.doneOvertimeHourInMonth,
        this.normalDaysOff,
        this.sicknessDaysOff,
        this.totalLeave,
        this.totalHoursShortage,
        this.reportLine});

  Details.fromJson(Map<String, dynamic> json) {
    reportId = json['report_id'];
    mainExpectedHourInMonth = json['main_expected_hour_in_month'];
    overtimeExpectedHourInMonth = json['overtime_expected_hour_in_month'];
    doneMainHourInMonth = json['done_main_hour_in_month'];
    doneOvertimeHourInMonth = json['done_overtime_hour_in_month'];
    normalDaysOff = json['normal_days_off'];
    sicknessDaysOff = json['sickness_days_off'];
    totalLeave = json['total_leave'];
    totalHoursShortage = json['total_hours_shortage'];
    if (json['report_line'] != null) {
      reportLine = <ReportLine>[];
      json['report_line'].forEach((v) {
        reportLine!.add(new ReportLine.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['report_id'] = this.reportId;
    data['main_expected_hour_in_month'] = this.mainExpectedHourInMonth;
    data['overtime_expected_hour_in_month'] = this.overtimeExpectedHourInMonth;
    data['done_main_hour_in_month'] = this.doneMainHourInMonth;
    data['done_overtime_hour_in_month'] = this.doneOvertimeHourInMonth;
    data['normal_days_off'] = this.normalDaysOff;
    data['sickness_days_off'] = this.sicknessDaysOff;
    data['total_leave'] = this.totalLeave;
    data['total_hours_shortage'] = this.totalHoursShortage;
    if (this.reportLine != null) {
      data['report_line'] = this.reportLine!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ReportLine {
  int? reportLineId;
  String? date;
  bool? dayOff;
  double? leave;
  double? doneMainHour;
  double? doneOvertimeHour;
  double? hoursShortage;
  List<TaskInfo>? taskInfo;
  bool? isExpanded = false;
  ReportLine(
      {this.reportLineId,
        this.date,
        this.dayOff,
        this.leave,
        this.doneMainHour,
        this.doneOvertimeHour,
        this.hoursShortage,
        this.taskInfo,
      this.isExpanded});

  ReportLine.fromJson(Map<String, dynamic> json) {
    reportLineId = json['report_line_id'];
    date = json['date'];
    dayOff = json['day_off'];
    leave = json['leave'];
    doneMainHour = json['done_main_hour'];
    doneOvertimeHour = json['done_overtime_hour'];
    hoursShortage = json['hours_shortage'];
    if (json['task_info'] != null) {
      taskInfo = <TaskInfo>[];
      json['task_info'].forEach((v) {
        taskInfo!.add(new TaskInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['report_line_id'] = this.reportLineId;
    data['date'] = this.date;
    data['day_off'] = this.dayOff;
    data['leave'] = this.leave;
    data['done_main_hour'] = this.doneMainHour;
    data['done_overtime_hour'] = this.doneOvertimeHour;
    data['hours_shortage'] = this.hoursShortage;
    if (this.taskInfo != null) {
      data['task_info'] = this.taskInfo!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TaskInfo {
  int? taskId;
  String? taskName;
  String? taskTitle;
  double? taskDuration;

  TaskInfo({this.taskId, this.taskName, this.taskTitle, this.taskDuration});

  TaskInfo.fromJson(Map<String, dynamic> json) {
    taskId = json['task_id'];
    taskName = json['task_name'];
    taskTitle = json['task_title'];
    taskDuration = json['task_duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['task_id'] = this.taskId;
    data['task_name'] = this.taskName;
    data['task_title'] = this.taskTitle;
    data['task_duration'] = this.taskDuration;
    return data;
  }
}
