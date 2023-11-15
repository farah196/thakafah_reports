
class UpdateResult {
  String? jsonrpc;
  Result? result;
  Error? error;
  UpdateResult({this.jsonrpc,this.result,this.error});

  UpdateResult.fromJson(Map<String, dynamic> json) {
    jsonrpc = json['jsonrpc'];
    result =
    json['result'] != null ?  Result.fromJson(json['result']) : null;
    error=  json['error'] != null ?  Error.fromJson(json['error']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['jsonrpc'] = jsonrpc;
    if (result != null) {
      data['result'] = result!.toJson();
    }
    if (error != null) {
      data['error'] = error!.toJson();
    }
    return data;
  }
}
class Error {
  int? code;
  String? message;


  Error({this.code, this.message});

  Error.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['code'] = code;
    return data;
  }
}
class Result {
  bool? success;
  String? message;
  int? id;
  bool? active;
  bool? location;
  Result({this.success, this.message,this.id,this.active,this.location});

  Result.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    id = json['user_id'];
    active = json['active_sessions'];
    location = json['location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    data['user_id'] = id;
    data['active_session'] = active;
    data['location'] = location;
    return data;
  }
}
