// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart' as loc;
// import 'package:permission_handler/permission_handler.dart';

// class MapRoute extends StatefulWidget {
//   const MapRoute({super.key});

//   @override
//   State<MapRoute> createState() => _MapRouteState();
// }

// class _MapRouteState extends State<MapRoute> {
//   late double latitude, longitude;
//   final loc.Location location = loc.Location();
//   StreamSubscription<loc.LocationData>? _localSubscription;

//   late GoogleMapController _controller;
//   bool added = false;

//   static const CameraPosition initialCameraPosition =
//       CameraPosition(target: LatLng(14.9879943, 120.8843322), zoom: 15);

//   @override
//   void initState() {
//     // TODO: implement initState

//     _requestPermission();
//     location.changeSettings(interval: 300, accuracy: loc.LocationAccuracy.high);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           Container(
//             height: 500,
//             child: GoogleMap(
//               initialCameraPosition: initialCameraPosition,
//               mapType: MapType.normal,
//               markers: {
//                 Marker(
//                     markerId: MarkerId('CurrentLocation'),
//                     position: added
//                         ? LatLng(latitude, longitude)
//                         : LatLng(14.9879943, 120.8843322))
//               },
//               onMapCreated: (controller) async {
//                 _controller = controller;
//               },
//             ),
//           ),
//           ElevatedButton(
//               onPressed: () {
//                 _getlocation();
//               },
//               child: Text("Get Location")),
//           ElevatedButton(
//               onPressed: () {
//                 setState(() {
//                   _locationListener();
//                   added = true;
//                 });
//               },
//               child: Text("Latest Location"))
//         ],
//       ),
//     );
//   }

//   _getlocation() async {
//     try {
//       final loc.LocationData _locationResult = await location.getLocation();

//       await _controller.animateCamera(
//         CameraUpdate.newCameraPosition(
//           CameraPosition(
//             target:
//                 LatLng(_locationResult.latitude!, _locationResult.longitude!),
//             zoom: 14,
//           ),
//         ),
//       );
//     } catch (e) {
//       print(e);
//     }
//   }

//   _locationListener() {
//     _localSubscription = location.onLocationChanged.handleError((onError) {
//       print(onError);
//       _localSubscription?.cancel();
//       setState(() {
//         _localSubscription = null;
//       });
//     }).listen((loc.LocationData currentLocation) {
//       latitude = currentLocation.latitude!;
//       longitude = currentLocation.longitude!;
//     });
//   }

//   _stopListener() {
//     _localSubscription?.cancel();
//     setState(() {
//       _localSubscription = null;
//     });
//   }

//   Future _myMap() async {
//     await _controller.animateCamera(
//       CameraUpdate.newCameraPosition(
//         CameraPosition(
//           target: LatLng(latitude, longitude),
//           zoom: 14,
//         ),
//       ),
//     );
//   }

//   _requestPermission() async {
//     var status = await Permission.location.request();
//     if (status.isGranted) {
//       print('Done');
//     } else if (status.isDenied) {
//       _requestPermission();
//     } else if (status.isPermanentlyDenied) {
//       openAppSettings();
//     }
//   }
// }
