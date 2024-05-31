// import 'dart:convert';
//
// UpdateAssetStateRequest updateAssetStateRequestFromMap(String str) => UpdateAssetStateRequest.fromMap(json.decode(str));
//
// String updateAssetStateRequestToMap(UpdateAssetStateRequest data) => json.encode(data.toMap());
//
// class UpdateAssetStateRequest {
//   String? inputParameters;
//
//   UpdateAssetStateRequest({
//     this.inputParameters,
//   });
//
//   factory UpdateAssetStateRequest.fromMap(Map<String, dynamic> json) => UpdateAssetStateRequest(
//         inputParameters: json["inputParameters"],
//       );
//
//   Map<String, dynamic> toMap() => {
//         "inputParameters": inputParameters,
//       };
// }

class UpdateAssetStateRequest {
  String? inputParameters;

  UpdateAssetStateRequest({this.inputParameters});

  UpdateAssetStateRequest.fromJson(Map<String, dynamic> json) {
    inputParameters = json['inputParameters'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['inputParameters'] = inputParameters;
    return data;
  }
}
