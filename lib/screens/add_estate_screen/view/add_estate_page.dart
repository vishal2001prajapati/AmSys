import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:am_sys/data/repository/add_estate_repository.dart';
import 'package:am_sys/model/add_assert_request/add_assert_decoded_request_.dart';
import 'package:am_sys/model/add_assert_request/add_assert_request.dart';
import 'package:am_sys/model/asset_response/assert_response.dart';
import 'package:am_sys/model/asset_states_decode_data/asset_states_decode_data.dart';
import 'package:am_sys/model/assets_type_response/asset_type_decoded_response.dart';
import 'package:am_sys/model/currencies_decode_data/currencies_decode_data.dart';
import 'package:am_sys/model/location_response/location_response.dart';
import 'package:am_sys/model/location_types_decode_data/location_types_decode_data.dart';
import 'package:am_sys/model/location_usages_decode_data/location_usage_drop_down_data.dart';
import 'package:am_sys/model/organizations_decode_data/organizations_decode_data.dart';
import 'package:am_sys/model/persons_decode_data/persons_decode_data.dart';
import 'package:am_sys/model/service_lines_response/service_lines_decode_response.dart';
import 'package:am_sys/screens/google_map/create_location_map.dart';
import 'package:am_sys/screens/google_map/existing_location_map.dart';
import 'package:am_sys/screens/login_screen/view/login_page.dart';
import 'package:am_sys/utils/app_consts/app_consts.dart';
import 'package:am_sys/utils/colors/app_colors.dart';
import 'package:am_sys/utils/custom_drop_down/custom_drop_down.dart';
import 'package:am_sys/utils/custom_linear_loader/custom_linear_loader.dart';
import 'package:am_sys/utils/custom_widgets/custom_part_widget.dart';
import 'package:am_sys/utils/enum/enum.dart';
import 'package:am_sys/utils/loadder/progress_indicator.dart';
import 'package:am_sys/utils/media_selector/meadia_selector.dart';
import 'package:am_sys/utils/session_manager/session_manager.dart';
import 'package:am_sys/utils/snack_bar/snack_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multiple_image_camera/camera_file.dart';
import 'package:multiple_image_camera/multiple_image_camera.dart';
import 'package:permission_handler/permission_handler.dart';

class AddEstateScreen extends StatefulWidget {
  const AddEstateScreen({super.key});

  @override
  State<AddEstateScreen> createState() => _AddEstateScreenState();
}

class _AddEstateScreenState extends State<AddEstateScreen> {
  /// ALl dropdowns list
  final List<String> listServiceLines = [];
  final List<String> listOrganizations = [];
  final List<String> listMaintainerOrganizations = [];
  List<String> listOwnerPersons = [];
  List<String> listMaintainerPersons = [];
  List<String> listLocationIds = [];
  List<String> listLocationUsages = [];
  List<String> listCurrencies = [];
  List<String> listAssetStates = [];

  /// image selection list
  List<XFile?> listSelectedAssetsImages = [];
  List<XFile?> listLocationImages = [];
  List<SpareParts> listSparePartModel = [];
  List<XFile?> listSelectedImagesSparePartsImages = [];

  /// All selected values of dropdown
  String? assetTypesInitialValue;
  String? serviceLinesInitialValue;
  String? ownerOrganizationInitialValue;
  String? maintainerOrganizationInitialValue;
  String? ownerPersonsInitialValue;
  String? maintainerPersonsInitialValue;
  String? locationIdInitialValue;
  String? locationUsagesInitialValue;
  String? currenciesDataInitialValue;
  String? assetStatesInitialValue;
  String? locationErrorMessage;
  String? currencyID;
  String? assetStateID;
  String? serviceLineID;
  String? locationTypeID;
  String? locationUsageID;
  String? personID;
  String? maintainerOrganizationID;
  String? ownerContactID;
  String? maintainerPersonsID;

  /// RadioButton default selection
  LocationOption locationType = LocationOption.createLocation;
  double? latitude;
  double? longitude;

  /// All TextFields controllers
  final tagNumberController = TextEditingController();
  final modelNumberController = TextEditingController();
  final serialNumberController = TextEditingController();
  final warrantyController = TextEditingController();
  final purchasePriceController = TextEditingController();
  final descriptionController = TextEditingController();
  final assetStateCommentsController = TextEditingController();

  /// GoogleMapController`
  late GoogleMapController mapController;
  late GoogleMapController existingMapController;
  LatLng? selectedLocation;
  String? markerId;
  String? organizationID;

  late AssetTypeDecodedResponse assetTypeDecodedResponse;
  AssetType? assetType;
  final List<AssetType> listAssetsType = [];

  CurrenciesDecodeData? selectedCurrency;
  List<CurrenciesDecodeData> currencies = [];

  AssetStatesDecodeData? assetStatesDecodeData;
  List<AssetStatesDecodeData> listAssetStatesDecodeData = [];

  ServiceLine? serviceLine;
  List<ServiceLine> listServiceLineId = [];

  LocationTypesDecodeData? locationTypesDecodeData;
  List<LocationTypesDecodeData> listLocationTypesDecodeData = [];

  LocationUsageDropDownData? locationUsage;
  List<LocationUsageDropDownData> locationUsages = [];

  Organization? organization;
  List<Organization> organizationsList = [];

  PersonContact? personContact;
  List<PersonContact> personContactList = [];

  PersonsDecodeData? personsDecodeData;
  List<PersonsDecodeData> personsDecodeDataList = [];

  ParentAssetResponse? parentAssetResponse;
  List<ParentAssetResponse> listParentAssetResponse = [];
  List<LocationResponse> listExistingLocationResponse = [];

  /// list of assert images
  List<MediaModel> imagesOfAssert = [];
  List<MediaModel> imagesOfLocation = [];

  /// Repository instance
  final AddEstateRepository _addEstateRepository = AddEstateRepository();

