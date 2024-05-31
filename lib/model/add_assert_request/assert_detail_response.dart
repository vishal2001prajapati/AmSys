import 'dart:convert';

AssertDetailResponse assertDetailResponseFromMap(String str) => AssertDetailResponse.fromMap(json.decode(str));

String assertDetailResponseToMap(AssertDetailResponse data) => json.encode(data.toMap());

class AssertDetailResponse {
  String? assetId;
  AssetType? assetType;
  dynamic parentAssetId;
  dynamic parentAssetType;
  dynamic parentAssetTagNumber;
  String? tagNumber;
  String? description;
  ServiceLine? serviceLine;
  Ner? owner;
  Contact? ownerContact;
  Ner? maintainer;
  dynamic maintainerContact;
  Location? location;
  dynamic floor;
  dynamic unit;
  String? assetOem;
  String? modelNumber;
  String? serialNumber;
  String? purchasePrice;
  PurchaseCurrency? purchaseCurrency;
  String? warranty;
  List<String>? photos;
  List<SparePart>? spareParts;
  List<Survey>? surveys;
  AssetState? assetState;
  List<AssetAttribute>? assetAttributes;
  DateTime? assetCreatedOn;
  EdBy? assetCreatedBy;

  AssertDetailResponse({
    this.assetId,
    this.assetType,
    this.parentAssetId,
    this.parentAssetType,
    this.parentAssetTagNumber,
    this.tagNumber,
    this.description,
    this.serviceLine,
    this.owner,
    this.ownerContact,
    this.maintainer,
    this.maintainerContact,
    this.location,
    this.floor,
    this.unit,
    this.assetOem,
    this.modelNumber,
    this.serialNumber,
    this.purchasePrice,
    this.purchaseCurrency,
    this.warranty,
    this.photos,
    this.spareParts,
    this.surveys,
    this.assetState,
    this.assetAttributes,
    this.assetCreatedOn,
    this.assetCreatedBy,
  });

  factory AssertDetailResponse.fromMap(Map<String, dynamic> json) => AssertDetailResponse(
        assetId: json["assetID"],
        assetType: json["assetType"] == null ? null : AssetType.fromMap(json["assetType"]),
        parentAssetId: json["parentAssetID"],
        parentAssetType: json["parentAssetType"],
        parentAssetTagNumber: json["parentAssetTagNumber"],
        tagNumber: json["tagNumber"],
        description: json["description"],
        serviceLine: json["serviceLine"] == null ? null : ServiceLine.fromMap(json["serviceLine"]),
        owner: json["owner"] == null ? null : Ner.fromMap(json["owner"]),
        ownerContact: json["ownerContact"] == null ? null : Contact.fromMap(json["ownerContact"]),
        maintainer: json["maintainer"] == null ? null : Ner.fromMap(json["maintainer"]),
        maintainerContact: json["maintainerContact"],
        location: json["location"] == null ? null : Location.fromMap(json["location"]),
        floor: json["floor"],
        unit: json["unit"],
        assetOem: json["assetOEM"],
        modelNumber: json["modelNumber"],
        serialNumber: json["serialNumber"],
        purchasePrice: json["purchasePrice"],
        purchaseCurrency: json["purchaseCurrency"] == null ? null : PurchaseCurrency.fromMap(json["purchaseCurrency"]),
        warranty: json["warranty"],
        photos: json["photos"] == null ? [] : List<String>.from(json["photos"]!.map((x) => x)),
        spareParts: json["spareParts"] == null ? [] : List<SparePart>.from(json["spareParts"]!.map((x) => SparePart.fromMap(x))),
        surveys: json["surveys"] == null ? [] : List<Survey>.from(json["surveys"]!.map((x) => Survey.fromMap(x))),
        assetState: json["assetState"] == null ? null : AssetState.fromMap(json["assetState"]),
        assetAttributes:
            json["assetAttributes"] == null ? [] : List<AssetAttribute>.from(json["assetAttributes"]!.map((x) => AssetAttribute.fromMap(x))),
        assetCreatedOn: json["assetCreatedOn"] == null ? null : DateTime.parse(json["assetCreatedOn"]),
        assetCreatedBy: json["assetCreatedBy"] == null ? null : EdBy.fromMap(json["assetCreatedBy"]),
      );

