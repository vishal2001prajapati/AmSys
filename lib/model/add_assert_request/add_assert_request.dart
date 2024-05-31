import 'package:image_picker/image_picker.dart';

class AddAssetsRequest {
  String? assetTypeID;
  String? tagNumber;
  String? description;
  String? serviceLineID;
  String? ownerOrgID;
  String? ownerContactID;
  String? maintainerOrgID;
  Location? location;
  String? currencyID;
  String? assetOEM;
  String? modelNumber;
  String? serialNumber;
  String? purchasePrice;
  String? warranty;
  String? locationID;
  List<String>? assetPhotos;
  List<SpareParts>? spareParts;
  String? assetStateID;
  String? assetStateComments;
  List<AssetAttributes>? assetAttributes;

  AddAssetsRequest(
      {this.assetTypeID,
      this.tagNumber,
      this.description,
      this.serviceLineID,
      this.ownerOrgID,
      this.ownerContactID,
      this.maintainerOrgID,
      this.location,
      this.currencyID,
      this.assetOEM,
      this.modelNumber,
      this.serialNumber,
      this.purchasePrice,
      this.warranty,
      this.assetPhotos,
      this.spareParts,
      this.assetStateID,
      this.assetStateComments,
      this.assetAttributes,
      this.locationID});

  AddAssetsRequest.fromJson(Map<String, dynamic> json) {
    assetTypeID = json['assetTypeID'];
    locationID = json['locationID'];
    tagNumber = json['tagNumber'];
    description = json['description'];
    serviceLineID = json['serviceLineID'];
    ownerOrgID = json['ownerOrgID'];
    ownerContactID = json['ownerContactID'];
    maintainerOrgID = json['maintainerOrgID'];
    location = json['location'] != null ? new Location.fromJson(json['location']) : null;
    currencyID = json['currencyID'];
    assetOEM = json['assetOEM'];
    modelNumber = json['modelNumber'];
    serialNumber = json['serialNumber'];
    purchasePrice = json['purchasePrice'];
    warranty = json['warranty'];
    assetPhotos = json['assetPhotos'].cast<String>();
    if (json['spareParts'] != null) {
      spareParts = <SpareParts>[];
      json['spareParts'].forEach((v) {
        spareParts!.add(new SpareParts.fromJson(v));
      });
    }
    assetStateID = json['assetStateID'];
    assetStateComments = json['assetStateComments'];
    if (json['assetAttributes'] != null) {
      assetAttributes = <AssetAttributes>[];
      json['assetAttributes'].forEach((v) {
        assetAttributes!.add(new AssetAttributes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['assetTypeID'] = this.assetTypeID;
    data['locationID'] = this.locationID;
    data['tagNumber'] = this.tagNumber;
    data['description'] = this.description;
    data['serviceLineID'] = this.serviceLineID;
    data['ownerOrgID'] = this.ownerOrgID;
    data['ownerContactID'] = this.ownerContactID;
    data['maintainerOrgID'] = this.maintainerOrgID;
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    data['currencyID'] = this.currencyID;
    data['assetOEM'] = this.assetOEM;
    data['modelNumber'] = this.modelNumber;
    data['serialNumber'] = this.serialNumber;
    data['purchasePrice'] = this.purchasePrice;
    data['warranty'] = this.warranty;
    data['assetPhotos'] = this.assetPhotos;
    if (this.spareParts != null) {
      data['spareParts'] = this.spareParts!.map((v) => v.toJson()).toList();
    }
    data['assetStateID'] = this.assetStateID;
    data['assetStateComments'] = this.assetStateComments;
    if (this.assetAttributes != null) {
      data['assetAttributes'] = this.assetAttributes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Location {
  String? locationTypeID;
  String? locationUsageID;
  String? continentID;
  String? countryID;
  GeoLoc? geoLoc;

  Location({this.locationTypeID, this.locationUsageID, this.continentID, this.countryID, this.geoLoc});

  Location.fromJson(Map<String, dynamic> json) {
    locationTypeID = json['locationTypeID'];
    locationUsageID = json['locationUsageID'];
    continentID = json['continentID'];
    countryID = json['countryID'];
    geoLoc = json['geoLoc'] != null ? GeoLoc.fromJson(json['geoLoc']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['locationTypeID'] = this.locationTypeID;
    data['locationUsageID'] = this.locationUsageID;
    data['continentID'] = this.continentID;
    data['countryID'] = this.countryID;
    if (this.geoLoc != null) {
      data['geoLoc'] = this.geoLoc!.toJson();
    }
    return data;
  }
}

class GeoLoc {
  String? posLat;
  String? posLong;

  GeoLoc({this.posLat, this.posLong});

  GeoLoc.fromJson(Map<String, dynamic> json) {
    posLat = json['posLat'];
    posLong = json['posLong'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['posLat'] = this.posLat;
    data['posLong'] = this.posLong;
    return data;
  }
}

class SpareParts {
  String? partNumber;
  String? partName;
  String? partPhoto;

  SpareParts({
    this.partNumber,
    this.partName,
    this.partPhoto,
  });

  SpareParts.fromJson(Map<String, dynamic> json) {
    partNumber = json['partNumber'];
    partName = json['partName'];
    partPhoto = json['partPhoto'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['partNumber'] = this.partNumber;
    data['partName'] = this.partName;
    data['partPhoto'] = this.partPhoto;
    return data;
  }
}

class AssetAttributes {
  String? assetTypeAttributeID;
  String? attributeValue;

  AssetAttributes({this.assetTypeAttributeID, this.attributeValue});

  AssetAttributes.fromJson(Map<String, dynamic> json) {
    assetTypeAttributeID = json['assetTypeAttributeID'];
    attributeValue = json['attributeValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['assetTypeAttributeID'] = this.assetTypeAttributeID;
    data['attributeValue'] = this.attributeValue;
    return data;
  }
}
