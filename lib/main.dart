import 'package:ekalakal/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:ekalakal/loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const EkalakalApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class EkalakalApp extends StatelessWidget {
  const EkalakalApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "E KALAKAL APP",
        navigatorKey: navigatorKey,
        theme: ThemeData(primarySwatch: Colors.blue),
        debugShowCheckedModeBanner: false,
        home: const LoginPage());
  }
}
