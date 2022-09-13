import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => _MapSampleState();
}

class _MapSampleState extends State<MapSample> {
  late GoogleMapController _googleMapController;

  static const CameraPosition initialCameraPosition =
      CameraPosition(target: LatLng(14.9879943, 120.8843322), zoom: 14);

  Set<Marker> marker = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Map'),
        ),
        body: GoogleMap(
          initialCameraPosition: initialCameraPosition,
          markers: marker,
          zoomControlsEnabled: false,
          mapType: MapType.normal,
          onMapCreated: (GoogleMapController controller) {
            _googleMapController = controller;
          },
        ));
  }
}
