// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class CollectorMap extends StatefulWidget {
//   const CollectorMap({Key? key}) : super(key: key);

//   @override
//   State<CollectorMap> createState() => _CollectorMapState();
// }

// class _CollectorMapState extends State<CollectorMap> {
//   late GoogleMapController googleMapController;
//   static const CameraPosition initialCameraPosition =
//       CameraPosition(target: LatLng(14.9879943, 120.8843322), zoom: 14);

//   Set<Marker> markers = {};
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Collector's Maps"),
//       ),
//       body: GoogleMap(
//         initialCameraPosition: initialCameraPosition,
//         markers: markers,
//         zoomControlsEnabled: false,
//         mapType: MapType.normal,
//         onMapCreated: (GoogleMapController controller) {
//           googleMapController = controller;
//         },
//       ),
//     );
//   }
// }
