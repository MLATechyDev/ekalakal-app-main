import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RouteMap extends StatefulWidget {
  final String longitude;
  final String latitude;
  RouteMap({Key? key, required this.latitude, required this.longitude})
      : super(key: key);

  @override
  State<RouteMap> createState() => _RouteMapState();
}

class _RouteMapState extends State<RouteMap> {
  late GoogleMapController _controller;

  static const CameraPosition initialCameraPosition =
      CameraPosition(target: LatLng(14.9879943, 120.8843322), zoom: 15);

  Set<Marker> marker = {};
  Polyline _polyLine = Polyline(
    polylineId: PolylineId('_polyLine'),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text('Route Map'),
      ),
      body: Stack(
        children: [
          Container(
            child: GoogleMap(
              initialCameraPosition: initialCameraPosition,
              markers: marker,
              polylines: {_polyLine},
              zoomControlsEnabled: false,
              mapType: MapType.normal,
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
              },
            ),
          ),
          Positioned(
            bottom: 75,
            right: 15,
            child: FloatingActionButton(
                onPressed: () async {
                  final Marker residentLocation = Marker(
                      markerId: MarkerId('_residentLocation'),
                      infoWindow: InfoWindow(title: 'Resident Location'),
                      position: LatLng(double.parse(widget.latitude),
                          double.parse(widget.longitude)),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueBlue));
                  Position position = await _determinePosition();
                  _controller.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                          target: LatLng(position.latitude, position.longitude),
                          zoom: 18.0),
                    ),
                  );
                  marker.clear();
                  marker.add(
                    Marker(
                      markerId: MarkerId('Current Location'),
                      infoWindow: InfoWindow(title: 'Your Location'),
                      position: LatLng(position.latitude, position.longitude),
                    ),
                  );
                  marker.add(residentLocation);

                  final _line = Polyline(
                    polylineId: PolylineId('_line'),
                    points: [
                      LatLng(position.latitude, position.longitude),
                      LatLng(
                        double.parse(widget.latitude),
                        double.parse(widget.longitude),
                      ),
                    ],
                    width: 3,
                  );
                  setState(() {
                    _polyLine = _line;
                  });

                  print(
                      "ANG POSITION AY LONGITUDE: ${position.longitude} LATITUDE: ${position.latitude}");

                  setState(() {});
                },
                child: Icon(Icons.location_on, color: Colors.white)),
          )
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //     onPressed: () async {
      //       final Marker residentLocation = Marker(
      //           markerId: MarkerId('_residentLocation'),
      //           infoWindow: InfoWindow(title: 'Resident Location'),
      //           position: LatLng(double.parse(widget.latitude),
      //               double.parse(widget.longitude)),
      //           icon: BitmapDescriptor.defaultMarkerWithHue(
      //               BitmapDescriptor.hueBlue));
      //       Position position = await _determinePosition();
      //       _controller.animateCamera(
      //         CameraUpdate.newCameraPosition(
      //           CameraPosition(
      //               target: LatLng(position.latitude, position.longitude),
      //               zoom: 18.0),
      //         ),
      //       );
      //       marker.clear();
      //       marker.add(
      //         Marker(
      //           markerId: MarkerId('Current Location'),
      //           infoWindow: InfoWindow(title: 'Your Location'),
      //           position: LatLng(position.latitude, position.longitude),
      //         ),
      //       );
      //       marker.add(residentLocation);

      //       final _line = Polyline(
      //         polylineId: PolylineId('_line'),
      //         points: [
      //           LatLng(position.latitude, position.longitude),
      //           LatLng(
      //             double.parse(widget.latitude),
      //             double.parse(widget.longitude),
      //           ),
      //         ],
      //         width: 3,
      //       );
      //       setState(() {
      //         _polyLine = _line;
      //       });

      //       print(
      //           "ANG POSITION AY LONGITUDE: ${position.longitude} LATITUDE: ${position.latitude}");

      //       setState(() {});
      //     },
      //     child: Icon(Icons.location_on, color: Colors.white)),
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

    return position;
  }
}
