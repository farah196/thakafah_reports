class LeavesModel {
  String? jsonrpc;
  Result? result;

  LeavesModel({this.jsonrpc, this.result});

  LeavesModel.fromJson(Map<String, dynamic> json) {
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
  List<Leaves>? leaves;

  Result({this.success, this.code, this.leaves});

  Result.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    if (json['message'] != null) {
      leaves = <Leaves>[];
      json['message'].forEach((v) {
        leaves!.add(new Leaves.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['code'] = this.code;
    if (this.leaves != null) {
      data['message'] = this.leaves!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Leaves {
  int? id;
  String? thType;
  String? thDayOffType;
  String? date;
  double? time;
  String? thNote;

  Leaves(
      {this.id,
        this.thType,
        this.thDayOffType,
        this.date,
        this.time,
        this.thNote});

  Leaves.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    thType = json['th_type'];
    thDayOffType = json['th_day_off_type'];
    date = json['date'];
    time = json['time'];
    thNote = json['th_note'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['th_type'] = this.thType;
    data['th_day_off_type'] = this.thDayOffType;
    data['date'] = this.date;
    data['time'] = this.time;
    data['th_note'] = this.thNote;
    return data;
  }
}
