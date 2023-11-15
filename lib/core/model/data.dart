class Data {
  String? userName;
  String? userFirstName;
  String? userFatherName;
  String? userGrandfatherName;
  String? userFamilyName;
  String? userGender;
  String? userMobile;
  String? userBirthDate;
  String? userNationalNumber;
  String? userCity;
  String? userDistrict;
  String? userStreet;
  double? userLongitude;
  double? userLatitude;
  String? userIcon;
  List<Student>? studentList;

  Data(
      {this.userName,
        this.userFirstName,
        this.userFatherName,
        this.userGrandfatherName,
        this.userFamilyName,
        this.userGender,
        this.userMobile,
        this.userBirthDate,
        this.userNationalNumber,
        this.userCity,
        this.userDistrict,
        this.userStreet,
        this.userLongitude,
        this.userLatitude,
        this.userIcon,
        this.studentList});

  Data.fromJson(Map<String, dynamic> json) {
    userName = json['user_name'];
    userFirstName = json['user_first_name'];
    userFatherName = json['user_father_name'];
    userGrandfatherName = json['user_grandfather_name'];
    userFamilyName = json['user_family_name'];
    userGender = json['user_gender'];
    userMobile = json['user_mobile'];
    userBirthDate = json['user_birth_date'];
    userNationalNumber = json['user_national_number'];
    userCity = json['user_city'];
    userDistrict = json['user_district'];
    userStreet = json['user_street'];
    userLongitude = json['user_longitude'];
    userLatitude = json['user_latitude'];
    userIcon = json['user_icon'];
    if (json['student_list'] != null) {
      studentList = <Student>[];
      json['student_list'].forEach((v) {
        studentList!.add( Student.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['user_name'] = userName;
    data['user_first_name'] = userFirstName;
    data['user_father_name'] = userFatherName;
    data['user_grandfather_name'] = userGrandfatherName;
    data['user_family_name'] = userFamilyName;
    data['user_gender'] = userGender;
    data['user_mobile'] = userMobile;
    data['user_birth_date'] = userBirthDate;
    data['user_national_number'] = userNationalNumber;
    data['user_city'] = userCity;
    data['user_district'] = userDistrict;
    data['user_street'] = userStreet;
    data['user_longitude'] = userLongitude;
    data['user_latitude'] = userLatitude;
    data['user_icon'] = userIcon;
    if (studentList != null) {
      data['student_list'] = studentList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
class Student {
  double? id;
  String? name;
  String? firstName;
  String? fatherName;
  String? grandfatherName;
  String? familyName;
  String? schoolName;
  String? birthDate;
  String? gender;
  String? nationalNumber;
  String? grade;
  String? orderInFamily;
  bool? registered;
  String? userIcon;
  bool? isExpanded = false;
  Student(
      {this.id,
        this.name,
        this.firstName,
        this.fatherName,
        this.grandfatherName,
        this.familyName,
        this.schoolName,
        this.birthDate,
        this.gender,
        this.nationalNumber,
        this.grade,
        this.orderInFamily,
        this.registered,
        this.userIcon,
        this.isExpanded});

  Student.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    firstName = json['first_name'];
    fatherName = json['father_name'];
    grandfatherName = json['grandfather_name'];
    familyName = json['family_name'];
    schoolName = json['school_name'];
    birthDate = json['birth_date'];
    gender = json['gender'];
    nationalNumber = json['national_number'];
    grade = json['grade'];
    orderInFamily = json['order_in_family'];
    registered = json['registered'];
    userIcon = json['user_icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['first_name'] = firstName;
    data['father_name'] = fatherName;
    data['grandfather_name'] = grandfatherName;
    data['family_name'] = familyName;
    data['school_name'] = schoolName;
    data['birth_date'] = birthDate;
    data['gender'] = gender;
    data['national_number'] = nationalNumber;
    data['grade'] = grade;
    data['order_in_family'] =orderInFamily;
    data['registered'] = registered;
    data['user_icon'] = userIcon;
    return data;
  }
}