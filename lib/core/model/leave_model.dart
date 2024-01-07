class LeaveModel {
  String? jsonrpc;
  Result? result;

  LeaveModel({this.jsonrpc, this.result});

  LeaveModel.fromJson(Map<String, dynamic> json) {
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
  List<Data>? data;

  Result({this.success, this.code, this.data});

  Result.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    if (json['message'] != null) {
      data = <Data>[];
      json['message'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['code'] = this.code;
    if (this.data != null) {
      data['message'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? name;
  String? holidayStatusId;
  int? holidayTypeId;
  int? employeeId;
  String? state;
  String? duration;
  String? requestDateFrom;
  String? requestDateTo;
  String? requestHourFrom;
  String? requestHourTo;

  Data(
      {this.id,
        this.name,
        this.holidayStatusId,
        this.holidayTypeId,
        this.employeeId,
        this.state,
        this.duration,
        this.requestDateFrom,
        this.requestDateTo,
        this.requestHourFrom,
        this.requestHourTo});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    holidayStatusId = json['holiday_status_id'];
    holidayTypeId = json['holiday_type_id'];
    employeeId = json['employee_id'];
    state = json['state'];
    duration = json['duration'];

    if (json['request_date_from'] != null && json['request_date_from']!= false) {
      requestDateFrom = json['request_date_from'];
    }else{
      requestDateFrom = "";
    }

    if (json['request_date_to'] != null && json['request_date_to']!= false) {
      requestDateTo = json['request_date_to'];
    }else{
      requestDateTo = "";
    }


    if (json['request_hour_from'] != null && json['request_hour_from']!= false) {
      requestHourFrom = json['request_hour_from'];
    }else{
      requestHourFrom = "";
    }

    if (json['request_hour_to'] != null && json['request_hour_to']!= false) {
      requestHourTo = json['request_hour_to'];
    }else{
      requestHourTo = "";
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['holiday_status_id'] = this.holidayStatusId;
    data['employee_id'] = this.employeeId;
    data['state'] = this.state;
    data['duration'] = this.duration;
    data['holiday_type_id'] = this.holidayTypeId;
    data['request_date_from'] = this.requestDateFrom;
    data['request_date_to'] = this.requestDateTo;
    data['request_hour_from'] = this.requestHourFrom;
    data['request_hour_to'] = this.requestHourTo;
    return data;
  }
}
