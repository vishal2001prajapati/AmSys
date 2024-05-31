import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:am_sys/data/repository/add_estate_repository.dart';
import 'package:am_sys/model/add_assert_request/add_assert_decoded_request_.dart';
import 'package:am_sys/model/add_assert_request/assert_detail_request.dart';
import 'package:am_sys/model/add_assert_request/assert_detail_response.dart';
import 'package:am_sys/model/asset_response/assert_response.dart';
import 'package:am_sys/model/asset_states_decode_data/asset_states_decode_data.dart';
import 'package:am_sys/screens/login_screen/view/login_page.dart';
import 'package:am_sys/utils/app_consts/app_consts.dart';
import 'package:am_sys/utils/colors/app_colors.dart';
import 'package:am_sys/utils/custom_drop_down/custom_drop_down.dart';
import 'package:am_sys/utils/custom_linear_loader/custom_linear_loader.dart';
import 'package:am_sys/utils/map_helper/map_helper.dart';
import 'package:am_sys/utils/session_manager/session_manager.dart';
import 'package:am_sys/utils/snack_bar/snack_bar.dart';
import 'package:fluster/fluster.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class ClusterMapScreen extends StatefulWidget {
  const ClusterMapScreen({super.key});

  @override
  _ClusterMapScreenState createState() => _ClusterMapScreenState();
}

class _ClusterMapScreenState extends State<ClusterMapScreen> with WidgetsBindingObserver {
  final AddEstateRepository _addEstateRepository = AddEstateRepository();
  List<ParentAssetResponse> listParentAssetResponse = [];
  final Completer<GoogleMapController> _mapController = Completer();
  bool isAssetLoading = true;
  Position? position;

  /// Set of displayed markers and cluster markers on the map
  final Set<Marker> _markers = {};

  /// Minimum zoom at which the markers will cluster
  final int _minClusterZoom = 0;

  /// Maximum zoom at which the markers will cluster 19
  final int _maxClusterZoom = 19;

  /// [Fluster] instance used to manage the clusters
  Fluster<MapMarker>? _clusterManager;

  /// Current map zoom. Initial zoom will be 15, street level
  double _currentZoom = 5;

  /// Map loading flag
  bool _isMapLoading = true;

  /// Markers loading flag
  bool _areMarkersLoading = true;
  bool _checkingPermission = true;

  /// Url image used on normal markers
  final String _markerImageUrl = 'https://img.icons8.com/office/80/000000/marker.png';

  /// Color of the cluster circle
  final Color _clusterColor = Colors.blue;

  /// Color of the cluster text
  final Color _clusterTextColor = Colors.white;

  /// Example marker coordinates
  final List<LatLng> _markerLocations = [];
  LatLng? _center;

  /// Called when the Google Map widget is created. Updates the map loading state
  /// and inits the markers.
  void _onMapCreated(GoogleMapController controller) {
    _mapController.complete(controller);

    setState(() {
      _isMapLoading = false;
    });

    // _initMarkers();
    _initMarkersNew();
  }

  /// Inits [Fluster] and all the markers with network images and updates the loading state.

  // void _initMarkers() async {
  //   final List<MapMarker> markers = [];
  //
  //   for (LatLng markerLocation in _markerLocations) {
  //     final BitmapDescriptor markerImage = await MapHelper.getMarkerImageFromUrl(_markerImageUrl);
  //
  //     markers.add(
  //       MapMarker(
  //         id: _markerLocations.indexOf(markerLocation).toString(),
  //         position: markerLocation,
  //         icon: markerImage,
  //       ),
  //     );
  //   }
  //
  //   _clusterManager = await MapHelper.initClusterManager(
  //     markers,
  //     _minClusterZoom,
  //     _maxClusterZoom,
  //   );
  //
  //   await _updateMarkers();
  // }

