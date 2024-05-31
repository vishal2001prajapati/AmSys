class AddAssetsDecodedRequest {
  String? inputParameters;

  AddAssetsDecodedRequest({this.inputParameters});

  AddAssetsDecodedRequest.fromJson(Map<String, dynamic> json) {
    inputParameters = json['inputParameters'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['inputParameters'] = inputParameters;
    return data;
  }
}
