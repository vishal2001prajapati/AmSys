import 'package:am_sys/utils/colors/app_colors.dart';
import 'package:flutter/material.dart';

class AppConstants {
  static final AppConstants _instance = AppConstants._internal();

  factory AppConstants() {
    return _instance;
  }

  AppConstants._internal();

  ///  APIs Base URL & End points
  static const String developmentUrl = "http://stag.voucherskout.com:9000";
  static const String applicationAccessKey = "86b0f6d3fb614291b2f0b14451c4b83a";
  static const String sessionTokenAPI = "/api/openWeb/system/v1/sessionToken";
  static const String assetTypesAPI = "/api/openWeb/amsys/v1/assetTypes";
  static const String serviceLinesAPI = "/api/openWeb/amsys/v1/serviceLines";
  static const String organizationsAPI = "/api/openWeb/amsys/v1/organizations";
  static const String personsAPI = "/api/openWeb/amsys/v1/persons";
  static const String locationTypesAPI = "/api/openWeb/amsys/v1/locationTypes";
  static const String locationUsagesAPI = "/api/openWeb/amsys/v1/locationUsages";
  static const String currenciesAPI = "/api/openWeb/ganymede/v1/currencies";
  static const String assetStatesAPI = "/api/openWeb/amsys/v1/assetStates";
  static const String assetAPI = "/api/openWeb/amsys/v1/assets";
  static const String locationsAPI = "/api/openWeb/amsys/v1/locations";
  static const String userProfileAPI = "/api/authWeb/amsys/v1/userProfile";
  static const String refreshTokenAPI = "/api/authWeb/system/v1/refreshToken";
  static const String postAssetAPI = "/api/authWeb/amsys/v1/postAsset";
  static const String assetDetailAPI = "/api/openWeb/amsys/v1/assetDetail";
  static const String updatePostAssetStateAPI = "/api/authWeb/amsys/v1/postAssetState";

  /// Label and other strings
  static const String login = "Login";
  static const String reLogin = "ReLogin";
  static const String amSys = "AmSys";
  static const String map = "Map";
  static const String list = "List";
  static const String selectAssetsTypes = "Select Assets Type";
  static const String addEstate = "Add state";
  static const String updateEstate = "Update State";
  static const String profile = "Profile";
  static const String cancel = "Cancel";
  static const String details = "Details";
  static const String submit = "Submit";
  static const String tagNumber = "Tag Number";
  static const String partName = "Part Name";
  static const String partNumber = "Part Number";
  static const String serialNumber = "Serial Number";
  static const String purchasePrice = "Purchase Price";
  static const String assetsTypes = "Assets Type";
  static const String currencies = "Currencies";
  static const String warranty = "Warranty";
  static const String modelNumber = "Model Number";
  static const String description = "Description";
  static const String serviceLines = "Service Line";
  static const String selectServiceLines = "Select Service Line";
  static const String maintainerOrganization = "Maintainer Organization";
  static const String ownerOrganization = "Owner Organization";
  static const String selectOwnerOrganization = "Select Owner Organization";
  static const String selectMaintainerOrganization = "Select Maintainer Organization";
  static const String existingLocation = "Existing Location";
  static const String createLocation = "Create Location";
  static const String locationType = "Location Type";
  static const String locationUsages = "Location Usage";
  static const String assetStates = "Asset States";
  static const String assetStateComments = "Asset State Comment";
  static const String location = "Location";
  static const String maintainerPersons = "Maintainer Person";
  static const String ownerPersons = "Owner Person";
  static const String spareParts = "Spare Part";
  static const String parentsAssets = "Parent Asset";
  static const String selectOnlyFiveImages = "Select up to 5 image";
  static const String clickToSelectImage = "Select image";
  static const String clickToSelectAssetsImages = "Click to select an asset image";
  static const String clickToSelectSparePartsImages = "Click to select a spare part image";
  static const String clickToSelectLocationsImages = "Click to select a location image";
  static const String selectAssetsState = "Select Assets State";
  static const String selectLocationUsage = "Select Location Usage";
  static const String selectMaintainerPersons = "Select Maintainer Person";
  static const String selectAssets = "Select Assets";
  static const String selectLookup = "Select lookup";
  static const String selectCurrency = "Select currency";
  static const String enterValue = "Enter value";
  static const String gallery = "Gallery";
  static const String camera = "Camera";
  static const String add = "Add";
  static const String owner = "Owner";
  static const String ownerPhone = "Owner Phone";
  static const String ownerEmail = "Owner Email";
  static const String ownerContactPerson = "Owner Contact Person";
  static const String ownerContactPersonEmail = "Owner Contact Person Email";
  static const String ownerContactPersonPhone = "Owner Contact Person Phone";
  static const String maintainerName = "Maintainer Name";
  static const String maintainerPhone = "Maintainer Phone";
  static const String maintainerEmail = "Maintainer Email";
  static const String floor = "Floor";
  static const String unit = "Unit";
  static const String assetOEM = "Asset OEM";
  static const String modalNumber = "Modal Number";
  static const String cratedDate = "Crated Date";
  static const String confirm = "Confirm";
  static const String done = "Done";
  static const String selectLocationType = "Select location type";
  static const String selectLocation = "Select location";
  static const String confirmLocationSelection = "Are you sure you want select this location?";
  static const String enableLocationPermission = "Please enable location permission";

  /// Login page const
  static const String enterEmail = "Enter email";
  static const String enterPassword = "Enter password";
  static const String pleaseEnterPasswordErrorMessage = "Please enter password";
  static const String pleaseEnterEmailErrorMessage = "Please enter email";
  static const String pleaseEnterValidEmailErrorMessage = "Please enter a valid email";
  static const String passwordErrorMessage = "Password must be at least 6 characters";
  static const String invalidCredentialMessage = "Invalid credentials";
  static String? encodedValue;

  /// Profile page const
  static const String surveyedAssets = "Surveyed Asset";
  static const String uploadedAssets = "Uploaded Asset";
  static const String sessionExpiredInactivity = "Your session has expired due to inactivity. Please log in again to continue.";
  static const String email = "Email";
  static const String mobileNumber = "MobileNumber";
  static const String fullName = "Full Name";
  static const String nickName = "Nick Name";
  static const String history = "History";
  static const String placeHolderImage = "https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png";

  /// Homepage
  static const String isoCodeAndPurchasePrice = "ISOCode & PurchasePrice:";
  static const String assetName = "Asset Name";
  static const String assetState = "Asset State";
  static const String createdBy = "Created by";
  static const String dataUpdatedSuccessfully = "Your data has been updated successfully.";

  /// All text style
  static TextStyle textStyle = TextStyle(
    color: AppColors.textColor,
    fontSize: 20,
    fontWeight: FontWeight.w700,
  );
  static TextStyle descriptionTextStyle = TextStyle(
    color: AppColors.textColor,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static TextStyle detailTxtStyle = TextStyle(
    color: AppColors.textColor,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
}
