import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'loginpage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekalakal/loginpage.dart';
import 'package:ekalakal/utils.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(EkalakalApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class EkalakalApp extends StatelessWidget {
  const EkalakalApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        navigatorKey: navigatorKey,
        theme: ThemeData(primarySwatch: Colors.blue),
        debugShowCheckedModeBanner: false,
        home: LoginPage());
  }
}

// Widget residentBtn(BuildContext context) {
//   return ElevatedButton(
//       onPressed: () {
//         Navigator.of(context).push(
//           MaterialPageRoute(
//             builder: (BuildContext context) {
//               return LoginPage();
//             },
//           ),
//         );
//       },
//       style: ElevatedButton.styleFrom(
//           padding: const EdgeInsets.only(left: 30.0, right: 30.0),
//           shape: const RoundedRectangleBorder(
//               borderRadius: BorderRadius.all(Radius.circular(30))),
//           minimumSize: const Size(100, 50),
//           primary: Colors.red),
//       child: const Text("Resident"));
// }

// Widget collectorBtn(BuildContext context) {
//   return ElevatedButton(
//       onPressed: () {
//         Navigator.of(context).push(
//           MaterialPageRoute(
//             builder: (BuildContext context) {
//               return LoginPage();
//             },
//           ),
//         );
//       },
//       style: ElevatedButton.styleFrom(
//           padding: const EdgeInsets.only(left: 30.0, right: 30.0),
//           shape: const RoundedRectangleBorder(
//               borderRadius: BorderRadius.all(Radius.circular(30))),
//           minimumSize: const Size(100, 50),
//           primary: Colors.lightBlue),
//       child: const Text("Collector"));
// }

// class HomePage extends StatelessWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           // space
//           const SizedBox(
//             height: 100,
//           ),
//           Center(
//             child: Image.asset(
//               'assets/ekalakal_logo.png',
//               alignment: Alignment.center,
//               height: 200,
//               width: 200,
//             ),
//           ),
//           // space
//           const SizedBox(
//             height: 10,
//           ),
//           Text(
//             'E KALAKAL',
//             style: GoogleFonts.mouseMemoirs(
//                 textStyle: const TextStyle(fontSize: 30)),
//           ),
//           const Text(
//             '"Turn Trash Into Cash"',
//             style: TextStyle(
//               fontSize: 20,
//             ),
//           ),

//           // space
//           const SizedBox(
//             height: 50,
//           ),
//           const Text(
//             "Login As:",
//             style: TextStyle(
//               fontSize: 20,
//             ),
//           ),

//           // space
//           const SizedBox(
//             height: 50,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               residentBtn(context),
//               const SizedBox(
//                 width: 50,
//               ),
//               collectorBtn(context),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
