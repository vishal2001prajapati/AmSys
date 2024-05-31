class AssertDetailRequest {
  String? assetID;

  AssertDetailRequest({this.assetID});

  AssertDetailRequest.fromJson(Map<String, dynamic> json) {
    assetID = json['assetID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['assetID'] = assetID;
    return data;
  }
}
