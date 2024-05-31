import 'dart:convert';

class LocationUsageDropDownData {
  String locationUsageID;
  String name;
  String meaning;

  LocationUsageDropDownData({
    required this.locationUsageID,
    required this.name,
    required this.meaning,
  });

  LocationUsageDropDownData.fromJson(Map<String, dynamic> json)
      : locationUsageID = json['locationUsageID'],
        name = json['name'],
        meaning = json['meaning'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['locationUsageID'] = locationUsageID;
    data['name'] = name;
    data['meaning'] = meaning;
    return data;
  }

  static List<LocationUsageDropDownData> fromDecodedJson(String decodedJson) {
    List<dynamic> jsonList = json.decode(decodedJson);
    return jsonList.map((json) => LocationUsageDropDownData.fromJson(json)).toList();
  }
}
