class LoginRequestData {
  String? userIdentity;
  String? password;

  LoginRequestData({this.userIdentity, this.password});

  LoginRequestData.fromJson(Map<String, dynamic> json) {
    userIdentity = json['userIdentity'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userIdentity'] = this.userIdentity;
    data['password'] = this.password;
    return data;
  }
}
