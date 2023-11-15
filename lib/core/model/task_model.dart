class TaskResult {
  String? jsonrpc;
  Result? result;

  TaskResult({this.jsonrpc, this.result});

  TaskResult.fromJson(Map<String, dynamic> json) {
    jsonrpc = json['jsonrpc'];
    result = json['result'] != null ? Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['jsonrpc'] = jsonrpc;
    if (result != null) {
      data['result'] = result!.toJson();
    }
    return data;
  }
}

class Result {
  bool? success;
  int? code;
  List<Task>? task;

  Result({this.success, this.code, this.task});

  Result.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    if (json['message'] != null) {
      task = <Task>[];
      json['message'].forEach((v) {
        task!.add(Task.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['code'] = code;
    if (task != null) {
      data['message'] = task!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Task {
  int? taskId;
  int? titleId;
  int? reportId;
  int? reportLineId;
  String? desc;
  String? date;
  double? duration;
  bool? isExpanded;

  Task(
      {this.taskId,
      this.titleId,
      this.reportId,
      this.reportLineId,
      this.desc,
      this.date,
      this.duration,
      this.isExpanded});

  Task.fromJson(Map<String, dynamic> json) {
    taskId = json['task_id'];
    titleId = json['title_id'];
    reportId = json['report_id'];
    reportLineId = json['report_line_id'];
    desc = json['desc'];
    date = json['date'];
    duration = json['duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['task_id'] = taskId;
    data['title_id'] = titleId;
    data['report_id'] = reportId;
    data['report_line_id'] = reportLineId;
    data['desc'] = desc;
    data['date'] = date;
    data['duration'] = duration;
    return data;
  }
}
