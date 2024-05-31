import 'dart:convert';

class PersonsDecodeData {
  final String personID;
  final String firstName;
  final String lastName;
  final String mobile;
  final String email;
  final String photo;

  PersonsDecodeData({
    required this.personID,
    required this.firstName,
    required this.lastName,
    required this.mobile,
    required this.email,
    required this.photo,
  });

  factory PersonsDecodeData.fromJson(Map<String, dynamic> json) {
    return PersonsDecodeData(
      personID: json['personID'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      mobile: json['mobile'],
      email: json['email'],
      photo: json['photo'],
    );
  }

  static List<PersonsDecodeData> fromDecodedJson(String decodedJson) {
    List<dynamic> jsonList = jsonDecode(decodedJson);
    return jsonList.map((json) => PersonsDecodeData.fromJson(json)).toList();
  }

}

// static List<PersonsDecodeData> parseJson(String jsonStr) {
// final jsonData = json.decode(jsonStr) as List<dynamic>;
// return jsonData.map((item) => PersonsDecodeData.fromJson(item)).toList();
// }