  Map<String, dynamic> toMap() => {
        "assetID": assetId,
        "assetType": assetType?.toMap(),
        "parentAssetID": parentAssetId,
        "parentAssetType": parentAssetType,
        "parentAssetTagNumber": parentAssetTagNumber,
        "tagNumber": tagNumber,
        "description": description,
        "serviceLine": serviceLine?.toMap(),
        "owner": owner?.toMap(),
        "ownerContact": ownerContact?.toMap(),
        "maintainer": maintainer?.toMap(),
        "maintainerContact": maintainerContact,
        "location": location?.toMap(),
        "floor": floor,
        "unit": unit,
        "assetOEM": assetOem,
        "modelNumber": modelNumber,
        "serialNumber": serialNumber,
        "purchasePrice": purchasePrice,
        "purchaseCurrency": purchaseCurrency?.toMap(),
        "warranty": warranty,
        "photos": photos == null ? [] : List<dynamic>.from(photos!.map((x) => x)),
        "spareParts": spareParts == null ? [] : List<dynamic>.from(spareParts!.map((x) => x.toMap())),
        "surveys": surveys == null ? [] : List<dynamic>.from(surveys!.map((x) => x.toMap())),
        "assetState": assetState?.toMap(),
        "assetAttributes": assetAttributes == null ? [] : List<dynamic>.from(assetAttributes!.map((x) => x.toMap())),
        "assetCreatedOn": assetCreatedOn?.toIso8601String(),
        "assetCreatedBy": assetCreatedBy?.toMap(),
      };
}

class AssetAttribute {
  String? assetAttributeId;
  String? assetAttributeValue;
  String? assetTypeAttributeId;
  String? assetTypeAttributeName;

  AssetAttribute({
    this.assetAttributeId,
    this.assetAttributeValue,
    this.assetTypeAttributeId,
    this.assetTypeAttributeName,
  });

  factory AssetAttribute.fromMap(Map<String, dynamic> json) => AssetAttribute(
        assetAttributeId: json["assetAttributeID"],
        assetAttributeValue: json["assetAttributeValue"],
        assetTypeAttributeId: json["assetTypeAttributeID"],
        assetTypeAttributeName: json["assetTypeAttributeName"],
      );

  Map<String, dynamic> toMap() => {
        "assetAttributeID": assetAttributeId,
        "assetAttributeValue": assetAttributeValue,
        "assetTypeAttributeID": assetTypeAttributeId,
        "assetTypeAttributeName": assetTypeAttributeName,
      };
}

class EdBy {
  dynamic userId;
  String? userName;
  dynamic encodedPassword;
  dynamic fingerPrint;
  dynamic irisScan;
  dynamic faceScan;
  dynamic loginProviderId;
  dynamic referredById;
  dynamic honorificId;
  dynamic ethnicityId;
  String? firstName;
  dynamic middleName;
  String? lastName;
  String? displayName;
  dynamic genderId;
  dynamic dateOfBirth;
  String? email;
  String? emailVerified;
  String? mobile;
  String? mobileVerified;
  dynamic nationalityId;
  String? photo;
  dynamic idCard;
  dynamic publicKey;
  dynamic privateKey;
  dynamic secretKey;
  dynamic deregistered;
  dynamic blacklisted;
  DateTime? activeFrom;
  dynamic activeUntil;
  dynamic enabled;
  dynamic createdOn;
  dynamic createdBy;
  dynamic modifiedOn;
  dynamic modifiedBy;

