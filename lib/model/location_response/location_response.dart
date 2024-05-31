import 'dart:convert';

class LocationResponse {
  String? locationID;
  Continent? continent;
  Country? country;
  Region? region;
  SubRegion? subRegion;
  City? city;
  Community? community;
  SubDivision? subDivision;
  Block? block;
  LocationType? locationType;
  LocationUsage? locationUsage;
  String? name;
  String? code;
  double? longitude;
  double? latitude;
  double? distanceInKM;
  String? photos;

  LocationResponse({
    this.locationID,
    this.continent,
    this.country,
    this.region,
    this.subRegion,
    this.city,
    this.community,
    this.subDivision,
    this.block,
    this.locationType,
    this.locationUsage,
    this.name,
    this.code,
    this.longitude,
    this.latitude,
    this.distanceInKM,
    this.photos,
  });

  LocationResponse.fromJson(Map<String, dynamic> json) {
    locationID = json['locationID'];
    continent = json['continent'] != null ? Continent.fromJson(json['continent']) : null;
    country = json['country'] != null ? Country.fromJson(json['country']) : null;
    region = json['region'] != null ? Region.fromJson(json['region']) : null;
    subRegion = json['subRegion'] != null ? SubRegion.fromJson(json['subRegion']) : null;
    city = json['city'] != null ? City.fromJson(json['city']) : null;
    community = json['community'] != null ? Community.fromJson(json['community']) : null;
    subDivision = json['subDivision'] != null ? SubDivision.fromJson(json['subDivision']) : null;
    block = json['block'] != null ? Block.fromJson(json['block']) : null;
    locationType = json['locationType'] != null ? LocationType.fromJson(json['locationType']) : null;
    locationUsage = json['locationUsage'] != null ? LocationUsage.fromJson(json['locationUsage']) : null;
    name = json['name'];
    code = json['code'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    distanceInKM = json['distanceInKM'];
    photos = json['photos'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['locationID'] = locationID;
    if (continent != null) {
      data['continent'] = continent!.toJson();
    }
    if (country != null) {
      data['country'] = country!.toJson();
    }
    if (region != null) {
      data['region'] = region!.toJson();
    }
    if (subRegion != null) {
      data['subRegion'] = subRegion!.toJson();
    }
    if (city != null) {
      data['city'] = city!.toJson();
    }
    if (community != null) {
      data['community'] = community!.toJson();
    }
    if (subDivision != null) {
      data['subDivision'] = subDivision!.toJson();
    }
    if (block != null) {
      data['block'] = block!.toJson();
    }
    if (locationType != null) {
      data['locationType'] = locationType!.toJson();
    }
    if (locationUsage != null) {
      data['locationUsage'] = locationUsage!.toJson();
    }
    data['name'] = name;
    data['code'] = code;
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    data['distanceInKM'] = distanceInKM;
    data['photos'] = photos;
    return data;
  }


  static List<LocationResponse> fromDecodedJson(String decodedJson) {
    List<dynamic> jsonList = json.decode(decodedJson);
    return jsonList.map((json) => LocationResponse.fromJson(json)).toList();
  }
}

class Continent {
  String? continentID;
  String? continent;
  dynamic isoCode;
  dynamic map;

  Continent({this.continentID, this.continent, this.isoCode, this.map});

  Continent.fromJson(Map<String, dynamic> json) {
    continentID = json['continentID'];
    continent = json['continent'];
    isoCode = json['isoCode'];
    map = json['map'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['continentID'] = continentID;
    data['continent'] = continent;
    data['isoCode'] = isoCode;
    data['map'] = map;
    return data;
  }
}

class Country {
  String? countryID;
  dynamic continentID;
  String? name;
  dynamic nationality;
  String? regionType;
  dynamic subRegionType;
  dynamic isoCode3D;
  dynamic isoCode2D;
  dynamic iddCode;
  dynamic primaryLanguageID;
  dynamic primaryCurrencyID;
  dynamic flag;

  Country(
      {this.countryID,
      this.continentID,
      this.name,
      this.nationality,
      this.regionType,
      this.subRegionType,
      this.isoCode3D,
      this.isoCode2D,
      this.iddCode,
      this.primaryLanguageID,
      this.primaryCurrencyID,
      this.flag});

  Country.fromJson(Map<String, dynamic> json) {
    countryID = json['countryID'];
    continentID = json['continentID'];
    name = json['name'];
    nationality = json['nationality'];
    regionType = json['regionType'];
    subRegionType = json['subRegionType'];
    isoCode3D = json['isoCode3D'];
    isoCode2D = json['isoCode2D'];
    iddCode = json['iddCode'];
    primaryLanguageID = json['primaryLanguageID'];
    primaryCurrencyID = json['primaryCurrencyID'];
    flag = json['flag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['countryID'] = countryID;
    data['continentID'] = continentID;
    data['name'] = name;
    data['nationality'] = nationality;
    data['regionType'] = regionType;
    data['subRegionType'] = subRegionType;
    data['isoCode3D'] = isoCode3D;
    data['isoCode2D'] = isoCode2D;
    data['iddCode'] = iddCode;
    data['primaryLanguageID'] = primaryLanguageID;
    data['primaryCurrencyID'] = primaryCurrencyID;
    data['flag'] = flag;
    return data;
  }
}

class Region {
  dynamic regionID;
  dynamic countryID;
  dynamic name;
  dynamic isoCode;

  Region({this.regionID, this.countryID, this.name, this.isoCode});

  Region.fromJson(Map<String, dynamic> json) {
    regionID = json['regionID'];
    countryID = json['countryID'];
    name = json['name'];
    isoCode = json['isoCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['regionID'] = regionID;
    data['countryID'] = countryID;
    data['name'] = name;
    data['isoCode'] = isoCode;
    return data;
  }
}

class SubRegion {
  dynamic subRegionID;
  dynamic regionID;
  dynamic name;

  SubRegion({this.subRegionID, this.regionID, this.name});

  SubRegion.fromJson(Map<String, dynamic> json) {
    subRegionID = json['subRegionID'];
    regionID = json['regionID'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['subRegionID'] = subRegionID;
    data['regionID'] = regionID;
    data['name'] = name;
    return data;
  }
}

class City {
  dynamic cityID;
  dynamic regionID;
  dynamic subRegionID;
  dynamic name;
  dynamic isoCode;
  dynamic image;
  dynamic timeZone;

  City({this.cityID, this.regionID, this.subRegionID, this.name, this.isoCode, this.image, this.timeZone});

  City.fromJson(Map<String, dynamic> json) {
    cityID = json['cityID'];
    regionID = json['regionID'];
    subRegionID = json['subRegionID'];
    name = json['name'];
    isoCode = json['isoCode'];
    image = json['image'];
    timeZone = json['timeZone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cityID'] = cityID;
    data['regionID'] = regionID;
    data['subRegionID'] = subRegionID;
    data['name'] = name;
    data['isoCode'] = isoCode;
    data['image'] = image;
    data['timeZone'] = timeZone;
    return data;
  }
}

class Community {
  dynamic communityID;
  dynamic cityID;
  dynamic name;

  Community({this.communityID, this.cityID, this.name});

  Community.fromJson(Map<String, dynamic> json) {
    communityID = json['communityID'];
    cityID = json['cityID'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['communityID'] = communityID;
    data['cityID'] = cityID;
    data['name'] = name;
    return data;
  }
}

class SubDivision {
  dynamic subDivisionID;
  dynamic communityID;
  dynamic name;

  SubDivision({this.subDivisionID, this.communityID, this.name});

  SubDivision.fromJson(Map<String, dynamic> json) {
    subDivisionID = json['subDivisionID'];
    communityID = json['communityID'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['subDivisionID'] = subDivisionID;
    data['communityID'] = communityID;
    data['name'] = name;
    return data;
  }
}

class Block {
  dynamic blockID;
  dynamic subDivisionID;
  dynamic name;

  Block({this.blockID, this.subDivisionID, this.name});

  Block.fromJson(Map<String, dynamic> json) {
    blockID = json['blockID'];
    subDivisionID = json['subDivisionID'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['blockID'] = blockID;
    data['subDivisionID'] = subDivisionID;
    data['name'] = name;
    return data;
  }
}

class LocationType {
  String? locationTypeID;
  String? name;
  dynamic meaning;

  LocationType({this.locationTypeID, this.name, this.meaning});

  LocationType.fromJson(Map<String, dynamic> json) {
    locationTypeID = json['locationTypeID'];
    name = json['name'];
    meaning = json['meaning'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['locationTypeID'] = locationTypeID;
    data['name'] = name;
    data['meaning'] = meaning;
    return data;
  }
}

class LocationUsage {
  String? locationUsageID;
  String? name;
  dynamic meaning;

  LocationUsage({this.locationUsageID, this.name, this.meaning});

  LocationUsage.fromJson(Map<String, dynamic> json) {
    locationUsageID = json['locationUsageID'];
    name = json['name'];
    meaning = json['meaning'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['locationUsageID'] = locationUsageID;
    data['name'] = name;
    data['meaning'] = meaning;
    return data;
  }
}
