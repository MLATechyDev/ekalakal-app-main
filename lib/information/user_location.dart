import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserLocation extends StatefulWidget {
  const UserLocation({super.key});

  @override
  State<UserLocation> createState() => _UserLocationState();
}

class _UserLocationState extends State<UserLocation> {
  late GoogleMapController _googleMapController;
  static const CameraPosition initialCameraPosition =
      CameraPosition(target: LatLng(14.9879943, 120.8843322), zoom: 14);

  Set<Marker> marker = {};
  late Position location;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: initialCameraPosition,
            markers: marker,
            zoomControlsEnabled: true,
            mapType: MapType.normal,
            onMapCreated: (GoogleMapController controller) {
              _googleMapController = controller;
            },
          ),
          Positioned(
            bottom: 10,
            left: 160,
            child: ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop(location);
              },
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  minimumSize: Size(100, 40),
                  onPrimary: Colors.white),
              child: Text(
                'Save',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          Positioned(
              bottom: 30,
              right: 20,
              child: FloatingActionButton(
                onPressed: () async {
                  Position position = await _determinePosition();
                  _googleMapController.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                          target: LatLng(position.latitude, position.longitude),
                          zoom: 18.0),
                    ),
                  );
                  marker.clear();
                  marker.add(Marker(
                      markerId: MarkerId('Current Location'),
                      infoWindow: InfoWindow(title: 'Your Location'),
                      position: LatLng(position.latitude, position.longitude)));

                  print(
                      "ANG POSITION AY LONGITUDE: ${position.longitude} LATITUDE: ${position.latitude}");

                  setState(() {});
                },
                child: Icon(
                  Icons.location_on,
                  color: Colors.white,
                ),
              ))
        ],
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are closed');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error('Location are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permission are permanent denied');
    }

    Position position = await Geolocator.getCurrentPosition();
    location = position;
    return position;
  }
}
