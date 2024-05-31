import 'dart:developer';
import 'package:am_sys/utils/app_consts/app_consts.dart';
import 'package:am_sys/utils/colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CreateLocationMap extends StatefulWidget {
  final Position? position;

  const CreateLocationMap({
    super.key,
    this.position,
  });

  @override
  State<CreateLocationMap> createState() => _CreateLocationMapState();
}

class _CreateLocationMapState extends State<CreateLocationMap> {
  LatLng? _markerPosition;
  double? latitude;
  double? longitude;
  late GoogleMapController mapController;
  String? _address;

  @override
  void initState() {
    if (widget.position != null) {
      _markerPosition = LatLng(widget.position!.latitude, widget.position!.longitude);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        title: const Text(
          'Create Location',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            size: 30,
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: _markerPosition != null
          ? FloatingActionButton(
              backgroundColor: AppColors.primaryColor,
              onPressed: () {
                showSheet();
              },
              child: const Text(
                AppConstants.done,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          : const SizedBox(),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: GoogleMap(
          onTap: (LatLng latLng) async {
            setState(() {
              _markerPosition = latLng;
            });
            latitude = latLng.latitude;
            longitude = latLng.longitude;
            await _updateAddress(latLng);

            log('latitude: $latitude, longitude: $longitude');
          },
          onMapCreated: _onMapCreated,
          markers: _markerPosition != null
              ? {
                  Marker(
                    markerId: const MarkerId("marker1"),
                    position: _markerPosition!,
                    infoWindow: InfoWindow(title: '$_address'),
                    draggable: true,
                    onTap: () {
                      log('Create location onTap');
                    },
                    onDragEnd: (LatLng newPosition) {
                      setState(() {
                        _markerPosition = newPosition;
                      });
                    },
                  ),
                }
              : {},
          myLocationEnabled: true,
          buildingsEnabled: true,
          mapToolbarEnabled: true,
          myLocationButtonEnabled: true,
          initialCameraPosition: CameraPosition(
            target: _markerPosition!,
            zoom: 11.0,
          ),
        ),
      ),
    );
  }

  /// GoogleMap
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> _updateAddress(LatLng latLng) async {
    try {
      List<Placemark> placeMarks = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );
      if (placeMarks.isNotEmpty) {
        Placemark place = placeMarks.first;
        setState(() {
          // _address = "${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}";
          _address =
              "${place.street}, ${place.subLocality != null ? "${place.subLocality}" : ""}${place.locality}, ${place.postalCode}, ${place.country}";
          log('_address: $_address');
        });
      }
    } catch (e) {
      print(e);
    }
  }

  showSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 24,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                '$_address',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                AppConstants.confirmLocationSelection,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context, _markerPosition);
                      },
                      child: Text(
                        AppConstants.confirm,
                        style: TextStyle(
                          fontSize: 17,
                          color: AppColors.whiteColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.primaryColor),
                        backgroundColor: AppColors.whiteColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        AppConstants.cancel,
                        style: TextStyle(
                          fontSize: 17,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