  EdBy({
    this.userId,
    this.userName,
    this.encodedPassword,
    this.fingerPrint,
    this.irisScan,
    this.faceScan,
    this.loginProviderId,
    this.referredById,
    this.honorificId,
    this.ethnicityId,
    this.firstName,
    this.middleName,
    this.lastName,
    this.displayName,
    this.genderId,
    this.dateOfBirth,
    this.email,
    this.emailVerified,
    this.mobile,
    this.mobileVerified,
    this.nationalityId,
    this.photo,
    this.idCard,
    this.publicKey,
    this.privateKey,
    this.secretKey,
    this.deregistered,
    this.blacklisted,
    this.activeFrom,
    this.activeUntil,
    this.enabled,
    this.createdOn,
    this.createdBy,
    this.modifiedOn,
    this.modifiedBy,
  });

  factory EdBy.fromMap(Map<String, dynamic> json) => EdBy(
        userId: json["userID"],
        userName: json["userName"],
        encodedPassword: json["encodedPassword"],
        fingerPrint: json["fingerPrint"],
        irisScan: json["irisScan"],
        faceScan: json["faceScan"],
        loginProviderId: json["loginProviderID"],
        referredById: json["referredByID"],
        honorificId: json["honorificID"],
        ethnicityId: json["ethnicityID"],
        firstName: json["firstName"],
        middleName: json["middleName"],
        lastName: json["lastName"],
        displayName: json["displayName"],
        genderId: json["genderID"],
        dateOfBirth: json["dateOfBirth"],
        email: json["email"],
        emailVerified: json["emailVerified"],
        mobile: json["mobile"],
        mobileVerified: json["mobileVerified"],
        nationalityId: json["nationalityID"],
        photo: json["photo"],
        idCard: json["idCard"],
        publicKey: json["publicKey"],
        privateKey: json["privateKey"],
        secretKey: json["secretKey"],
        deregistered: json["deregistered"],
        blacklisted: json["blacklisted"],
        activeFrom: json["activeFrom"] == null ? null : DateTime.parse(json["activeFrom"]),
        activeUntil: json["activeUntil"],
        enabled: json["enabled"],
        createdOn: json["createdOn"],
        createdBy: json["createdBy"],
        modifiedOn: json["modifiedOn"],
        modifiedBy: json["modifiedBy"],
      );

  Map<String, dynamic> toMap() => {
        "userID": userId,
        "userName": userName,
        "encodedPassword": encodedPassword,
        "fingerPrint": fingerPrint,
        "irisScan": irisScan,
        "faceScan": faceScan,
        "loginProviderID": loginProviderId,
        "referredByID": referredById,
        "honorificID": honorificId,
        "ethnicityID": ethnicityId,
        "firstName": firstName,
        "middleName": middleName,
        "lastName": lastName,
        "displayName": displayName,
        "genderID": genderId,
        "dateOfBirth": dateOfBirth,
        "email": email,
        "emailVerified": emailVerified,
        "mobile": mobile,
        "mobileVerified": mobileVerified,
        "nationalityID": nationalityId,
        "photo": photo,
        "idCard": idCard,
        "publicKey": publicKey,
        "privateKey": privateKey,
        "secretKey": secretKey,
        "deregistered": deregistered,
        "blacklisted": blacklisted,
        "activeFrom": activeFrom?.toIso8601String(),
        "activeUntil": activeUntil,
        "enabled": enabled,
        "createdOn": createdOn,
        "createdBy": createdBy,
        "modifiedOn": modifiedOn,
        "modifiedBy": modifiedBy,
      };
}

class AssetState {
  String? assetStateId;
  String? state;
  String? brief;
  String? colorCode;

  AssetState({
    this.assetStateId,
    this.state,
    this.brief,
    this.colorCode,
  });

  factory AssetState.fromMap(Map<String, dynamic> json) => AssetState(
        assetStateId: json["assetStateID"],
        state: json["state"],
        brief: json["brief"],
        colorCode: json["colorCode"],
      );

  Map<String, dynamic> toMap() => {
        "assetStateID": assetStateId,
        "state": state,
        "brief": brief,
        "colorCode": colorCode,
      };
}

