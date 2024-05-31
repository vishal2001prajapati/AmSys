class AssetStatesDecodeData {
  final String assetStateID;
  final String state;
  final String brief;
  final String colorCode;

  AssetStatesDecodeData({
    required this.assetStateID,
    required this.state,
    required this.brief,
    required this.colorCode,
  });

  factory AssetStatesDecodeData.fromJson(Map<String, dynamic> json) {
    return AssetStatesDecodeData(
      assetStateID: json['assetStateID'] ?? '',
      state: json['state'] ?? '',
      brief: json['brief'] ?? '',
      colorCode: json['colorCode'] ?? '',
    );
  }
}
