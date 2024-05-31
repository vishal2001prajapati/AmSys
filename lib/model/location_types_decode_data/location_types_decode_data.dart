import 'dart:convert';

class LocationTypesDecodeData {
  final String locationTypeID;
  final String name;
  final String meaning;

  LocationTypesDecodeData({
    required this.locationTypeID,
    required this.name,
    required this.meaning,
  });

  factory LocationTypesDecodeData.fromJson(Map<String, dynamic> json) {
    return LocationTypesDecodeData(
      locationTypeID: json['locationTypeID'],
      name: json['name'],
      meaning: json['meaning'],
    );
  }

  static List<LocationTypesDecodeData> fromDecodedJson(String decodedJson) {
    List<dynamic> jsonList = json.decode(decodedJson);
    return jsonList.map((json) => LocationTypesDecodeData.fromJson(json)).toList();
  }
}
