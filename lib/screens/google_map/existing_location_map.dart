import 'dart:developer';
import 'package:am_sys/model/location_response/location_response.dart';
import 'package:am_sys/utils/colors/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator_platform_interface/src/models/position.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ExistingLocationMap extends StatefulWidget {
  const ExistingLocationMap({
    super.key,
    required this.listExistingLocationResponse,
    required this.position,
  });

  final List<LocationResponse> listExistingLocationResponse;
  final Position? position;

  @override
  State<ExistingLocationMap> createState() => _ExistingLocationMapState();
}

class _ExistingLocationMapState extends State<ExistingLocationMap> {
  LatLng? _markerPosition, currPosition;
  String? markerId;
  double? latitude;
  double? longitude;
  late GoogleMapController mapController;
  String? _address;

  @override
  void initState() {
    if (widget.position != null) {
      currPosition = LatLng(widget.position!.latitude, widget.position!.longitude);
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
          'Existing Location',
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
                'Done',
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
          // onTap: (LatLng latLng) {
          //   setState(() {
          //     _markerPosition = latLng;
          //   });
          //   latitude = latLng.latitude;
          //   longitude = latLng.longitude;
          //   log('latitude: $latitude, longitude: $longitude');
          // },
          onMapCreated: _onMapCreated,
          markers: Set<Marker>.from(
            widget.listExistingLocationResponse.map(
              (location) => Marker(
                markerId: MarkerId(location.locationID ?? ''),
                infoWindow: InfoWindow(title: '$_address'),
                position: LatLng(location.longitude ?? 0.0, location.latitude ?? 0.0),
                onTap: () async {
                  setState(() {
                    markerId = location.locationID;
                    _markerPosition = LatLng(location.longitude ?? 0.0, location.latitude ?? 0.0);
                  });
                  await _updateAddress(_markerPosition!);

                  log('Latitude: ${location.longitude}, Longitude: ${location.latitude}');
                },
              ),
            ),
          ),
          myLocationEnabled: true,
          buildingsEnabled: true,
          initialCameraPosition: CameraPosition(
            target: widget.listExistingLocationResponse.isEmpty
                ? currPosition!
                : LatLng(
                    widget.listExistingLocationResponse[0].longitude ?? 0.0,
                    widget.listExistingLocationResponse[0].latitude ?? 0.0,
                  ),
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

  showSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
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
                'Are you sure you want select this location?',
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
                        if (widget.listExistingLocationResponse.isEmpty) {
                          Navigator.pop(context, {"position": currPosition, "id": ""});
                        } else {
                          Navigator.pop(context, {"position": _markerPosition, "id": markerId});
                        }
                      },
                      child: Text(
                        'Confirm',
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
                        'Cancel',
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
}