  final GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  /// Labels const textStyle
  static const textStyle = TextStyle(
    color: Colors.black,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  /// All loaders booleans
  bool isLoading = true;
  bool isServiceLinesLoading = true;
  bool isOrganizationsLoading = true;
  bool isOwnerPersonsLoading = true;
  bool isMaintainerPersonsLoading = true;
  bool isLocationIdsLoading = true;
  bool isLocationUsagesLoading = true;
  bool isCurrenciesLoading = true;
  bool isAssetStatesLoading = true;
  bool isAssetLoading = true;
  bool isLocationsLoading = true;
  bool isAttributesLoading = false;
  bool showLoadingImage = false;
  bool isRequestLoading = false;
  bool isProcessing = false;
  final unfocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    getAssetTypeData();
    getServiceLinesData();
    getOrganizationsData();
    getPersonsData();
    getLocationTypeData();
    getLocationUsageData();
    getCurrenciesData();
    getAssetStatesData();
    getAssetData();
    getLocationsData();
    listSparePartModel.add(SpareParts());
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => unfocusNode.canRequestFocus ? FocusScope.of(context).requestFocus(unfocusNode) : FocusScope.of(context).unfocus(),
      child: Scaffold(
          body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Form(
          key: globalKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              const Text(
                AppConstants.assetsTypes,
                style: textStyle,
              ),
              const SizedBox(
                height: 5,
              ),

              /// select AssetsTypes
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 300),
                crossFadeState: isLoading ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                firstChild: const CustomLinearLoader(),
                secondChild: CustomDropdownButtonFormField(
                  hint: AppConstants.selectAssetsTypes,
                  onChanged: (value) {
                    int index = listAssetsType.indexWhere((AssetType element) => element.name == (value as String));
                    setState(() {
                      assetType?.assetTypeAttributes.forEach((element) {
                        element.selectedValue = null;
                      });
                      assetType = null;
                      isAttributesLoading = true;
                    });
                    Future.delayed(
                      const Duration(milliseconds: 500),
                      () {
                        setState(() {
                          assetType = listAssetsType[index];
                          isAttributesLoading = false;
                          // assetTypesInitialValue = (value as String);
                          // log('AssetsTypes value: $assetTypesInitialValue');
                        });
                      },
                    );
                  },
                  items: listAssetsType.map((e) => e.name).toList(),
                ),
              ),

              ///  Dynamic fields
              AnimatedContainer(
                alignment: Alignment.center,
                duration: const Duration(milliseconds: 300),
                child: isAttributesLoading
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: CircularProgressIndicator(),
                      )
                    : const SizedBox(),
              ),

