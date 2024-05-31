import 'dart:convert';
import 'dart:developer';

import 'package:am_sys/data/repository/add_estate_repository.dart';
import 'package:am_sys/model/add_assert_request/add_assert_decoded_request_.dart';
import 'package:am_sys/model/add_assert_request/assert_detail_request.dart';
import 'package:am_sys/model/add_assert_request/assert_detail_response.dart';
import 'package:am_sys/model/asset_response/assert_response.dart';
import 'package:am_sys/model/asset_states_decode_data/asset_states_decode_data.dart';
import 'package:am_sys/utils/app_consts/app_consts.dart';
import 'package:am_sys/utils/colors/app_colors.dart';
import 'package:am_sys/utils/custom_drop_down/custom_drop_down.dart';
import 'package:am_sys/utils/custom_linear_loader/custom_linear_loader.dart';
import 'package:am_sys/utils/marker/map_marker.dart';
import 'package:am_sys/utils/snack_bar/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fluster/fluster.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(45.521563, -122.677433);
  final AddEstateRepository _addEstateRepository = AddEstateRepository();
  bool isAssetLoading = true;

  List<ParentAssetResponse> listParentAssetResponse = [];

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  // final List<MapMarker> markers = [];
  //
  // List<Marker> googleMarkers = [];
  //
  // markerShow() {
  //   for (LatLng markerLocation in listParentAssetResponse.map((e) => LatLng(e.latitude ?? 0.0, e.longitude ?? 0.0))) {
  //     markers.add(
  //       MapMarker(
  //         id: listParentAssetResponse.map((e) => e.assetID).toList().toString(),
  //         position: LatLng(markerLocation.latitude, markerLocation.longitude),
  //       ),
  //     );
  //   }
  // }

  @override
  void initState() {
    getAssetData();
    super.initState();
    // final Fluster<MapMarker> fluster = Fluster<MapMarker>(
    //   minZoom: 5,
    //   // The min zoom at clusters will show
    //   maxZoom: 14,
    //   // The max zoom at clusters will show
    //   radius: 150,
    //   // Cluster radius in pixels
    //   extent: 2048,
    //   // Tile extent. Radius is calculated with it.
    //   nodeSize: 64,
    //   // Size of the KD-tree leaf node.
    //   points: markers,
    //   // The list of markers created before
    //   createCluster: (
    //     // Create cluster marker
    //     BaseCluster cluster,
    //     double lng,
    //     double lat,
    //   ) =>
    //       MapMarker(
    //     id: cluster.id.toString(),
    //     position: LatLng(lat, lng),
    //     isCluster: cluster.isCluster,
    //     clusterId: cluster.id,
    //     pointsSize: cluster.pointsSize,
    //     childMarkerId: cluster.childMarkerId,
    //   ),
    // );
    // markerShow();
    // googleMarkers = fluster.clusters([-180, -85, 180, 85], 11).map((cluster) => cluster.toMarker()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.45,
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              // markers: googleMarkers.toSet(),

              markers: Set<Marker>.of(
                listParentAssetResponse.map(
                  (asset) {
                    return Marker(
                      markerId: MarkerId(asset.assetID),
                      position: LatLng(asset.latitude ?? 0.0, asset.longitude ?? 0.0),
                    );
                  },
                ),
              ),
              initialCameraPosition: const CameraPosition(
                target: LatLng(23.022505, 72.571365),
                zoom: 11.0,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: listParentAssetResponse.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    _showDetailBottomSheet(context, listParentAssetResponse[index].assetID);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 110,
                          height: 110,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: const BoxDecoration(
                              color: Colors.grey,
                            ),
                            child: Image.network(
                              listParentAssetResponse[index].photo ?? AppConstants.placeHolderImage,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                listParentAssetResponse[index].assetTypeName ?? '',
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                listParentAssetResponse[index].description ?? '',
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
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
      showSnackBar(context, ' ${error.toString()}');
    }
  }

  // void _showModalBottomSheet(BuildContext context) {
  //   showModalBottomSheet<void>(
  //     isScrollControlled: true,
  //     context: context,
  //     builder: (BuildContext context) {
  //       return SingleChildScrollView(
  //         child: SizedBox(
  //           height: MediaQuery.of(context).size.height * 0.5,
  //           width: double.infinity,
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             mainAxisSize: MainAxisSize.min,
  //             children: <Widget>[
  //               Align(
  //                 alignment: AlignmentDirectional.topEnd,
  //                 child: Padding(
  //                   padding: const EdgeInsets.all(8.0),
  //                   child: IconButton(
  //                     onPressed: () => Navigator.of(context).pop(),
  //                     icon: const Icon(
  //                       Icons.cancel_outlined,
  //                       color: Colors.black,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //               const Expanded(
  //                 child: Padding(
  //                   padding: EdgeInsets.symmetric(horizontal: 20),
  //                   child: Column(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       // Your content here
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //               Align(
  //                 alignment: Alignment.bottomCenter,
  //                 child: Padding(
  //                   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //                   child: SizedBox(
  //                     width: double.infinity,
  //                     height: 50,
  //                     child: ElevatedButton(
  //                       style: ElevatedButton.styleFrom(
  //                         backgroundColor: AppColors.blackColor,
  //                         shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(12.0),
  //                         ),
  //                       ),
  //                       onPressed: () => Navigator.pop(context),
  //                       child: Text(
  //                         AppConstants.cancel,
  //                         style: TextStyle(
  //                           fontSize: 17,
  //                           color: AppColors.whiteColor,
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  _showDetailBottomSheet(BuildContext detailBottomSheetContext, String assetID) {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: detailBottomSheetContext,
      builder: (BuildContext bottomSheetContext) {
        return ModelSheetOfDetails(assetID: assetID);
      },
    );
  }
}






