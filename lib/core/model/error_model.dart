class Error {
  int? code;
  String? message;
  ErrorData? data;

  Error({this.code, this.message, this.data});

  Error.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? ErrorData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ErrorData {
  String? name;
  String? debug;
  String? message;
  List<String>? arguments;


  ErrorData({this.name, this.debug, this.message, this.arguments});

  ErrorData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    debug = json['debug'];
    message = json['message'];
    arguments = json['arguments'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['debug'] = debug;
    data['message'] = message;
    data['arguments'] = arguments;
    return data;
  }
}