              /// Visibility of dynamic fields
              Visibility(
                visible: assetType != null,
                child: ListView.separated(
                  padding: const EdgeInsets.only(top: 10),
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 10,
                    );
                  },
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: (assetType?.assetTypeAttributes ?? []).length,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          assetType?.assetTypeAttributes[index].attributeName ?? '',
                          style: textStyle,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        (assetType?.assetTypeAttributes[index].attributeDataType.name == 'LOOKUP')
                            ? CustomDropdownButtonFormField(
                                hint: AppConstants.selectLookup,
                                items: assetType?.assetTypeAttributes[index].lookups ?? [],
                                onChanged: (p0) {
                                  setState(() {
                                    assetType?.assetTypeAttributes[index].selectedValue = p0 as String;
                                  });
                                },
                              )
                            : (assetType?.assetTypeAttributes[index].attributeDataType.name == 'INTEGER')
                                ? TextFormField(
                                    validator: (value) {
                                      return (value == null || value.isEmpty) ? "Field required" : null;
                                    },
                                    onChanged: (value) {
                                      assetType?.assetTypeAttributes[index].selectedValue = value;
                                    },
                                    decoration: InputDecoration(
                                      label: const Text(AppConstants.enterValue),
                                      border: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppColors.primaryColor,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox()
                      ],
                    );
                  },
                ),
              ),

              const SizedBox(
                height: 20,
              ),
              const Text(
                AppConstants.parentsAssets,
                style: textStyle,
              ),
              const SizedBox(
                height: 5,
              ),

              /// Select Assets dropdown
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 300),
                crossFadeState: isAssetLoading ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                firstChild: const CustomLinearLoader(),
                secondChild: CustomDropdownButtonFormField(
                  hint: AppConstants.selectAssets,
                  onChanged: (value) {
                    int index = listParentAssetResponse.indexWhere((ParentAssetResponse element) => element.assetTypeName == (value as String));

                    setState(() {
                      parentAssetResponse = listParentAssetResponse[index];
                      log("parentAssetResponse ID: ${parentAssetResponse?.assetID}");
                      log("parentAssetResponse Name: ${parentAssetResponse?.assetTypeName}");
                      // _dropdownValue = (value as String);
                      // log('Assets value: $_dropdownValue');
                    });
                  },
                  items: listParentAssetResponse.map((e) => e.assetTypeName).toList(),
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              /// TextFormField of Tag Number
              TextFormField(
                validator: (value) {
                  return (value == null || value.isEmpty) ? "Field required" : null;
                },
                textInputAction: TextInputAction.next,
                controller: tagNumberController,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(255),
                ],
                decoration: InputDecoration(
                  label: const Text(AppConstants.tagNumber),
                  fillColor: AppColors.listBGColor,
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.listBGColor,
                      width: 2,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              /// TextFormField of Description
              TextFormField(
                maxLines: 3,
                validator: (value) {
                  return (value == null || value.isEmpty) ? "Field required" : null;
                },
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.done,
                controller: descriptionController,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(510),
                ],
                decoration: InputDecoration(
                  alignLabelWithHint: true,
                  label: const Text(AppConstants.description),
                  fillColor: AppColors.listBGColor,
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.listBGColor,
                      width: 2,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                AppConstants.serviceLines,
                style: textStyle,
              ),
              const SizedBox(
                height: 5,
              ),

              /// serviceLines dropdown

              AnimatedCrossFade(
                duration: const Duration(milliseconds: 300),
                crossFadeState: isServiceLinesLoading ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                firstChild: const CustomLinearLoader(),
                secondChild: CustomDropdownButtonFormField(
                  hint: AppConstants.selectServiceLines,
                  onChanged: (value) {
                    int index = listServiceLineId.indexWhere((ServiceLine element) => element.name == (value as String));

                    setState(() {
                      serviceLine = listServiceLineId[index];
                      serviceLineID = serviceLine?.serviceLineID;
                      log('serviceLine name value: ${serviceLine?.name}');
                      log('serviceLine serviceLineID value: ${serviceLine?.serviceLineID}');
                    });
                  },
                  items: listServiceLineId.map((e) => e.name).toList(),
                ),
              ),

              const SizedBox(
                height: 20,
              ),
              const Text(
                AppConstants.ownerOrganization,
                style: textStyle,
              ),
              const SizedBox(
                height: 5,
              ),

              /// Owner Organization dropdown
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 300),
                crossFadeState: isOrganizationsLoading ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                firstChild: const CustomLinearLoader(),
                secondChild: CustomDropdownButtonFormField(
                  hint: AppConstants.selectOwnerOrganization,
                  onChanged: (value) {
                    int index = organizationsList.indexWhere((Organization element) =>
                        '${element.name} ${element.personContact.firstName} ${element.personContact.lastName}' == (value as String));

                    setState(() {
                      organization = organizationsList[index];
                      organizationID = organization?.personContact.personID;
                      log('personContact value: ${organization?.personContact.firstName} ${organization?.personContact.lastName}, ID:: $organizationID');
                    });
                  },
                  items: organizationsList.map((e) => '${e.name} ${e.personContact.firstName} ${e.personContact.lastName}').toList(),
                ),
              ),

              const SizedBox(
                height: 20,
              ),
              const Text(
                AppConstants.ownerPersons,
                style: textStyle,
              ),
              const SizedBox(
                height: 5,
              ),

              /// owner person dropdown
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 300),
                crossFadeState: isOwnerPersonsLoading ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                firstChild: const CustomLinearLoader(),
                secondChild: CustomDropdownButtonFormField(
                  hint: 'Select owner person',
                  onChanged: (value) {
                    int index = personsDecodeDataList
                        .indexWhere((PersonsDecodeData element) => '${element.firstName} ${element.lastName}' == (value as String));
                    setState(() {
                      personsDecodeData = personsDecodeDataList[index];
                      ownerContactID = personsDecodeData?.personID;
                      log('ownerContactID value: ${personsDecodeData?.firstName} ${personsDecodeData?.lastName}, ID:: $ownerContactID');
                    });
                  },
                  items: personsDecodeDataList.map((e) => '${e.firstName} ${e.lastName}').toList(),
                ),
              ),

              const SizedBox(
                height: 20,
              ),
              const Text(
                AppConstants.maintainerOrganization,
                style: textStyle,
              ),
              const SizedBox(
                height: 5,
              ),

              /// Maintainer Organization dropdown

              AnimatedCrossFade(
                duration: const Duration(milliseconds: 300),
                crossFadeState: isOrganizationsLoading ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                firstChild: const CustomLinearLoader(),
                secondChild: CustomDropdownButtonFormField(
                  hint: AppConstants.selectMaintainerOrganization,
                  onChanged: (value) {
                    int index = organizationsList.indexWhere((Organization element) =>
                        '${element.name} ${element.personContact.firstName} ${element.personContact.lastName}' == (value as String));

                    setState(() {
                      organization = organizationsList[index];
                      maintainerOrganizationID = organization?.personContact.personID;
                      log('personContact value: ${organization?.personContact.firstName} ${organization?.personContact.lastName}, ID:: $maintainerOrganizationID');
                    });
                  },
                  items: organizationsList.map((e) => '${e.name} ${e.personContact.firstName} ${e.personContact.lastName}').toList(),
                ),
              ),

              const SizedBox(
                height: 20,
              ),
              const Text(
                AppConstants.maintainerPersons,
                style: textStyle,
              ),

              const SizedBox(
                height: 5,
              ),

              /// maintainer persons dropdown

              AnimatedCrossFade(
                duration: const Duration(milliseconds: 300),
                crossFadeState: isOwnerPersonsLoading ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                firstChild: const CustomLinearLoader(),
                secondChild: CustomDropdownButtonFormField(
                  hint: AppConstants.selectMaintainerPersons,
                  onChanged: (value) {
                    int index = personsDecodeDataList
                        .indexWhere((PersonsDecodeData element) => '${element.firstName} ${element.lastName}' == (value as String));
                    setState(() {
                      personsDecodeData = personsDecodeDataList[index];
                      maintainerPersonsID = personsDecodeData?.personID;
                      log('maintainer persons value: ${personsDecodeData?.firstName} ${personsDecodeData?.lastName}, ID:: $maintainerPersonsID');
                    });
                  },
                  items: personsDecodeDataList.map((e) => '${e.firstName} ${e.lastName}').toList(),
                ),
              ),

              const SizedBox(
                height: 20,
              ),
              const Text(
                AppConstants.spareParts,
                style: textStyle,
              ),

              const SizedBox(
                height: 5,
              ),

              ListView.separated(
                itemCount: listSparePartModel.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return CustomPartWidget(
                    addCallBack: () {
                      setState(() {
                        listSparePartModel.add(SpareParts());
                      });
                    },
                    listSelectedImagesSparePartsImages: listSelectedImagesSparePartsImages,
                    listSize: listSparePartModel.length,
                    index: index,
                    sparePartModel: listSparePartModel[index],
                    onRemove: () {
                      List<SpareParts> tempList = List.from(listSparePartModel);
                      setState(() {
                        tempList.removeAt(index);
                        listSparePartModel = tempList;
                      });
                    },
                  );
                },
                separatorBuilder: (context, index) => const Divider(),
              ),

              const SizedBox(
                height: 20,
              ),
              const Text(
                AppConstants.location,
                style: textStyle,
              ),

              /// Create Location RadioButton
              RadioListTile<LocationOption>(
                activeColor: AppColors.primaryColor,
                contentPadding: const EdgeInsets.symmetric(horizontal: 0.0),
                title: Transform.translate(
                  offset: const Offset(-12, 0),
                  child: const Text(AppConstants.createLocation),
                ),
                value: LocationOption.createLocation,
                groupValue: locationType,
                onChanged: (LocationOption? value) {
                  setState(() {
                    locationType = value!;
                    log('locationType: ${locationType}');
                  });
                },
              ),

              /// createLocation GoogleMap
              if (locationType == LocationOption.createLocation)
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    onPressed: () async {
                      await handleLocationPermissionAndNavigate();
                      // Position? position = await determinePosition();
                      // if (mounted) {
                      //   final result = await Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => CreateLocationMap(position: position),
                      //     ),
                      //   );
                      //   if (result != null) {
                      //     setState(() {
                      //       selectedLocation = result;
                      //     });
                      //     latitude = selectedLocation?.latitude;
                      //     longitude = selectedLocation?.longitude;
                      //
                      //     log('latitude:: $latitude, longitude:: $longitude');
                      //   }
                      // }
                    },
                    child: isProcessing == true
                        ? SizedBox(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator(
                              color: AppColors.whiteColor,
                              strokeWidth: 3.5,
                            ),
                          )
                        : Text(
                            'Select location',
                            style: TextStyle(
                              fontSize: 17,
                              color: AppColors.whiteColor,
                            ),
                          ),
                  ),
                ),

              if (locationType == LocationOption.createLocation)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    const Text(
                      AppConstants.locationType,
                      style: textStyle,
                    ),
                    const SizedBox(height: 5),

                    /// Location Type dropdown
                    AnimatedCrossFade(
                      duration: const Duration(milliseconds: 300),
                      crossFadeState: isLocationIdsLoading ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                      firstChild: const CustomLinearLoader(),
                      secondChild: CustomDropdownButtonFormField(
                        hint: AppConstants.selectLocationType,
                        onChanged: (value) {
                          int index = listLocationTypesDecodeData.indexWhere((LocationTypesDecodeData element) => element.name == (value as String));

                          setState(() {
                            locationTypesDecodeData = listLocationTypesDecodeData[index];
                            locationTypeID = locationTypesDecodeData?.locationTypeID;
                            log('locationTypesDecodeData value: ${locationTypesDecodeData?.name}, ID:: ${locationTypesDecodeData?.locationTypeID}');
                          });
                        },
                        items: listLocationTypesDecodeData.map((e) => e.name).toList(),
                      ),
                    ),

                    const SizedBox(height: 10),
                    const Text(
                      AppConstants.locationUsages,
                      style: textStyle,
                    ),
                    const SizedBox(height: 5),

                    /// locationUsages dropdown

                    AnimatedCrossFade(
                      duration: const Duration(milliseconds: 300),
                      crossFadeState: isLocationUsagesLoading ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                      firstChild: const CustomLinearLoader(),
                      secondChild: CustomDropdownButtonFormField(
                        hint: AppConstants.selectLocationUsage,
                        onChanged: (value) {
                          int index = locationUsages.indexWhere((LocationUsageDropDownData element) => element.name == (value as String));

                          setState(() {
                            locationUsage = locationUsages[index];
                            locationUsageID = locationUsage?.locationUsageID;
                            log('locationUsage value: ${locationUsage?.name}, ID:: ${locationUsage?.locationUsageID}');
                          });
                        },
                        items: locationUsages.map((e) => e.name).toList(),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),

                    /// Image selection button Locations Images
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        height: 50,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            side: BorderSide(
                              width: 1,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          onPressed: () {
                            _showLocationActionSheet(context: context);
                          },
                          child: Text(
                            AppConstants.clickToSelectLocationsImages,
                            style: TextStyle(
                              fontSize: 17,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        AppConstants.selectOnlyFiveImages,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.blackColor,
                        ),
                      ),
                    ),
                    if (listLocationImages.isEmpty) const SizedBox(height: 10),

                    /// Selected images shown in Grid format
                    if (listLocationImages.isNotEmpty) const SizedBox(height: 10),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                      ),
                      itemBuilder: (context, index) {
                        return Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.file(
                              File(listLocationImages[index]!.path),
                              fit: BoxFit.cover,
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white.withOpacity(0.4),
                                      Colors.white.withOpacity(0),
                                    ],
                                    stops: const [0.3, 0.5],
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 3,
                              right: 3,
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      listLocationImages.removeAt(index);
                                    });
                                  },
                                  borderRadius: BorderRadius.circular(100),
                                  child: const Icon(
                                    Icons.cancel,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                      itemCount: listLocationImages.length,
                    ),

                    /// image get from camera
                    if (imagesOfLocation.isNotEmpty) const SizedBox(height: 10),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                      ),
                      itemBuilder: (context, index) {
                        return Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.file(
                              File(imagesOfLocation[index].file.path),
                              fit: BoxFit.cover,
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white.withOpacity(0.4),
                                      Colors.white.withOpacity(0),
                                    ],
                                    stops: const [0.3, 0.5],
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 3,
                              right: 3,
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      imagesOfLocation.removeAt(index);
                                    });
                                  },
                                  borderRadius: BorderRadius.circular(100),
                                  child: const Icon(
                                    Icons.cancel,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                      itemCount: imagesOfLocation.length,
                    ),
                  ],
                ),

              /// Existing Location RadioButton
              RadioListTile<LocationOption>(
                activeColor: AppColors.primaryColor,
                contentPadding: const EdgeInsets.symmetric(horizontal: 0.0),
                title: Transform.translate(
                  offset: const Offset(-12, 0),
                  child: const Text(AppConstants.existingLocation),
                ),
                value: LocationOption.existingLocation,
                groupValue: locationType,
                onChanged: (LocationOption? value) {
                  setState(() {
                    locationType = value!;
                  });
                },
              ),

              /// ExistingLocation GoogleMap
              if (locationType == LocationOption.existingLocation)
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    onPressed: () async {
                      await handleExistingLocationPermissionAndNavigate();
                      // Position? position = await determinePosition();
                      //
                      // var result = await Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => ExistingLocationMap(listExistingLocationResponse: listExistingLocationResponse, position: position),
                      //   ),
                      // );
                      //
                      // if (result != null) {
                      //   setState(() {
                      //     selectedLocation = result['position'];
                      //     markerId = result['id'];
                      //   });
                      //   latitude = selectedLocation?.latitude;
                      //   longitude = selectedLocation?.longitude;
                      //
                      //   log('Existing latitude:: $latitude, longitude:: $longitude');
                      // }
                    },
                    child: isProcessing == true
                        ? SizedBox(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator(
                              color: AppColors.whiteColor,
                              strokeWidth: 3.5,
                            ),
                          )
                        : Text(
                            'Click to select existing location',
                            style: TextStyle(
                              fontSize: 17,
                              color: AppColors.whiteColor,
                            ),
                          ),
                  ),
                ),

              const SizedBox(height: 20),

              /// TextFormField of Model Number
              TextFormField(
                validator: (value) {
                  return (value == null || value.isEmpty) ? "Field required" : null;
                },
                textInputAction: TextInputAction.next,
                controller: modelNumberController,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(255),
                ],
                decoration: InputDecoration(
                  label: const Text(AppConstants.modelNumber),
                  fillColor: AppColors.listBGColor,
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.listBGColor,
                      width: 2,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              /// TextFormField of Serial Number
              TextFormField(
                validator: (value) {
                  return (value == null || value.isEmpty) ? "Field required" : null;
                },
                textInputAction: TextInputAction.next,
                controller: serialNumberController,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(255),
                ],
                decoration: InputDecoration(
                  label: const Text(AppConstants.serialNumber),
                  fillColor: AppColors.listBGColor,
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.listBGColor,
                      width: 2,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              /// TextFormField of Purchase Price(Note:Value pass in double to string)
              TextFormField(
                validator: (value) {
                  return (value == null || value.isEmpty) ? "Field required" : null;
                },
                textInputAction: TextInputAction.next,
                controller: purchasePriceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  label: const Text(AppConstants.purchasePrice),
                  fillColor: AppColors.listBGColor,
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.listBGColor,
                      width: 2,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              const Text(
                AppConstants.currencies,
                style: textStyle,
              ),

              const SizedBox(height: 5),

              /// currencies dropdown

              AnimatedCrossFade(
                duration: const Duration(milliseconds: 300),
                crossFadeState: isCurrenciesLoading ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                firstChild: const CustomLinearLoader(),
                secondChild: CustomDropdownButtonFormField(
                  hint: AppConstants.selectCurrency,
                  onChanged: (value) {
                    int index = currencies.indexWhere((CurrenciesDecodeData element) => '${element.isoCode} - ${element.name}' == (value as String));

                    setState(() {
                      selectedCurrency = currencies[index];
                      if (selectedCurrency != null) {
                        currencyID = selectedCurrency!.currencyID;
                        log("Selected Currency ID: ${selectedCurrency!.currencyID}");
                        log("Selected Currency Name: ${selectedCurrency!.name}");
                      }
                    });
                  },
                  items: currencies.map((e) => '${e.isoCode} - ${e.name}').toList(),
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              /// TextFormField of Warranty
              TextFormField(
                validator: (value) {
                  return (value == null || value.isEmpty) ? "Field required" : null;
                },
                textInputAction: TextInputAction.done,
                controller: warrantyController,
                maxLines: 3,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(1020),
                ],
                decoration: InputDecoration(
                  alignLabelWithHint: true,
                  label: const Text(AppConstants.warranty),
                  fillColor: AppColors.listBGColor,
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.listBGColor,
                      width: 2,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              const Text(
                AppConstants.assetStates,
                style: textStyle,
              ),
              const SizedBox(height: 5),

              /// assetStates dropdown
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 300),
                crossFadeState: isAssetStatesLoading ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                firstChild: const CustomLinearLoader(),
                secondChild: CustomDropdownButtonFormField(
                  hint: AppConstants.selectAssetsState,
                  onChanged: (value) {
                    int index = listAssetStatesDecodeData.indexWhere((AssetStatesDecodeData element) => element.state == (value as String));

                    setState(() {
                      assetStatesDecodeData = listAssetStatesDecodeData[index];
                      if (assetStatesDecodeData != null) {
                        assetStateID = assetStatesDecodeData!.assetStateID;
                        log("Selected assetStateID : ${assetStatesDecodeData!.assetStateID}");
                        log("Selected state: ${assetStatesDecodeData!.state}");
                      }
                    });
                  },
                  items: listAssetStatesDecodeData.map((e) => e.state).toList(),
                ),
              ),

              const SizedBox(height: 20),

              /// TextFormField of Asset State Comments
              TextFormField(
                validator: (value) {
                  return (value == null || value.isEmpty) ? "Field required" : null;
                },
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.done,
                controller: assetStateCommentsController,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(510),
                ],
                decoration: InputDecoration(
                  alignLabelWithHint: true,
                  label: const Text(AppConstants.assetStateComments),
                  fillColor: AppColors.listBGColor,
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.listBGColor,
                      width: 2,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              /// Image selection button
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  height: 50,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      side: BorderSide(
                        width: 1,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    onPressed: () {
                      _showAssetActionSheet(context: context);
                    },
                    child: Text(
                      AppConstants.clickToSelectAssetsImages,
                      style: TextStyle(
                        fontSize: 17,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ),
              ),

              Align(
                alignment: Alignment.center,
                child: Text(
                  AppConstants.selectOnlyFiveImages,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.blackColor,
                  ),
                ),
              ),

              /// Selected images shown in Grid format
              if (listSelectedAssetsImages.isNotEmpty) const SizedBox(height: 10),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                ),
                itemBuilder: (context, index) {
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.file(
                        File(listSelectedAssetsImages[index]!.path),
                        fit: BoxFit.cover,
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withOpacity(0.4),
                                Colors.white.withOpacity(0),
                              ],
                              stops: const [0.3, 0.5],
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 3,
                        right: 3,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                listSelectedAssetsImages.removeAt(index);
                              });
                            },
                            borderRadius: BorderRadius.circular(100),
                            child: const Icon(
                              Icons.cancel,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
                itemCount: listSelectedAssetsImages.length,
              ),
              const SizedBox(height: 20),
              if (imagesOfAssert.isNotEmpty) const SizedBox(height: 10),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                ),
                itemCount: imagesOfAssert.length,
                itemBuilder: (context, index) {
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.file(
                        File(imagesOfAssert[index].file.path),
                        fit: BoxFit.cover,
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withOpacity(0.4),
                                Colors.white.withOpacity(0),
                              ],
                              stops: const [0.3, 0.5],
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 3,
                        right: 3,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                imagesOfAssert.removeAt(index);
                              });
                            },
                            borderRadius: BorderRadius.circular(100),
                            child: const Icon(
                              Icons.cancel,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),

              /// Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  onPressed: () {
                    if (globalKey.currentState!.validate()) {
                      log('Form validate : true ');
                      postAssetRequest(context: context);
                    } else {
                      // showSnackBar(context,'Some field is missing to select or enter value.');
                      log('Form validate : false ');
                    }
                  },
                  child: isRequestLoading == false
                      ? Text(
                          AppConstants.submit,
                          style: TextStyle(
                            fontSize: 17,
                            color: AppColors.whiteColor,
                          ),
                        )
                      : SizedBox(
                          height: 30,
                          width: 30,
                          child: CircularProgressIndicator(
                            color: AppColors.whiteColor,
                            strokeWidth: 3.5,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      )),
    );
  }

  /// API call of AssetType
  Future<void> getAssetTypeData() async {
    try {
      var response = await _addEstateRepository.getAssetTypeData();

      if (response.status == 200) {
        setState(() {
          isLoading = false;
        });

        String? encoded = response.data;
        String decoded = utf8.decode(base64.decode(encoded ?? ''));
        List<dynamic> decodedJson = json.decode(decoded);

        AssetTypeDecodedResponse assetTypeDecodedResponse = AssetTypeDecodedResponse.fromJson(decodedJson);

        for (int i = 0; i < assetTypeDecodedResponse.assets.length; i++) {
          var iData = assetTypeDecodedResponse.assets[i];
          listAssetsType.add(iData);
        }
      } else {
        setState(() {
          isLoading = false;
        });
        showSnackBar(context, response.description);
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });

      log('Error: $error');
      showSnackBar(context, error.toString());
    }
  }

  /// API call of ServiceLines
  Future<void> getServiceLinesData() async {
    try {
      var response = await _addEstateRepository.getServiceLinesData();

      if (response.status == 200) {
        setState(() {
          isServiceLinesLoading = false;
        });

        String? encoded = response.data;
        String decoded = utf8.decode(base64.decode(encoded ?? ''));
        // List<dynamic> decodedJson = json.decode(decoded);

        List<ServiceLine> serviceLinesResponse = ServiceLine.fromDecodedJson(decoded);

        listServiceLineId = serviceLinesResponse;
      } else {
        setState(() {
          isServiceLinesLoading = false;
        });
        showSnackBar(context, response.description);
      }
    } catch (error) {
      setState(() {
        isServiceLinesLoading = false;
      });

      log('Error: $error');
      showSnackBar(context, error.toString());
    }
  }

  /// API call of Organizations
  Future<void> getOrganizationsData() async {
    try {
      var response = await _addEstateRepository.getOrganizationsData();

      if (response.status == 200) {
        setState(() {
          isOrganizationsLoading = false;
        });

        String? encoded = response.data;
        String decoded = utf8.decode(base64.decode(encoded ?? ''));
        // List<dynamic> decodedJson = json.decode(decoded);
        List<Organization> mOrganizations = Organization.fromDecodedJson(decoded);

        organizationsList = mOrganizations;
      } else {
        setState(() {
          isOrganizationsLoading = false;
        });
        showSnackBar(context, response.description);
      }
    } catch (error) {
      setState(() {
        isOrganizationsLoading = false;
      });

      log('Error: $error');
      showSnackBar(context, error.toString());
    }
  }

  /// API call of Persons
  Future<void> getPersonsData() async {
    try {
      var response = await _addEstateRepository.getPersonsData();

      if (response.status == 200) {
        setState(() {
          isOwnerPersonsLoading = false;
        });

        String? encoded = response.data;
        String decoded = utf8.decode(base64.decode(encoded ?? ''));
        // List<dynamic> decodedJson = json.decode(decoded);
        List<PersonsDecodeData> mPersonsDecodeData = PersonsDecodeData.fromDecodedJson(decoded);
        personsDecodeDataList = mPersonsDecodeData;
      } else {
        setState(() {
          isOwnerPersonsLoading = false;
        });
        showSnackBar(context, response.description);
      }
    } catch (error) {
      setState(() {
        isOwnerPersonsLoading = false;
      });

      log('Error: $error');
      showSnackBar(context, error.toString());
    }
  }

  /// API call of LocationType
  Future<void> getLocationTypeData() async {
    try {
      var response = await _addEstateRepository.getLocationTypeData();

      if (response.status == 200) {
        setState(() {
          isLocationIdsLoading = false;
        });

        String? encoded = response.data;
        String decoded = utf8.decode(base64.decode(encoded ?? ''));
        // List<dynamic> decodedJson = json.decode(decoded);
        List<LocationTypesDecodeData> locationTypes = LocationTypesDecodeData.fromDecodedJson(decoded);
        listLocationTypesDecodeData = locationTypes;
      } else {
        setState(() {
          isLocationIdsLoading = false;
        });
        showSnackBar(context, response.description);
      }
    } catch (error) {
      setState(() {
        isLocationIdsLoading = false;
      });

      log('Error: $error');
      showSnackBar(context, error.toString());
    }
  }

  /// API call of LocationUsage
  Future<void> getLocationUsageData() async {
    try {
      var response = await _addEstateRepository.getLocationUsageData();

      if (response.status == 200) {
        setState(() {
          isLocationUsagesLoading = false;
        });

        String? encoded = response.data;
        String decoded = utf8.decode(base64.decode(encoded ?? ''));
        List<LocationUsageDropDownData> mLocationUsageDropDownData = LocationUsageDropDownData.fromDecodedJson(decoded);

        locationUsages = mLocationUsageDropDownData;
      } else {
        setState(() {
          isLocationUsagesLoading = false;
        });
        showSnackBar(context, response.description);
      }
    } catch (error) {
      setState(() {
        isLocationUsagesLoading = false;
      });

      log('Error: $error');
      showSnackBar(context, error.toString());
    }
  }

  /// API call of Currencies
  Future<void> getCurrenciesData() async {
    try {
      var response = await _addEstateRepository.getCurrenciesData();

      if (response.status == 200) {
        setState(() {
          isCurrenciesLoading = false;
        });

        String? encoded = response.data;
        String decoded = utf8.decode(base64.decode(encoded ?? ''));
        List<CurrenciesDecodeData> mCurrencies = CurrenciesDecodeData.fromDecodedJson(decoded);
        currencies = mCurrencies;
      } else {
        setState(() {
          isCurrenciesLoading = false;
        });
        showSnackBar(context, response.description);
      }
    } catch (error) {
      setState(() {
        isCurrenciesLoading = false;
      });

      log('Error: $error');
      showSnackBar(context, error.toString());
    }
  }

  /// API call of Parent Assets
  Future<void> getAssetStatesData() async {
    try {
      var response = await _addEstateRepository.getAssetStatesData();

      if (response.status == 200) {
        setState(() {
          isAssetStatesLoading = false;
        });

        String? encoded = response.data;
        String decoded = utf8.decode(base64.decode(encoded ?? ''));
        List<dynamic> decodedJson = json.decode(decoded);

        List<AssetStatesDecodeData> assetStates = decodedJson.map((data) => AssetStatesDecodeData.fromJson(data)).toList();
        listAssetStatesDecodeData = assetStates;
      } else {
        setState(() {
          isAssetStatesLoading = false;
        });
        showSnackBar(context, response.description);
      }
    } catch (error) {
      setState(() {
        isAssetStatesLoading = false;
      });

      log('Error: $error');
      showSnackBar(context, error.toString());
    }
  }

  /// API of Asset
  Future<void> getAssetData() async {
    try {
      var response = await _addEstateRepository.getAssetData();

      if (response.status == 200) {
        setState(() {
          isAssetLoading = false;
        });
        String? encoded = response.data;
        String decoded = utf8.decode(base64.decode(encoded ?? ''));
        // List<dynamic> decodedJson = json.decode(decoded);
        List<ParentAssetResponse> parentAssetResponseList = ParentAssetResponse.fromDecodedJson(decoded);
        listParentAssetResponse = parentAssetResponseList;
      } else {
        setState(() {
          isAssetLoading = false;
        });
        //  showSnackBar(context, response.description);
      }

      if (response.status == 400) {
        String? encoded = response.data;
        String decoded = utf8.decode(base64.decode(encoded ?? ''));
        List<dynamic> decodedJson = json.decode(decoded);

        log('decodedJson: $decodedJson');
      }
    } catch (error) {
      setState(() {
        isAssetLoading = false;
      });

      log('Error: $error');
      // showSnackBar(context, 'getAssetData: ${error.toString()}');
    }
  }

  /// API call of Locations

  Future<void> getLocationsData() async {
    try {
      var response = await _addEstateRepository.getLocationsData();

      if (response.status == 200) {
        setState(() {
          isLocationsLoading = false;
        });
        String? encoded = response.data;
        String decoded = utf8.decode(base64.decode(encoded ?? ''));

        listExistingLocationResponse = LocationResponse.fromDecodedJson(decoded);

        for (int i = 0; i < listExistingLocationResponse.length; i++) {
          log('listLocationResponse: latitude: ${listExistingLocationResponse[i].latitude}, longitude:${listExistingLocationResponse[i].longitude}');
        }
      } else {
        setState(() {
          isLocationsLoading = false;
        });
        //  showSnackBar(context, response.description);
      }

      if (response.status == 400) {
        // String? encoded = response.data;
        // String decoded = utf8.decode(base64.decode(encoded ?? ''));
        // List<dynamic> decodedJson = json.decode(decoded);
        locationErrorMessage = 'Empty Data';
        //log('getLocationsData error: $decodedJson');
      }
    } catch (error) {
      setState(() {
        isLocationsLoading = false;
      });

      log('Error: $error');
      // showSnackBar(context, '${error.toString()}');
    }
  }

  Future<void> postAssetRequest({required BuildContext context}) async {
    ///Spare parts list
    List<SpareParts> spareParts = [];
    for (int i = 0; i < listSparePartModel.length; i++) {
      spareParts.add(SpareParts(
        partName: listSparePartModel[i].partName,
        partNumber: listSparePartModel[i].partNumber,
        partPhoto: listSparePartModel[i].partPhoto,
      ));
    }

    ///Assets list
    List<AssetAttributes> assetAttributes = [];

    for (int i = 0; i < assetType!.assetTypeAttributes.length; i++) {
      assetAttributes.add(AssetAttributes(
        assetTypeAttributeID: assetType!.assetTypeAttributes[i].assetTypeAttributeID,
        attributeValue: assetType!.assetTypeAttributes[i].selectedValue,
      ));
      log("assetAttribute: ${assetAttributes[i].toJson().toString()}");
    }

    /// assetPhotos path upload
    List<String>? filePaths = listSelectedAssetsImages.map((file) => file?.path ?? '').toList();
    // imagesOfAssert[index].file.path;
    List<String>? cameraFilePaths = imagesOfAssert.map((e) => e.file.path).toList();

    List<String> base64Strings = [];
    List<String> base64StringCameraFilePaths = [];

    for (String filePath in filePaths) {
      File file = File(filePath);
      List<int> bytes = file.readAsBytesSync();
      String base64String = base64Encode(bytes);
      base64Strings.add(base64String);
    }

    for (String filePath in cameraFilePaths) {
      File file = File(filePath);
      List<int> bytes = file.readAsBytesSync();
      String base64String = base64Encode(bytes);
      base64StringCameraFilePaths.add(base64String);
    }

    List<String> imagesLocal = [];
    //Upload all images and get image path of uploaded file, save that in a local list
    for (var element in listSelectedAssetsImages) {
      MultipartFile file = await MultipartFile.fromFile(element!.path, filename: element.name);
      // imagesLocal.add(file.);
    }

    //convert list of paths to base64

    //list of converted paths assign to variable in API call

    var request;
    if (markerId?.isNotEmpty == true) {
      request = AddAssetsRequest(
        assetTypeID: '${assetType?.assetTypeID}',
        tagNumber: tagNumberController.text.trim(),
        description: descriptionController.text.trim(),
        serviceLineID: '$serviceLineID',
        ownerOrgID: '$organizationID',
        ownerContactID: '$ownerContactID',
        maintainerOrgID: '$maintainerOrganizationID',
        locationID: markerId ?? '',
        currencyID: '$currencyID',
        assetOEM: '1',
        modelNumber: modelNumberController.text.trim(),
        serialNumber: serialNumberController.text.trim(),
        purchasePrice: purchasePriceController.text.trim(),
        warranty: warrantyController.text.trim(),
        assetPhotos: base64Strings.isNotEmpty == true ? base64Strings : base64StringCameraFilePaths,
        spareParts: spareParts,
        assetStateID: '$assetStateID',
        assetStateComments: assetStateCommentsController.text.trim(),
        assetAttributes: assetAttributes,
      );
    } else {
      request = AddAssetsRequest(
        assetTypeID: '${assetType?.assetTypeID}',
        tagNumber: tagNumberController.text.trim(),
        description: descriptionController.text.trim(),
        serviceLineID: '$serviceLineID',
        ownerOrgID: '$organizationID',
        ownerContactID: '$ownerContactID',
        maintainerOrgID: '$maintainerOrganizationID',
        location: Location(
          // locationTypeID: '$locationTypeID',
          locationTypeID: '1',
          locationUsageID: '$locationUsageID',
          continentID: '3',
          countryID: '235',
          geoLoc: GeoLoc(
            posLat: '$latitude',
            posLong: '$longitude',
          ),
        ),
        currencyID: '$currencyID',
        assetOEM: '1',
        modelNumber: modelNumberController.text.trim(),
        serialNumber: serialNumberController.text.trim(),
        purchasePrice: purchasePriceController.text.trim(),
        warranty: warrantyController.text.trim(),
        assetPhotos: base64Strings.isNotEmpty == true ? base64Strings : base64StringCameraFilePaths,
        spareParts: spareParts,
        assetStateID: '$assetStateID',
        assetStateComments: assetStateCommentsController.text.trim(),
        assetAttributes: assetAttributes,
      );
    }

    var jsonRequest = jsonEncode(request);
    var base64EncodedRequest = base64.encode(utf8.encode(jsonRequest));
    log('base64EncodedRequest: $base64EncodedRequest');
    try {
      setState(() {
        isLocationsLoading = true;
      });
      log('Selected Asset Name: ${assetType?.name},ID: ${assetType?.assetTypeID}');
      isRequestLoading = true;
      var addAssetsDecodedRequest = AddAssetsDecodedRequest(inputParameters: base64EncodedRequest);
      var response = await _addEstateRepository.postAsset(addAssetsDecodedRequest);

      if (response.status == 200) {
        setState(() {
          isRequestLoading = false;
        });
        showSnackBar(context, response.description);

        // String? encoded = response.data;
        // String decoded = utf8.decode(base64.decode(encoded ?? ''));
        // List<dynamic> decodedJson = json.decode(decoded);
      } else {
        setState(() {
          isRequestLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        isRequestLoading = false;
      });
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog.adaptive(
            backgroundColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 30,
              horizontal: 30,
            ),
            content: const Text(
              AppConstants.sessionExpiredInactivity,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            actions: <Widget>[
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  onPressed: () async {
                    await SessionManager.setIsUserLogin(false);
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                        (route) => false);
                  },
                  child: isLoading == false
                      ? Text(
                          AppConstants.reLogin,
                          style: TextStyle(
                            fontSize: 17,
                            color: AppColors.whiteColor,
                          ),
                        )
                      : SizedBox(
                          height: 30,
                          width: 30,
                          child: CircularProgressIndicator(
                            color: AppColors.whiteColor,
                            strokeWidth: 3.5,
                          ),
                        ),
                ),
              ),
            ],
          );
        },
      );
      showSnackBar(context, '$error');
      log('Error: $error');
      // showSnackBar(context, '${error.toString()}');
    }
  }

  /// Options of image selection
  void _showAssetActionSheet({required BuildContext context}) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            isDefaultAction: false,
            onPressed: () {
              Navigator.pop(context);
              MultipleImageCamera.capture(
                context: context,
              ).then((value) {
                log('Value length: ${value.length}');
                setState(() {
                  imagesOfAssert = value;
                  log('imagesOfAssert.length: ${imagesOfAssert.length}');
                });
              });
            },
            child: const Text(AppConstants.camera),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              pickImage(source: ImageSource.gallery);
            },
            child: const Text(AppConstants.gallery),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(AppConstants.cancel),
          ),
        ],
      ),
    );
  }

  void _showLocationActionSheet({required BuildContext context}) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            isDefaultAction: false,
            onPressed: () {
              Navigator.pop(context);
              MultipleImageCamera.capture(
                context: context,
              ).then((value) {
                log('imagesOfLocation Value length: ${value.length}');
                setState(() {
                  imagesOfLocation = value;
                  log('imagesOfLocation.length: ${imagesOfLocation.length}');
                });
              });
            },
            child: const Text(AppConstants.camera),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              pickLocationImage(source: ImageSource.gallery);
            },
            child: const Text(AppConstants.gallery),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(AppConstants.cancel),
          ),
        ],
      ),
    );
  }

  /// Pick images selection and loader
  pickImage({required ImageSource source}) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          width: double.maxFinite,
          padding: const EdgeInsets.symmetric(vertical: 40),
          color: AppColors.whiteColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: ShowLoader(
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),
        );
      },
    );

    MediaSelector().openMediaPicker(context, source: source, pickMultiple: true, callBack: (file) {
      if (!(file?.isEmpty ?? true)) {
        setState(
          () {
            listSelectedAssetsImages = file ?? [];
            for (var element in listSelectedAssetsImages) {
              final bytes = File(element!.path).readAsBytesSync().lengthInBytes;
              final kb = bytes / 1024;
              log('****** ${element.path} ******::$kb kb');
            }
          },
        );
      }
      Navigator.of(context).pop();
    }, isCropImage: false);
  }

  pickLocationImage({required ImageSource source}) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          width: double.maxFinite,
          padding: const EdgeInsets.symmetric(vertical: 40),
          color: AppColors.whiteColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: ShowLoader(
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),
        );
      },
    );

    MediaSelector().openMediaPicker(context, source: source, pickMultiple: true, callBack: (file) async {
      if (file != null && file.isNotEmpty) {
        setState(() {
          // listLocationImages = file;
          listLocationImages = file;
          for (var element in listLocationImages) {
            final bytes = File(element!.path).readAsBytesSync().lengthInBytes;
            final kb = bytes / 1024;
            log('****** ${element.path} ******::$kb kb');
            log('listLocationImage length: ${listLocationImages.length}');
          }
        });

        // for (var file in listLocationImages) {
        //   if (file != null) {
        //     Uint8List? compressedBytes = await FlutterImageCompress.compressWithFile(
        //       file.path,
        //       minWidth: 1024,
        //       minHeight: 1024,
        //       quality: 85,
        //     );
        //
        //     if (compressedBytes != null) {
        //       final kb = compressedBytes.lengthInBytes / 1024;
        //
        //       print('****** ${file.path} Compressed Size ******: $kb kb');
        //     }
        //   }
        // }
      }
      Navigator.of(context).pop();
    }, isCropImage: false);
  }

  // Future<Position?> determinePosition() async {
  //   LocationPermission permission;
  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.deniedForever) {
  //       showSnackBar(context, AppConstants.enableLocationPermission);
  //       return null;
  //     }
  //   } else if (permission == LocationPermission.unableToDetermine) {
  //     return null;
  //   }
  //   return await Geolocator.getCurrentPosition();
  // }

  Future<void> handleLocationPermissionAndNavigate() async {
    setState(() {
      isProcessing = true;
    });
    Position? position = await determinePosition();
    if (position != null && mounted) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreateLocationMap(position: position),
        ),
      );
      if (result != null) {
        setState(() {
          selectedLocation = result;
        });
        latitude = selectedLocation?.latitude;
        longitude = selectedLocation?.longitude;
        log('Create location latitude:: $latitude, longitude:: $longitude');
      }
    }
    setState(() {
      isProcessing = false;
    });
  }

  Future<void> handleExistingLocationPermissionAndNavigate() async {
    setState(() {
      isProcessing = true;
    });
    Position? position = await determinePosition();

    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExistingLocationMap(
          listExistingLocationResponse: listExistingLocationResponse,
          position: position,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        selectedLocation = result['position'];
        markerId = result['id'];
      });
      latitude = selectedLocation?.latitude;
      longitude = selectedLocation?.longitude;

      log('Existing latitude:: $latitude, longitude:: $longitude');
    }
    setState(() {
      isProcessing = false;
    });
  }

  Future<Position?> determinePosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        showSnackBar(context, AppConstants.enableLocationPermission);
        log('LocationPermission.deniedForever:::');
        return null;
      }
      // } else if (permission == LocationPermission.denied) {
      //   permission = await Geolocator.requestPermission();
      //
      //   // showSnackBar(context, AppConstants.enableLocationPermission);
      //   return null;
      // }
    }

    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      try {
        return await Geolocator.getCurrentPosition();
      } catch (e) {
        showSnackBar(context, 'Error getting location: $e');
        return null;
      }
    }

    // showSnackBar(context, 'Location permission not granted.');
    return null;
  }
}
