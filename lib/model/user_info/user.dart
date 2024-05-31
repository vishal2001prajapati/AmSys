class UserData {
  User? user;
  int? uploadedAssetCount;
  int? surveyedAssetCount;

  UserData({this.user, this.uploadedAssetCount, this.surveyedAssetCount});

  UserData.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    uploadedAssetCount = json['uploadedAssetCount'];
    surveyedAssetCount = json['surveyedAssetCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['uploadedAssetCount'] = uploadedAssetCount;
    data['surveyedAssetCount'] = surveyedAssetCount;
    return data;
  }
}

class User {
  dynamic userID;
  String? userName;
  String? encodedPassword;
  dynamic fingerPrint;
  dynamic irisScan;
  dynamic faceScan;
  dynamic loginProviderID;
  dynamic referredByID;
  dynamic honorificID;
  dynamic ethnicityID;
  String? firstName;
  String? middleName;
  String? lastName;
  String? displayName;
  String? genderID;
  String? dateOfBirth;
  String? email;
  String? emailVerified;
  String? mobile;
  String? mobileVerified;
  String? nationalityID;
  String? photo;
  dynamic idCard;
  dynamic publicKey;
  dynamic privateKey;
  dynamic secretKey;
  dynamic deregistered;
  dynamic blacklisted;
  String? activeFrom;
  dynamic activeUntil;
  dynamic enabled;
  dynamic createdOn;
  dynamic createdBy;
  dynamic modifiedOn;
  dynamic modifiedBy;

  User(
      {this.userID,
      this.userName,
      this.encodedPassword,
      this.fingerPrint,
      this.irisScan,
      this.faceScan,
      this.loginProviderID,
      this.referredByID,
      this.honorificID,
      this.ethnicityID,
      this.firstName,
      this.middleName,
      this.lastName,
      this.displayName,
      this.genderID,
      this.dateOfBirth,
      this.email,
      this.emailVerified,
      this.mobile,
      this.mobileVerified,
      this.nationalityID,
      this.photo,
      this.idCard,
      this.publicKey,
      this.privateKey,
      this.secretKey,
      this.deregistered,
      this.blacklisted,
      this.activeFrom,
      this.activeUntil,
      this.enabled,
      this.createdOn,
      this.createdBy,
      this.modifiedOn,
      this.modifiedBy});

  User.fromJson(Map<String, dynamic> json) {
    userID = json['userID'];
    userName = json['userName'];
    encodedPassword = json['encodedPassword'];
    fingerPrint = json['fingerPrint'];
    irisScan = json['irisScan'];
    faceScan = json['faceScan'];
    loginProviderID = json['loginProviderID'];
    referredByID = json['referredByID'];
    honorificID = json['honorificID'];
    ethnicityID = json['ethnicityID'];
    firstName = json['firstName'];
    middleName = json['middleName'];
    lastName = json['lastName'];
    displayName = json['displayName'];
    genderID = json['genderID'];
    dateOfBirth = json['dateOfBirth'];
    email = json['email'];
    emailVerified = json['emailVerified'];
    mobile = json['mobile'];
    mobileVerified = json['mobileVerified'];
    nationalityID = json['nationalityID'];
    photo = json['photo'];
    idCard = json['idCard'];
    publicKey = json['publicKey'];
    privateKey = json['privateKey'];
    secretKey = json['secretKey'];
    deregistered = json['deregistered'];
    blacklisted = json['blacklisted'];
    activeFrom = json['activeFrom'];
    activeUntil = json['activeUntil'];
    enabled = json['enabled'];
    createdOn = json['createdOn'];
    createdBy = json['createdBy'];
    modifiedOn = json['modifiedOn'];
    modifiedBy = json['modifiedBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userID'] = this.userID;
    data['userName'] = this.userName;
    data['encodedPassword'] = this.encodedPassword;
    data['fingerPrint'] = this.fingerPrint;
    data['irisScan'] = this.irisScan;
    data['faceScan'] = this.faceScan;
    data['loginProviderID'] = this.loginProviderID;
    data['referredByID'] = this.referredByID;
    data['honorificID'] = this.honorificID;
    data['ethnicityID'] = this.ethnicityID;
    data['firstName'] = this.firstName;
    data['middleName'] = this.middleName;
    data['lastName'] = this.lastName;
    data['displayName'] = this.displayName;
    data['genderID'] = this.genderID;
    data['dateOfBirth'] = this.dateOfBirth;
    data['email'] = this.email;
    data['emailVerified'] = this.emailVerified;
    data['mobile'] = this.mobile;
    data['mobileVerified'] = this.mobileVerified;
    data['nationalityID'] = this.nationalityID;
    data['photo'] = this.photo;
    data['idCard'] = this.idCard;
    data['publicKey'] = this.publicKey;
    data['privateKey'] = this.privateKey;
    data['secretKey'] = this.secretKey;
    data['deregistered'] = this.deregistered;
    data['blacklisted'] = this.blacklisted;
    data['activeFrom'] = this.activeFrom;
    data['activeUntil'] = this.activeUntil;
    data['enabled'] = this.enabled;
    data['createdOn'] = this.createdOn;
    data['createdBy'] = this.createdBy;
    data['modifiedOn'] = this.modifiedOn;
    data['modifiedBy'] = this.modifiedBy;
    return data;
  }
}
