import 'dart:convert';

class CurrenciesDecodeData {
  final String currencyID;
  final String name;
  final String isoCode;
  String? selectedValue;

  CurrenciesDecodeData({
    required this.currencyID,
    required this.name,
    required this.isoCode,
    this.selectedValue,
  });

  factory CurrenciesDecodeData.fromJson(Map<String, dynamic> json) {
    return CurrenciesDecodeData(
      currencyID: json['currencyID'] ?? "",
      name: json['name'] ?? "",
      isoCode: json['isoCode'] ?? "",
    );
  }

  static List<CurrenciesDecodeData> fromDecodedJson(String decodedJson) {
    List<dynamic> jsonList = json.decode(decodedJson);
    return jsonList.map((json) => CurrenciesDecodeData.fromJson(json)).toList();
  }
}
