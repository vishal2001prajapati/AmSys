class UserDecodedData {
  late String userIdentity;
  late String password;
  String? firstName;
  String? middleName;
  String? lastName;
  String? dateOfBirth;
  String? newPassword;
  String? verificationCode;

  UserDecodedData({
    required this.userIdentity,
    required this.password,
    this.firstName,
    this.middleName,
    this.lastName,
    this.dateOfBirth,
    this.newPassword,
    this.verificationCode,
  });

  factory UserDecodedData.fromJson(Map<String, dynamic> json) {
    return UserDecodedData(
      userIdentity: json['userIdentity'],
      password: json['password'],
      firstName: json['firstName'],
      middleName: json['middleName'],
      lastName: json['lastName'],
      dateOfBirth: json['dateOfBirth'],
      newPassword: json['newPassword'],
      verificationCode: json['verificationCode'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'userIdentity': userIdentity,
      'password': password,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'dateOfBirth': dateOfBirth,
      'newPassword': newPassword,
      'verificationCode': verificationCode,
    };
    return data;
  }
}