class ModelSheetOfDetails extends StatefulWidget {
  const ModelSheetOfDetails({super.key, required this.assetID});

  final String assetID;

  @override
  State<ModelSheetOfDetails> createState() => _ModelSheetOfDetailsState();
}

class _ModelSheetOfDetailsState extends State<ModelSheetOfDetails> {
  final AddEstateRepository _addEstateRepository = AddEstateRepository();
  bool isAssertDetailRequestLoading = true;
  AssertDetailResponse? assertDetailResponse;
  static const textStyle = TextStyle(
    color: Colors.black,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
  final GlobalKey<FormState> homePageGlobalKey = GlobalKey<FormState>();
  bool isAssetStatesLoading = true;
  bool isUpdateStateLoading = false;

  @override
  void initState() {
    getAssetDetailData(assetID: widget.assetID);
    getAssetStatesData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text(
                    AppConstants.details,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.cancel_outlined,
                    color: Colors.black,
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 20,
              ),
              child: isAssertDetailRequestLoading == false
                  ? Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: SizedBox(
                                    width: 140,
                                    height: 140,
                                    child: Container(
                                      width: 100,
                                      height: 100,
                                      decoration: const BoxDecoration(
                                        color: Colors.grey,
                                      ),
                                      child: Image.network(
                                        (assertDetailResponse?.photos ?? []).isNotEmpty
                                            ? assertDetailResponse?.photos?.elementAt(0) ?? ''
                                            : AppConstants.placeHolderImage,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'AssetName:',
                                      style: textStyle,
                                    ),
                                    Text(
                                      assertDetailResponse?.assetType?.name ?? '',
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: textStyle,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Description:',
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                      style: textStyle,
                                    ),
                                    Text(
                                      assertDetailResponse?.description ?? '',
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                      style: textStyle,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'ISOCode & PurchasePrice:',
                                      style: textStyle,
                                    ),
                                    Text(
                                      '${assertDetailResponse?.purchaseCurrency?.isoCode ?? ''}, ${assertDetailResponse?.purchasePrice}',
                                      style: textStyle,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Warranty:',
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                      style: textStyle,
                                    ),
                                    Text(
                                      assertDetailResponse?.warranty ?? '',
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                      style: textStyle,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Asset State:',
                                      style: textStyle,
                                    ),
                                    Text(
                                      assertDetailResponse?.assetState?.state ?? '',
                                      style: textStyle,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                const Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'AttributeNames:',
                                    style: textStyle,
                                  ),
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: assertDetailResponse?.assetAttributes?.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const SizedBox(height: 5),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${assertDetailResponse?.assetAttributes?[index].assetTypeAttributeName ?? ''}:',
                                              style: textStyle,
                                            ),
                                            Text(
                                              assertDetailResponse?.assetAttributes?[index].assetAttributeValue ?? '',
                                              style: textStyle,
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Created by:',
                                      style: textStyle,
                                    ),
                                    Text(
                                      assertDetailResponse?.assetCreatedBy?.displayName ?? '',
                                      style: textStyle,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),
                        // const Spacer(),
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
                              _showModalBottomSheet(context, widget.assetID);
                            },
                            child: Text(
                              AppConstants.updateEstate,
                              style: TextStyle(
                                fontSize: 17,
                                color: AppColors.whiteColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getAssetDetailData({required String assetID}) async {
    Map<String, String> requestAssetId = {
      "assetID": assetID,
    };

    String jsonCredentials = json.encode(requestAssetId);
    Codec<String, String> stringToBase64Url = utf8.fuse(base64Url);
    String encodedId = stringToBase64Url.encode(jsonCredentials);

    /// Header in pass input-parameters
    AppConstants.encodedValue = encodedId;
    log('requestAssetId: $encodedId');

    try {
      var request = AssertDetailRequest(assetID: encodedId);
      var response = await _addEstateRepository.getAssetDetailData(request);

      if (response.status == 200) {
        setState(() {
          isAssertDetailRequestLoading = false;
        });

        String? encoded = response.data;
        String decoded = utf8.decode(base64.decode(encoded ?? ''));
        // Map<String, dynamic> decodedJson = json.decode(decoded);
        AssertDetailResponse mAssertDetailResponse = assertDetailResponseFromMap(decoded);

        assertDetailResponse = mAssertDetailResponse;
      } else {
        setState(() {
          isAssertDetailRequestLoading = false;
        });
        showSnackBar(context, response.description);
      }
    } catch (error) {
      setState(() {
        isAssertDetailRequestLoading = false;
      });

      log('Error: $error');
      showSnackBar(context, error.toString());
    }
  }

  List<AssetStatesDecodeData> listAssetStatesDecodeData = [];
  AssetStatesDecodeData? assetStatesDecodeData;
  String? assetStateID;
  TextEditingController commentController = TextEditingController();

  void _submit(String message) {
    Navigator.of(context).pop();
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog.adaptive(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
        content: SizedBox(
          height: 150,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.of(context).pop();
    });
  }

  void _showModalBottomSheet(BuildContext dialogContext, String assetID) {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: dialogContext,
      builder: (BuildContext bottomSheetContext) {
        return UpdateStateData(
          assetID: assetID,
          context: context,
        );
      },
    );
  }

  Future<void> updateStateData({required String assetID}) async {
    setState(() {
      isUpdateStateLoading = true;
    });
    log('assetStateID:: $assetID, dataType:: ${assetID.runtimeType}');
    Map<String, String> requestUpdateState = {
      "assetID": ' ${assetID}',
      "stateID": assetStateID.toString(),
      "comments": commentController.text.trim(),
    };

    String jsonCredentials = json.encode(requestUpdateState);
    Codec<String, String> stringToBase64Url = utf8.fuse(base64Url);
    String encodedRequestUpdateState = stringToBase64Url.encode(jsonCredentials);

    /// Header in pass input-parameters
    AppConstants.encodedValue = encodedRequestUpdateState;
    log('encodedRequestUpdateState: $encodedRequestUpdateState');

    try {
      var request = AddAssetsDecodedRequest(inputParameters: encodedRequestUpdateState);
      var response = await _addEstateRepository.updateStateData(request);

      if (response.status == 200) {
        setState(() {
          isUpdateStateLoading = false;
        });

        String? encoded = response.data;
        String decoded = utf8.decode(base64.decode(encoded ?? ''));
        // Map<String, dynamic> decodedJson = json.decode(decoded);
      } else {
        setState(() {
          isUpdateStateLoading = false;
        });
        showSnackBar(context, response.description);
      }
    } catch (error) {
      setState(() {
        isUpdateStateLoading = false;
      });

      log('Error: $error');
      showSnackBar(context, error.toString());
    }
  }

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

        // List<AssetStatesDecodeData> assetStates = decodedJson.map((data) => AssetStatesDecodeData.fromJson(data)).toList();
        List<AssetStatesDecodeData> assetStates = decodedJson.map((data) => AssetStatesDecodeData.fromJson(data)).toList();
        listAssetStatesDecodeData = assetStates;
        // listAssetStates = assetStates.map((assetState) => assetState.state).toList();
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
}

class UpdateStateData extends StatefulWidget {
  const UpdateStateData({super.key, required this.assetID, required this.context});

  final String assetID;
  final BuildContext context;

  @override
  State<UpdateStateData> createState() => _UpdateStateDataState();
}

class _UpdateStateDataState extends State<UpdateStateData> {
  final GlobalKey<FormState> homePageGlobalKey = GlobalKey<FormState>();
  bool isAssetStatesLoading = true;
  AssetStatesDecodeData? assetStatesDecodeData;
  String? assetStateID;
  List<AssetStatesDecodeData> listAssetStatesDecodeData = [];
  TextEditingController commentController = TextEditingController();
  final AddEstateRepository _addEstateRepository = AddEstateRepository();
  bool isUpdateStateLoading = false;
  bool isSnackBarShowing = false;
  String snackBarMessage = '';

  @override
  void initState() {
    getAssetStatesData();
    super.initState();
  }

  @override
  Widget build(BuildContext cnt) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: MediaQuery.of(cnt).size.height * 0.7,
          width: double.infinity,
          child: Form(
            key: homePageGlobalKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Align(
                  alignment: AlignmentDirectional.topEnd,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      onPressed: Navigator.of(cnt).pop,
                      icon: const Icon(
                        Icons.cancel_outlined,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: AnimatedCrossFade(
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
                            assetStateID = assetStatesDecodeData?.assetStateID;
                            log("Home assetStateID: ${assetStatesDecodeData?.assetStateID}");
                            log("Home state: ${assetStatesDecodeData?.state}");
                          }
                        });
                      },
                      items: listAssetStatesDecodeData.map((e) => e.state).toList(),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),

                /// Comment
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    validator: (value) {
                      return (value == null || value.isEmpty) ? "Field required" : null;
                    },
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.done,
                    controller: commentController,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(510),
                    ],
                    decoration: InputDecoration(
                      alignLabelWithHint: true,
                      label: const Text(AppConstants.assetStateComments),
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
                  ),
                ),

                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    bottom: 20,
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
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
                                if (homePageGlobalKey.currentState!.validate()) {
                                  log('Form validate : true ');
                                  setState(() {
                                    isUpdateStateLoading = true;
                                  });
                                  await updateStateData(assetID: widget.assetID, cnt: cnt);

                                  Navigator.pop(context);
                                  _submit("Your data has been updated successfully.");
                                } else {
                                  log('Form validate : false ');
                                }
                              },
                              child: isUpdateStateLoading == true
                                  ? SizedBox(
                                      height: 30,
                                      width: 30,
                                      child: CircularProgressIndicator(
                                        color: AppColors.whiteColor,
                                        strokeWidth: 3.5,
                                      ),
                                    )
                                  : Text(
                                      AppConstants.submit,
                                      style: TextStyle(
                                        fontSize: 17,
                                        color: AppColors.whiteColor,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.blackColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                              onPressed: () => Navigator.pop(cnt),
                              child: Text(
                                AppConstants.cancel,
                                style: TextStyle(
                                  fontSize: 17,
                                  color: AppColors.whiteColor,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedContainer(
          color: AppColors.blackColor,
          width: double.infinity,
          height: isSnackBarShowing ? 30 : 0,
          duration: const Duration(milliseconds: 300),
          child: Text(
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
            snackBarMessage,
          ),
        ),
      ],
    );
  }

  void _submit(String message) {
    Navigator.of(context).pop();
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog.adaptive(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
        content: SizedBox(
          height: 150,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

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

        // List<AssetStatesDecodeData> assetStates = decodedJson.map((data) => AssetStatesDecodeData.fromJson(data)).toList();
        List<AssetStatesDecodeData> assetStates = decodedJson.map((data) => AssetStatesDecodeData.fromJson(data)).toList();
        listAssetStatesDecodeData = assetStates;
        // listAssetStates = assetStates.map((assetState) => assetState.state).toList();
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

  Future<void> updateStateData({required String assetID, required BuildContext cnt}) async {
    log('assetStateID:: $assetID, dataType:: ${assetID.runtimeType}');
    Map<String, String> requestUpdateState = {
      "assetID": assetID,
      "stateID": assetStateID.toString(),
      "comments": commentController.text.trim(),
    };

    String jsonCredentials = json.encode(requestUpdateState);
    Codec<String, String> stringToBase64Url = utf8.fuse(base64Url);
    String encodedRequestUpdateState = stringToBase64Url.encode(jsonCredentials);

    /// Header in pass input-parameters
    AppConstants.encodedValue = encodedRequestUpdateState;
    log('encodedRequestUpdateState: $encodedRequestUpdateState');

    try {
      var request = AddAssetsDecodedRequest(inputParameters: encodedRequestUpdateState);
      var response = await _addEstateRepository.updateStateData(request);

      if (response.status == 200) {
        String? encoded = response.data;
        String decoded = utf8.decode(base64.decode(encoded ?? ''));
        log('Message: $decoded');
        // Map<String, dynamic> decodedJson = json.decode(decoded);
      } else {
        snackBarMessage = response.description;
        if (mounted) {
          setState(() {
            isSnackBarShowing = true;
          });
        }

        Future.delayed(
          const Duration(seconds: 3),
          () {
            if (mounted) {
              setState(() {
                isSnackBarShowing = false;
              });
            }
          },
        );
        // showSnackBar(widget.context, response.description);
      }

      if (mounted) {
        setState(() {
          isUpdateStateLoading = false;
        });
      }
    } catch (error) {
      snackBarMessage = error.toString();
      if (mounted) {
        setState(() {
          isUpdateStateLoading = false;
          isSnackBarShowing = true;
        });
      }

      log('Error: $error');
      Future.delayed(
        const Duration(seconds: 3),
        () {
          if (mounted) {
            setState(() {
              isSnackBarShowing = false;
            });
          }
        },
      );
      //showSnackBar(widget.context, error.toString());
    }
  }
}