class AssetType {
  String? assetTypeId;
  String? name;
  String? brief;
  List<AssetTypeAttribute>? assetTypeAttributes;

  AssetType({
    this.assetTypeId,
    this.name,
    this.brief,
    this.assetTypeAttributes,
  });

  factory AssetType.fromMap(Map<String, dynamic> json) => AssetType(
        assetTypeId: json["assetTypeID"],
        name: json["name"],
        brief: json["brief"],
        assetTypeAttributes: json["assetTypeAttributes"] == null
            ? []
            : List<AssetTypeAttribute>.from(json["assetTypeAttributes"]!.map((x) => AssetTypeAttribute.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "assetTypeID": assetTypeId,
        "name": name,
        "brief": brief,
        "assetTypeAttributes": assetTypeAttributes == null ? [] : List<dynamic>.from(assetTypeAttributes!.map((x) => x.toMap())),
      };
}

class AssetTypeAttribute {
  String? assetTypeAttributeId;
  String? attributeName;
  String? attributeValidation;
  AttributeDataType? attributeDataType;
  List<String>? lookups;
  int? displayOrder;

  AssetTypeAttribute({
    this.assetTypeAttributeId,
    this.attributeName,
    this.attributeValidation,
    this.attributeDataType,
    this.lookups,
    this.displayOrder,
  });

  factory AssetTypeAttribute.fromMap(Map<String, dynamic> json) => AssetTypeAttribute(
        assetTypeAttributeId: json["assetTypeAttributeID"],
        attributeName: json["attributeName"],
        attributeValidation: json["attributeValidation"],
        attributeDataType: json["attributeDataType"] == null ? null : AttributeDataType.fromMap(json["attributeDataType"]),
        lookups: json["lookups"] == null ? [] : List<String>.from(json["lookups"]!.map((x) => x)),
        displayOrder: json["displayOrder"],
      );

  Map<String, dynamic> toMap() => {
        "assetTypeAttributeID": assetTypeAttributeId,
        "attributeName": attributeName,
        "attributeValidation": attributeValidation,
        "attributeDataType": attributeDataType?.toMap(),
        "lookups": lookups == null ? [] : List<dynamic>.from(lookups!.map((x) => x)),
        "displayOrder": displayOrder,
      };
}

class AttributeDataType {
  String? datatypeId;
  String? name;
  String? meaning;

  AttributeDataType({
    this.datatypeId,
    this.name,
    this.meaning,
  });

  factory AttributeDataType.fromMap(Map<String, dynamic> json) => AttributeDataType(
        datatypeId: json["datatypeID"],
        name: json["name"],
        meaning: json["meaning"],
      );

  Map<String, dynamic> toMap() => {
        "datatypeID": datatypeId,
        "name": name,
        "meaning": meaning,
      };
}

class Location {
  String? locationId;
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
  double? distanceInKm;
  dynamic photos;

  Location({
    this.locationId,
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
    this.distanceInKm,
    this.photos,
  });

  factory Location.fromMap(Map<String, dynamic> json) => Location(
        locationId: json["locationID"],
        continent: json["continent"] == null ? null : Continent.fromMap(json["continent"]),
        country: json["country"] == null ? null : Country.fromMap(json["country"]),
        region: json["region"] == null ? null : Region.fromMap(json["region"]),
        subRegion: json["subRegion"] == null ? null : SubRegion.fromMap(json["subRegion"]),
        city: json["city"] == null ? null : City.fromMap(json["city"]),
        community: json["community"] == null ? null : Community.fromMap(json["community"]),
        subDivision: json["subDivision"] == null ? null : SubDivision.fromMap(json["subDivision"]),
        block: json["block"] == null ? null : Block.fromMap(json["block"]),
        locationType: json["locationType"] == null ? null : LocationType.fromMap(json["locationType"]),
        locationUsage: json["locationUsage"] == null ? null : LocationUsage.fromMap(json["locationUsage"]),
        name: json["name"],
        code: json["code"],
        longitude: json["longitude"]?.toDouble(),
        latitude: json["latitude"]?.toDouble(),
        distanceInKm: json["distanceInKM"]?.toDouble(),
        photos: json["photos"],
      );

  Map<String, dynamic> toMap() => {
        "locationID": locationId,
        "continent": continent?.toMap(),
        "country": country?.toMap(),
        "region": region?.toMap(),
        "subRegion": subRegion?.toMap(),
        "city": city?.toMap(),
        "community": community?.toMap(),
        "subDivision": subDivision?.toMap(),
        "block": block?.toMap(),
        "locationType": locationType?.toMap(),
        "locationUsage": locationUsage?.toMap(),
        "name": name,
        "code": code,
        "longitude": longitude,
        "latitude": latitude,
        "distanceInKM": distanceInKm,
        "photos": photos,
      };
}

class Block {
  dynamic blockId;
  dynamic subDivisionId;
  dynamic name;

  Block({
    this.blockId,
    this.subDivisionId,
    this.name,
  });

  factory Block.fromMap(Map<String, dynamic> json) => Block(
        blockId: json["blockID"],
        subDivisionId: json["subDivisionID"],
        name: json["name"],
      );

  Map<String, dynamic> toMap() => {
        "blockID": blockId,
        "subDivisionID": subDivisionId,
        "name": name,
      };
}

class City {
  String? cityId;
  dynamic regionId;
  dynamic subRegionId;
  String? name;
  dynamic isoCode;
  dynamic image;
  dynamic timeZone;

  City({
    this.cityId,
    this.regionId,
    this.subRegionId,
    this.name,
    this.isoCode,
    this.image,
    this.timeZone,
  });

  factory City.fromMap(Map<String, dynamic> json) => City(
        cityId: json["cityID"],
        regionId: json["regionID"],
        subRegionId: json["subRegionID"],
        name: json["name"],
        isoCode: json["isoCode"],
        image: json["image"],
        timeZone: json["timeZone"],
      );

  Map<String, dynamic> toMap() => {
        "cityID": cityId,
        "regionID": regionId,
        "subRegionID": subRegionId,
        "name": name,
        "isoCode": isoCode,
        "image": image,
        "timeZone": timeZone,
      };
}

class Community {
  dynamic communityId;
  dynamic cityId;
  dynamic name;

  Community({
    this.communityId,
    this.cityId,
    this.name,
  });

  factory Community.fromMap(Map<String, dynamic> json) => Community(
        communityId: json["communityID"],
        cityId: json["cityID"],
        name: json["name"],
      );

  Map<String, dynamic> toMap() => {
        "communityID": communityId,
        "cityID": cityId,
        "name": name,
      };
}

class Continent {
  String? continentId;
  String? continent;
  dynamic isoCode;
  dynamic map;

  Continent({
    this.continentId,
    this.continent,
    this.isoCode,
    this.map,
  });

  factory Continent.fromMap(Map<String, dynamic> json) => Continent(
        continentId: json["continentID"],
        continent: json["continent"],
        isoCode: json["isoCode"],
        map: json["map"],
      );

  Map<String, dynamic> toMap() => {
        "continentID": continentId,
        "continent": continent,
        "isoCode": isoCode,
        "map": map,
      };
}

class Country {
  String? countryId;
  dynamic continentId;
  String? name;
  dynamic nationality;
  String? regionType;
  dynamic subRegionType;
  dynamic isoCode3D;
  dynamic isoCode2D;
  dynamic iddCode;
  dynamic primaryLanguageId;
  dynamic primaryCurrencyId;
  dynamic flag;

  Country({
    this.countryId,
    this.continentId,
    this.name,
    this.nationality,
    this.regionType,
    this.subRegionType,
    this.isoCode3D,
    this.isoCode2D,
    this.iddCode,
    this.primaryLanguageId,
    this.primaryCurrencyId,
    this.flag,
  });

  factory Country.fromMap(Map<String, dynamic> json) => Country(
        countryId: json["countryID"],
        continentId: json["continentID"],
        name: json["name"],
        nationality: json["nationality"],
        regionType: json["regionType"],
        subRegionType: json["subRegionType"],
        isoCode3D: json["isoCode3D"],
        isoCode2D: json["isoCode2D"],
        iddCode: json["iddCode"],
        primaryLanguageId: json["primaryLanguageID"],
        primaryCurrencyId: json["primaryCurrencyID"],
        flag: json["flag"],
      );

  Map<String, dynamic> toMap() => {
        "countryID": countryId,
        "continentID": continentId,
        "name": name,
        "nationality": nationality,
        "regionType": regionType,
        "subRegionType": subRegionType,
        "isoCode3D": isoCode3D,
        "isoCode2D": isoCode2D,
        "iddCode": iddCode,
        "primaryLanguageID": primaryLanguageId,
        "primaryCurrencyID": primaryCurrencyId,
        "flag": flag,
      };
}

class LocationType {
  String? locationTypeId;
  String? name;
  dynamic meaning;

  LocationType({
    this.locationTypeId,
    this.name,
    this.meaning,
  });

  factory LocationType.fromMap(Map<String, dynamic> json) => LocationType(
        locationTypeId: json["locationTypeID"],
        name: json["name"],
        meaning: json["meaning"],
      );

  Map<String, dynamic> toMap() => {
        "locationTypeID": locationTypeId,
        "name": name,
        "meaning": meaning,
      };
}

class LocationUsage {
  String? locationUsageId;
  String? name;
  dynamic meaning;

  LocationUsage({
    this.locationUsageId,
    this.name,
    this.meaning,
  });

  factory LocationUsage.fromMap(Map<String, dynamic> json) => LocationUsage(
        locationUsageId: json["locationUsageID"],
        name: json["name"],
        meaning: json["meaning"],
      );

  Map<String, dynamic> toMap() => {
        "locationUsageID": locationUsageId,
        "name": name,
        "meaning": meaning,
      };
}

class Region {
  dynamic regionId;
  dynamic countryId;
  dynamic name;
  dynamic isoCode;

  Region({
    this.regionId,
    this.countryId,
    this.name,
    this.isoCode,
  });

  factory Region.fromMap(Map<String, dynamic> json) => Region(
        regionId: json["regionID"],
        countryId: json["countryID"],
        name: json["name"],
        isoCode: json["isoCode"],
      );

  Map<String, dynamic> toMap() => {
        "regionID": regionId,
        "countryID": countryId,
        "name": name,
        "isoCode": isoCode,
      };
}

class SubDivision {
  dynamic subDivisionId;
  dynamic communityId;
  dynamic name;

  SubDivision({
    this.subDivisionId,
    this.communityId,
    this.name,
  });

  factory SubDivision.fromMap(Map<String, dynamic> json) => SubDivision(
        subDivisionId: json["subDivisionID"],
        communityId: json["communityID"],
        name: json["name"],
      );

  Map<String, dynamic> toMap() => {
        "subDivisionID": subDivisionId,
        "communityID": communityId,
        "name": name,
      };
}

class SubRegion {
  dynamic subRegionId;
  dynamic regionId;
  dynamic name;

  SubRegion({
    this.subRegionId,
    this.regionId,
    this.name,
  });

  factory SubRegion.fromMap(Map<String, dynamic> json) => SubRegion(
        subRegionId: json["subRegionID"],
        regionId: json["regionID"],
        name: json["name"],
      );

  Map<String, dynamic> toMap() => {
        "subRegionID": subRegionId,
        "regionID": regionId,
        "name": name,
      };
}

class Ner {
  String? organizationId;
  String? name;
  String? address;
  City? city;
  String? phone;
  String? email;
  Contact? personContact;
  String? logo;

  Ner({
    this.organizationId,
    this.name,
    this.address,
    this.city,
    this.phone,
    this.email,
    this.personContact,
    this.logo,
  });

  factory Ner.fromMap(Map<String, dynamic> json) => Ner(
        organizationId: json["organizationID"],
        name: json["name"],
        address: json["address"],
        city: json["city"] == null ? null : City.fromMap(json["city"]),
        phone: json["phone"],
        email: json["email"],
        personContact: json["personContact"] == null ? null : Contact.fromMap(json["personContact"]),
        logo: json["logo"],
      );

  Map<String, dynamic> toMap() => {
        "organizationID": organizationId,
        "name": name,
        "address": address,
        "city": city?.toMap(),
        "phone": phone,
        "email": email,
        "personContact": personContact?.toMap(),
        "logo": logo,
      };
}

class Contact {
  String? personId;
  String? firstName;
  String? lastName;
  String? mobile;
  String? email;
  String? photo;

  Contact({
    this.personId,
    this.firstName,
    this.lastName,
    this.mobile,
    this.email,
    this.photo,
  });

  factory Contact.fromMap(Map<String, dynamic> json) => Contact(
        personId: json["personID"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        mobile: json["mobile"],
        email: json["email"],
        photo: json["photo"],
      );

  Map<String, dynamic> toMap() => {
        "personID": personId,
        "firstName": firstName,
        "lastName": lastName,
        "mobile": mobile,
        "email": email,
        "photo": photo,
      };
}

class PurchaseCurrency {
  String? currencyId;
  String? name;
  String? isoCode;

  PurchaseCurrency({
    this.currencyId,
    this.name,
    this.isoCode,
  });

  factory PurchaseCurrency.fromMap(Map<String, dynamic> json) => PurchaseCurrency(
        currencyId: json["currencyID"],
        name: json["name"],
        isoCode: json["isoCode"],
      );

  Map<String, dynamic> toMap() => {
        "currencyID": currencyId,
        "name": name,
        "isoCode": isoCode,
      };
}

class ServiceLine {
  String? serviceLineId;
  String? name;
  String? meaning;

  ServiceLine({
    this.serviceLineId,
    this.name,
    this.meaning,
  });

  factory ServiceLine.fromMap(Map<String, dynamic> json) => ServiceLine(
        serviceLineId: json["serviceLineID"],
        name: json["name"],
        meaning: json["meaning"],
      );

  Map<String, dynamic> toMap() => {
        "serviceLineID": serviceLineId,
        "name": name,
        "meaning": meaning,
      };
}

class SparePart {
  String? sparePartId;
  String? partNumber;
  String? partName;
  dynamic photo;

  SparePart({
    this.sparePartId,
    this.partNumber,
    this.partName,
    this.photo,
  });

  factory SparePart.fromMap(Map<String, dynamic> json) => SparePart(
        sparePartId: json["sparePartID"],
        partNumber: json["partNumber"],
        partName: json["partName"],
        photo: json["photo"],
      );

  Map<String, dynamic> toMap() => {
        "sparePartID": sparePartId,
        "partNumber": partNumber,
        "partName": partName,
        "photo": photo,
      };
}

class Survey {
  AssetState? assetState;
  String? comments;
  DateTime? surveyedOn;
  EdBy? surveyedBy;

  Survey({
    this.assetState,
    this.comments,
    this.surveyedOn,
    this.surveyedBy,
  });

  factory Survey.fromMap(Map<String, dynamic> json) => Survey(
        assetState: json["assetState"] == null ? null : AssetState.fromMap(json["assetState"]),
        comments: json["comments"],
        surveyedOn: json["surveyedOn"] == null ? null : DateTime.parse(json["surveyedOn"]),
        surveyedBy: json["surveyedBy"] == null ? null : EdBy.fromMap(json["surveyedBy"]),
      );

  Map<String, dynamic> toMap() => {
        "assetState": assetState?.toMap(),
        "comments": comments,
        "surveyedOn": surveyedOn?.toIso8601String(),
        "surveyedBy": surveyedBy?.toMap(),
      };
}
