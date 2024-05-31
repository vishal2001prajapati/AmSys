class AssetTypeDecodedResponse {
  List<AssetType> assets;

  AssetTypeDecodedResponse({required this.assets});

  factory AssetTypeDecodedResponse.fromJson(List<dynamic> json) {
    List<AssetType> assets = json.map((assetJson) => AssetType.fromJson(assetJson)).toList();
    return AssetTypeDecodedResponse(assets: assets);
  }
}

class AssetType {
  String assetTypeID;
  String name;
  String brief;
  List<AssetTypeAttribute> assetTypeAttributes;

  AssetType({
    required this.assetTypeID,
    required this.name,
    required this.brief,
    required this.assetTypeAttributes,
  });

  factory AssetType.fromJson(Map<String, dynamic> json) {
    List<dynamic> attributesJson = json['assetTypeAttributes'];
    List<AssetTypeAttribute> attributes =
    attributesJson.map((attrJson) => AssetTypeAttribute.fromJson(attrJson)).toList();

    return AssetType(
      assetTypeID: json['assetTypeID'],
      name: json['name'],
      brief: json['brief'],
      assetTypeAttributes: attributes,
    );
  }
}

class AssetTypeAttribute {
  String assetTypeAttributeID;
  String attributeName;
  String attributeValidation;
  AttributeDataType attributeDataType;
  List<String>? lookups;
  int displayOrder;
  String? selectedValue;

  AssetTypeAttribute({
    required this.assetTypeAttributeID,
    required this.attributeName,
    required this.attributeValidation,
    required this.attributeDataType,
    this.lookups,
    required this.displayOrder,
    this.selectedValue
  });

  factory AssetTypeAttribute.fromJson(Map<String, dynamic> json) {
    List<String>? lookups = json['lookups'] != null ? List<String>.from(json['lookups']) : null;
    return AssetTypeAttribute(
      assetTypeAttributeID: json['assetTypeAttributeID'],
      attributeName: json['attributeName'],
      attributeValidation: json['attributeValidation'],
      attributeDataType: AttributeDataType.fromJson(json['attributeDataType']),
      lookups: lookups,
      displayOrder: json['displayOrder'],
    );
  }
}

class AttributeDataType {
  String datatypeID;
  String name;
  String meaning;

  AttributeDataType({
    required this.datatypeID,
    required this.name,
    required this.meaning,
  });

  factory AttributeDataType.fromJson(Map<String, dynamic> json) {
    return AttributeDataType(
      datatypeID: json['datatypeID'],
      name: json['name'],
      meaning: json['meaning'],
    );
  }
}