
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
  Data? data;

  Error({this.code, this.message, this.data});

  Error.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? name;
  String? debug;
  String? message;
  List<String>? arguments;

  Data({this.name, this.debug, this.message, this.arguments});

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    debug = json['debug'];
    message = json['message'];
    arguments = json['arguments'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['debug'] = this.debug;
    data['message'] = this.message;
    data['arguments'] = this.arguments;

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