  _initMarkersNew() async {
    final List<MapMarker> markers = [];
    log('listParentAssetResponse length : ${listParentAssetResponse.length}');
    for (LatLng markerLocation in _markerLocations) {
      final BitmapDescriptor markerImage = await MapHelper.getMarkerImageFromUrl(_markerImageUrl);
      // log('listParentAssetResponse: ${asset.latitude}, ${asset.longitude}');
      markers.add(
        MapMarker(
          id: _markerLocations.indexOf(markerLocation).toString(),
          position: markerLocation,
          icon: markerImage,
          onTap: () {
            _showDetailBottomSheet();
            log('Marker Tap:::::::::::::');
          },
        ),
      );
    }
    log('markers length : ${markers.length}');

    _clusterManager = await MapHelper.initClusterManager(
      markers,
      _minClusterZoom,
      _maxClusterZoom,
      () {
        _showDetailBottomSheet();
        log('_clusterManager Tap:::::::::::::');
      },
    );

    await _updateMarkers();
  }

  /// Gets the markers and clusters to be displayed on the map for the current zoom level and
  /// updates state.
  Future<void> _updateMarkers([double? updatedZoom]) async {
    if (_clusterManager == null || updatedZoom == _currentZoom) return;

    if (updatedZoom != null) {
      _currentZoom = updatedZoom;
    }

    setState(() {
      _areMarkersLoading = true;
    });

    final updatedMarkers = await MapHelper.getClusterMarkers(
      _clusterManager,
      _currentZoom,
      _clusterColor,
      _clusterTextColor,
      80,
    );

    _markers
      ..clear()
      ..addAll(updatedMarkers);

    log('markers final list : ${_markers.length}');

    setState(() {
      _areMarkersLoading = false;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);

    getCurrentLocation();
    getAssetData();

    super.initState();
  }

  getCurrentLocation() async {
    setState(() {
      _checkingPermission = true;
    });
    position = await determinePosition();
    _center = LatLng(position?.latitude ?? 0.0, position?.longitude ?? 0.0);

    setState(() {
      _checkingPermission = false;
    });
  }

  Future<Position?> determinePosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      log('permission status:::::::: $permission');
      if (permission == LocationPermission.denied) {
        await openSetting();
      }
    } else if (permission == LocationPermission.deniedForever) {
      await openSetting();
      showSnackBar(context, 'Please enable location permission');
      return null;
    } else if (permission == LocationPermission.unableToDetermine) {
      return null;
    }
    return await Geolocator.getCurrentPosition();
  }

  openSetting() async {
    await openAppSettings().then((value) {
      print('settings result ::: $value');
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Check permissions again when the app is resumed
      getCurrentLocation();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('build call::::::::::::::::::::');
    return Scaffold(
      body: Stack(
        children: <Widget>[
          isAssetLoading || _checkingPermission
              ? Container()
              : Opacity(
                  opacity: _isMapLoading ? 0 : 1,
                  child: GoogleMap(
                    mapToolbarEnabled: true,
                    zoomGesturesEnabled: true,
                    myLocationButtonEnabled: true,
                    myLocationEnabled: true,
                    zoomControlsEnabled: true,
                    initialCameraPosition: CameraPosition(
                      // target: LatLng(22.981572065977723, 72.50426977872849),
                      target: _center!,
                      zoom: _currentZoom,
                    ),
                    markers: _markers,
                    onMapCreated: (controller) => _onMapCreated(controller),
                    onCameraMove: (position) => _updateMarkers(position.zoom),
                  ),
                ),

          // Map loading indicator
          Opacity(
            opacity: _isMapLoading ? 1 : 0,
            child: const Center(child: CircularProgressIndicator()),
          ),

          // Map markers loading indicator
          if (_areMarkersLoading)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Card(
                  elevation: 2,
                  color: Colors.grey.withOpacity(0.9),
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Text(
                      'Loading',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// API of Asset
  Future<List<LatLng>> getAssetData() async {
    try {
      var response = await _addEstateRepository.getAssetData();

      if (response.status == 200) {
        String? encoded = response.data;
        String decoded = utf8.decode(base64.decode(encoded ?? ''));
        // List<dynamic> decodedJson = json.decode(decoded);
        List<ParentAssetResponse> parentAssetResponseList = ParentAssetResponse.fromDecodedJson(decoded);
        listParentAssetResponse = parentAssetResponseList;
        _markerLocations.clear();

        for (var asset in listParentAssetResponse) {
          if (asset.latitude != null && asset.longitude != null) {
            _markerLocations.add(LatLng(asset.latitude!, asset.longitude!));

            log('latitude: ${asset.latitude!}, longitude: ${asset.longitude!}');
          }
        }
        // _markerLocations.addAll([
        //   LatLng(41.147125, -8.611249),
        //   LatLng(41.145599, -8.610691),
        //   LatLng(41.145645, -8.614761),
        //   LatLng(22.981572065977723, 72.50426977872849),
        //   LatLng(22.98357206597772, 72.51426977872849),
        //   LatLng(22.98357206597772, 72.51426977872849),
        //   LatLng(23.079460, 72.506218),
        // ]);
        setState(() {
          isAssetLoading = false;
        });
        log('_markerLocations length: ${_markerLocations.length!}');
      } else {
        setState(() {
          isAssetLoading = false;
        });
        //  showSnackBar(context, response.description);
      }
      return _markerLocations;
    } catch (error) {
      setState(() {
        isAssetLoading = false;
      });

      log('Error: $error');
      showSnackBar(context, ' ${error.toString()}');
    }
    return _markerLocations;
  }

  _showDetailBottomSheet() {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext bottomSheetContext) {
        return const ShowListViewData();
      },
    );
  }
}

class ShowListViewData extends StatefulWidget {
  const ShowListViewData({super.key});

  @override
  State<ShowListViewData> createState() => _ShowListViewDataState();
}

class _ShowListViewDataState extends State<ShowListViewData> {
  bool isAssetLoading = true;
  List<ParentAssetResponse> listParentAssetResponse = [];

  final AddEstateRepository _addEstateRepository = AddEstateRepository();

  @override
  void initState() {
    getAssetData();
    super.initState();
  }

  _showDetailBottomSheet(BuildContext detailBottomSheetContext, String assetID) {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: detailBottomSheetContext,
      builder: (BuildContext bottomSheetContext) {
        return DetailModelSheetOfDetails(assetID: assetID);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          children: [
            Align(
              alignment: AlignmentDirectional.topEnd,
              child: IconButton(
                onPressed: Navigator.of(context).pop,
                icon: const Icon(
                  Icons.cancel_outlined,
                  color: Colors.black,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: listParentAssetResponse.length,
                itemBuilder: (ctx, index) {
                  return InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      _showDetailBottomSheet(context, listParentAssetResponse[index].assetID);
                      log('listParentAssetResponse[index].assetID::: ${listParentAssetResponse[index].assetID}');
                    },
                    child: Card(
                      elevation: 2.8,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(15.0),
                                    child: SizedBox(
                                      width: 120,
                                      height: 100,
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
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          listParentAssetResponse[index].assetTypeName,
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: AppConstants.detailTxtStyle,
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          listParentAssetResponse[index].description ?? '',
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: AppConstants.descriptionTextStyle,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.arrow_right_alt,
                              size: 35,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
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
}

class DetailModelSheetOfDetails extends StatefulWidget {
  const DetailModelSheetOfDetails({super.key, required this.assetID});

  final String assetID;

  @override
  State<DetailModelSheetOfDetails> createState() => _DetailModelSheetOfDetailsState();
}

class _DetailModelSheetOfDetailsState extends State<DetailModelSheetOfDetails> {
  final AddEstateRepository _addEstateRepository = AddEstateRepository();
  bool isAssertDetailRequestLoading = true;
  AssertDetailResponse? assertDetailResponse;

  final GlobalKey<FormState> homePageGlobalKey = GlobalKey<FormState>();
  bool isAssetStatesLoading = true;
  bool isUpdateStateLoading = true;
  String formattedDate = '';
  List<AssetStatesDecodeData> listAssetStatesDecodeData = [];
  TextEditingController commentController = TextEditingController();
  AssetStatesDecodeData? assetStatesDecodeData;
  String? assetStateID;

  @override
  void initState() {
    getAssetDetailData(assetID: widget.assetID);
    // getAssetStatesData();
    formattedDate = DateFormat('dd-MM-yyyy HH:mm:ss').format(assertDetailResponse?.assetCreatedOn ?? DateTime.now());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              top: 8,
              right: 8,
              bottom: 8,
            ),
            child: Row(
              // crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Expanded(
                  child: SizedBox(),
                ),
                const Expanded(
                  child: Text(
                    AppConstants.details,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.cancel_outlined,
                        color: Colors.black,
                      ),
                    ),
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
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: SizedBox(
                                      width: 370,
                                      height: 450,
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
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${AppConstants.assetName}:',
                                      style: AppConstants.detailTxtStyle,
                                    ),
                                    Text(
                                      assertDetailResponse?.assetType?.name ?? '--',
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: AppConstants.detailTxtStyle,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${AppConstants.description}:',
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                      style: AppConstants.detailTxtStyle,
                                    ),
                                    Text(
                                      assertDetailResponse?.description ?? '--',
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                      style: AppConstants.detailTxtStyle,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      AppConstants.isoCodeAndPurchasePrice,
                                      style: AppConstants.detailTxtStyle,
                                    ),
                                    Text(
                                      '${assertDetailResponse?.purchaseCurrency?.isoCode ?? '--'} - ${assertDetailResponse?.purchasePrice}',
                                      style: AppConstants.detailTxtStyle,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${AppConstants.serviceLines}:',
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                      style: AppConstants.detailTxtStyle,
                                    ),
                                    Text(
                                      assertDetailResponse?.serviceLine?.name ?? '--',
                                      style: AppConstants.detailTxtStyle,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${AppConstants.owner}:',
                                      style: AppConstants.detailTxtStyle,
                                    ),
                                    Text(
                                      assertDetailResponse?.owner?.name ?? '--',
                                      style: AppConstants.detailTxtStyle,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${AppConstants.ownerPhone}:',
                                      style: AppConstants.detailTxtStyle,
                                    ),
                                    Text(
                                      assertDetailResponse?.owner?.phone ?? '--',
                                      style: AppConstants.detailTxtStyle,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${AppConstants.ownerEmail}:',
                                      style: AppConstants.detailTxtStyle,
                                    ),
                                    Text(
                                      assertDetailResponse?.owner?.email ?? '--',
                                      style: AppConstants.detailTxtStyle,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${AppConstants.ownerContactPerson}:',
                                      style: AppConstants.detailTxtStyle,
                                    ),
                                    Text(
                                      '${assertDetailResponse?.ownerContact?.firstName ?? ''} ${assertDetailResponse?.ownerContact?.lastName ?? ''}',
                                      style: AppConstants.detailTxtStyle,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${AppConstants.ownerContactPersonEmail}:',
                                        style: AppConstants.detailTxtStyle,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        textAlign: TextAlign.end,
                                        assertDetailResponse?.ownerContact?.email ?? '--',
                                        style: AppConstants.detailTxtStyle,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${AppConstants.ownerContactPersonPhone}:',
                                      style: AppConstants.detailTxtStyle,
                                    ),
                                    Text(
                                      assertDetailResponse?.ownerContact?.mobile ?? '--',
                                      style: AppConstants.detailTxtStyle,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${AppConstants.maintainerName}:',
                                      style: AppConstants.detailTxtStyle,
                                    ),
                                    Text(
                                      assertDetailResponse?.maintainer?.name ?? '--',
                                      style: AppConstants.detailTxtStyle,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${AppConstants.maintainerPhone}:',
                                      style: AppConstants.detailTxtStyle,
                                    ),
                                    Text(
                                      assertDetailResponse?.maintainer?.phone ?? '--',
                                      style: AppConstants.detailTxtStyle,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${AppConstants.maintainerEmail}:',
                                      style: AppConstants.detailTxtStyle,
                                    ),
                                    Text(
                                      assertDetailResponse?.maintainer?.email ?? '--',
                                      style: AppConstants.detailTxtStyle,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${AppConstants.floor}:',
                                      style: AppConstants.detailTxtStyle,
                                    ),
                                    Text(
                                      assertDetailResponse?.floor ?? '--',
                                      style: AppConstants.detailTxtStyle,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${AppConstants.unit}:',
                                      style: AppConstants.detailTxtStyle,
                                    ),
                                    Text(
                                      assertDetailResponse?.unit ?? '--',
                                      style: AppConstants.detailTxtStyle,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${AppConstants.assetOEM}:',
                                      style: AppConstants.detailTxtStyle,
                                    ),
                                    Text(
                                      assertDetailResponse?.assetOem ?? '--',
                                      style: AppConstants.detailTxtStyle,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${AppConstants.modalNumber}:',
                                      style: AppConstants.detailTxtStyle,
                                    ),
                                    Text(
                                      assertDetailResponse?.modelNumber ?? '--',
                                      style: AppConstants.detailTxtStyle,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${AppConstants.serialNumber}:',
                                      style: AppConstants.detailTxtStyle,
                                    ),
                                    Text(
                                      assertDetailResponse?.serialNumber ?? '--',
                                      style: AppConstants.detailTxtStyle,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      AppConstants.warranty,
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                      style: AppConstants.detailTxtStyle,
                                    ),
                                    Text(
                                      assertDetailResponse?.warranty ?? '--',
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                      style: AppConstants.detailTxtStyle,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${AppConstants.assetState}:',
                                      style: AppConstants.detailTxtStyle,
                                    ),
                                    Text(
                                      assertDetailResponse?.assetState?.state ?? '--',
                                      style: AppConstants.detailTxtStyle,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
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
                                              '${assertDetailResponse?.assetAttributes?[index].assetTypeAttributeName ?? '--'}:',
                                              style: AppConstants.detailTxtStyle,
                                            ),
                                            Text(
                                              assertDetailResponse?.assetAttributes?[index].assetAttributeValue ?? '--',
                                              style: AppConstants.detailTxtStyle,
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
                                    Text(
                                      '${AppConstants.cratedDate}:',
                                      style: AppConstants.detailTxtStyle,
                                    ),
                                    Text(
                                      formattedDate,
                                      style: AppConstants.detailTxtStyle,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${AppConstants.createdBy}:',
                                      style: AppConstants.detailTxtStyle,
                                    ),
                                    Text(
                                      assertDetailResponse?.assetCreatedBy?.displayName ?? '--',
                                      style: AppConstants.detailTxtStyle,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),
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
                              // Navigator.pop(context);
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

  void _showModalBottomSheet(BuildContext dialogContext, String assetID) {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: dialogContext,
      backgroundColor: AppColors.whiteColor,
      builder: (BuildContext bottomSheetContext) {
        return UpdateStateData(
          assetID: assetID,
          context: context,
        );
      },
    );
  }
}

class UpdateStateData extends StatefulWidget {
  const UpdateStateData({
    super.key,
    required this.assetID,
    required this.context,
  });

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
  bool isLoading = true;

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
          height: MediaQuery.of(context).size.height * 0.8,
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
      }

      if (mounted) {
        setState(() {
          isUpdateStateLoading = false;
        });
      }
    } catch (error) {
      snackBarMessage = error.toString();
      showDialog<void>(
        context: cnt,
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
      if (mounted) {
        setState(() {
          isUpdateStateLoading = false;
          isSnackBarShowing = false;
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
