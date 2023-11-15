class TitleModel {
  String? jsonrpc;
  Result? result;

  TitleModel({this.jsonrpc, this.result});

  TitleModel.fromJson(Map<String, dynamic> json) {
    jsonrpc = json['jsonrpc'];
    result =
    json['result'] != null ? Result.fromJson(json['result']) : null;
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
  List<TitleM>? titles;

  Result({this.success, this.code, this.titles});

  Result.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    if (json['message'] != null) {
      titles = <TitleM>[];
      json['message'].forEach((v) {
        titles!.add(TitleM.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['code'] = code;
    if (titles != null) {
      data['message'] = titles!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TitleM {
  int? id;
  String? name;

  TitleM({this.id, this.name});

  TitleM.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
