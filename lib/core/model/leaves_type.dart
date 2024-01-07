class LeaveType {
  String? jsonrpc;
  Result? result;

  LeaveType({this.jsonrpc, this.result});

  LeaveType.fromJson(Map<String, dynamic> json) {
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
  List<TypeL>? type;

  Result({this.success, this.code, this.type});

  Result.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    if (json['message'] != null) {
      type = <TypeL>[];
      json['message'].forEach((v) {
        type!.add(new TypeL.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['code'] = this.code;
    if (this.type != null) {
      data['message'] = this.type!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TypeL {
  int? id;
  String? name;
  String? displayName;
  double? maxLeaves;
  double? virtualRemainingLeaves;
  String? unit;

  TypeL(
      {this.id,
        this.name,
        this.displayName,
        this.maxLeaves,
        this.virtualRemainingLeaves,
        this.unit});

  TypeL.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    displayName = json['display_name'];
    maxLeaves = json['max_leaves'];
    virtualRemainingLeaves = json['virtual_remaining_leaves'];
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['display_name'] = this.displayName;
    data['max_leaves'] = this.maxLeaves;
    data['virtual_remaining_leaves'] = this.virtualRemainingLeaves;
    data['unit'] = this.unit;
    return data;
  }
}
