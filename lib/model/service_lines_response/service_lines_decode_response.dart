import 'dart:convert';

class ServiceLinesDecodeResponse {
  final List<ServiceLine> serviceLines;

  ServiceLinesDecodeResponse({required this.serviceLines});

  factory ServiceLinesDecodeResponse.fromJson(List<dynamic> json) {
    List<ServiceLine> serviceLines = json.map((e) => ServiceLine.fromJson(e)).toList();
    return ServiceLinesDecodeResponse(serviceLines: serviceLines);
  }
}

class ServiceLine {
  final String serviceLineID;
  final String name;
  final String meaning;

  ServiceLine({
    required this.serviceLineID,
    required this.name,
    required this.meaning,
  });

  factory ServiceLine.fromJson(Map<String, dynamic> json) {
    return ServiceLine(
      serviceLineID: json['serviceLineID'],
      name: json['name'],
      meaning: json['meaning'],
    );
  }

  static List<ServiceLine> fromDecodedJson(String decodedJson) {
    List<dynamic> jsonList = json.decode(decodedJson);
    return jsonList.map((json) => ServiceLine.fromJson(json)).toList();
  }
}
