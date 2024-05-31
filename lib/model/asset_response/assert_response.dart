import 'dart:convert';

class ParentAssetResponse {
  String assetID = '';
  String assetTypeName = '';
  String? assetTypeBrief;
  String? tagNumber;
  String? description;
  String? locationIDgroup;
  double? latitude;
  double? longitude;
  double? distanceInKM;
  String? photo;
  String? assetState;
  String? assetStateColorCode;

  ParentAssetResponse({
    this.assetID = '',
    this.assetTypeName = '',
    this.assetTypeBrief,
    this.tagNumber,
    this.description,
    this.locationIDgroup,
    this.latitude,
    this.longitude,
    this.distanceInKM,
    this.photo,
    this.assetState,
    this.assetStateColorCode,
  });

  ParentAssetResponse.fromJson(Map<String, dynamic> json) {
    assetID = json['assetID'];
    assetTypeName = json['assetTypeName'];
    assetTypeBrief = json['assetTypeBrief'];
    tagNumber = json['tagNumber'];
    description = json['description'];
    locationIDgroup = json['locationIDgroup'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    distanceInKM = json['distanceInKM'];
    photo = json['photo'];
    assetState = json['assetState'];
    assetStateColorCode = json['assetStateColorCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['assetID'] = this.assetID;
    data['assetTypeName'] = this.assetTypeName;
    data['assetTypeBrief'] = this.assetTypeBrief;
    data['tagNumber'] = this.tagNumber;
    data['description'] = this.description;
    data['locationIDgroup'] = this.locationIDgroup;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['distanceInKM'] = this.distanceInKM;
    data['photo'] = this.photo;
    data['assetState'] = this.assetState;
    data['assetStateColorCode'] = this.assetStateColorCode;
    return data;
  }

  static List<ParentAssetResponse> fromDecodedJson(String decodedJson) {
    List<dynamic> jsonList = json.decode(decodedJson);
    return jsonList.map((json) => ParentAssetResponse.fromJson(json)).toList();
  }
}
