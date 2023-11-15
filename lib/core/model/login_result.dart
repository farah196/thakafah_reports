import 'error_model.dart';
class LoginResult {
  String? jsonrpc;
  Result? result;
  Error? error;
  LoginResult({this.jsonrpc, this.result,this.error});

  LoginResult.fromJson(Map<String, dynamic> json) {
    jsonrpc = json['jsonrpc'];
    error = json['error'] != null ? Error.fromJson(json['error']) : null;
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
  int? uid;

  String? db;

  String? name;
  String? username;
  String? partnerDisplayName;
  List<int>? userId;


  Result({this.uid, this.db, this.name, this.username, this.partnerDisplayName });

  Result.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    db = json['db'];
    name = json['name'];
    username = json['username'];
    partnerDisplayName = json['partner_display_name'];
    userId = json['user_id'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = uid;
    data['db'] = db;
    data['name'] = name;
    data['username'] = username;
    data['partner_display_name'] = partnerDisplayName;
    data['user_id'] = userId;
    return data;
  }
}










