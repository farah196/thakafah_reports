
class Profile {
  String? jsonrpc;
  Result? result;

  Profile({this.jsonrpc, this.result});

  Profile.fromJson(Map<String, dynamic> json) {
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
  ProfileDetails? profile;

  Result({this.success, this.code, this.profile});

  Result.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    profile =
    json['message'] != null ? ProfileDetails.fromJson(json['message']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['code'] = code;
    if (profile != null) {
      data['message'] = profile!.toJson();
    }
    return data;
  }
}

class ProfileDetails {
  String? name;
  String? gender;

  ProfileDetails({this.name, this.gender});

  ProfileDetails.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    gender = json['gender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['gender'] = gender;
    return data;
  }
}
