import 'dart:convert';

class OrganizationsDecodeData {
  List<Organization> organizations;

  OrganizationsDecodeData({required this.organizations});

  factory OrganizationsDecodeData.fromJson(List<dynamic> json) {
    List<Organization> organizations = json.map((e) => Organization.fromJson(e)).toList();
    return OrganizationsDecodeData(organizations: organizations);
  }
}

class Organization {
  String organizationID;
  String name;
  String address;
  City city;
  String phone;
  String email;
  PersonContact personContact;
  String logo;

  Organization({
    required this.organizationID,
    required this.name,
    required this.address,
    required this.city,
    required this.phone,
    required this.email,
    required this.personContact,
    required this.logo,
  });

  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization(
      organizationID: json['organizationID'],
      name: json['name'],
      address: json['address'],
      city: City.fromJson(json['city']),
      phone: json['phone'],
      email: json['email'],
      personContact: PersonContact.fromJson(json['personContact']),
      logo: json['logo'],
    );
  }

  static List<Organization> fromDecodedJson(String decodedJson) {
    List<dynamic> jsonList = json.decode(decodedJson);
    return jsonList.map((json) => Organization.fromJson(json)).toList();
  }
}

class City {
  String cityID;
  String? regionID;
  String? subRegionID;
  String name;
  String? isoCode;
  String? image;
  String? timeZone;

  City({
    required this.cityID,
    this.regionID,
    this.subRegionID,
    required this.name,
    this.isoCode,
    this.image,
    this.timeZone,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      cityID: json['cityID'],
      regionID: json['regionID'],
      subRegionID: json['subRegionID'],
      name: json['name'],
      isoCode: json['isoCode'],
      image: json['image'],
      timeZone: json['timeZone'],
    );
  }
}

class PersonContact {
  String personID;
  String firstName;
  String lastName;
  String mobile;
  String email;
  String? photo;

  PersonContact({
    required this.personID,
    required this.firstName,
    required this.lastName,
    required this.mobile,
    required this.email,
    this.photo,
  });

  factory PersonContact.fromJson(Map<String, dynamic> json) {
    return PersonContact(
      personID: json['personID'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      mobile: json['mobile'],
      email: json['email'],
      photo: json['photo'],
    );
  }
}
