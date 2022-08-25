import 'package:ekalakal/loginpage.dart';
import 'package:ekalakal/registrationpage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'authentication/usersAuth.dart';

class WrapperPage extends StatelessWidget {
  WrapperPage({Key? key}) : super(key: key);
  String loginAs = ' collector';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // space
          const SizedBox(
            height: 100,
          ),
          Center(
            child: Image.asset(
              'assets/ekalakal_logo.png',
              alignment: Alignment.center,
              height: 200,
              width: 200,
            ),
          ),
          // space
          const SizedBox(
            height: 10,
          ),

          Text(
            'E KALAKAL',
            style: GoogleFonts.mouseMemoirs(
                textStyle: const TextStyle(fontSize: 30)),
          ),
          const Text(
            '"Turn Trash Into Cash"',
            style: TextStyle(
              fontSize: 20,
            ),
          ),

          // space
          const SizedBox(
            height: 50,
          ),
          const Text(
            "Login As:",
            style: TextStyle(
              fontSize: 20,
            ),
          ),

          // space
          const SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              residentBtn(context),
              const SizedBox(
                width: 50,
              ),
              collectorBtn(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget residentBtn(context) {
    return ElevatedButton(
        onPressed: () {
          loginAs = 'resident';
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) {
                return RegistrationPageUI(loginAs: loginAs);
              },
            ),
          );
        },
        style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.only(left: 30.0, right: 30.0),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30))),
            minimumSize: const Size(100, 50),
            primary: Colors.red),
        child: const Text(
          "Resident",
          style: TextStyle(fontSize: 20),
        ));
  }

  Widget collectorBtn(context) {
    return ElevatedButton(
        onPressed: () {
          loginAs = 'collector';
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) {
                return RegistrationPageUI(
                  loginAs: loginAs,
                );
              },
            ),
          );
        },
        style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.only(left: 30.0, right: 30.0),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30))),
            minimumSize: const Size(100, 50),
            primary: Colors.lightBlue),
        child: const Text(
          "Collector",
          style: TextStyle(fontSize: 20),
        ));
  }
}
