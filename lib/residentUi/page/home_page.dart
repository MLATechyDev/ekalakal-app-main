import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import '../databaseUser/requestlist.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _requestList = true;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('userpos')
            .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final data = snapshot.requireData;
          return data.docs.first['adminVerify'] == 'viewed'
              ? isVerify()
              : onAdminVerify();
        });
  }

  Widget isVerify() {
    return Scaffold(
      extendBody: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(30, 30, 30, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: SizedBox(
                      height: 200,
                      width: 250,
                      child: Image.asset(
                        'assets/kalakal-sort.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      'Your Appointments',
                      style: GoogleFonts.bebasNeue(
                        textStyle: const TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            onPrimary: Colors.white,
                            minimumSize: Size(150, 50),
                            shape: StadiumBorder(),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Pending',
                                style: GoogleFonts.bebasNeue(
                                  textStyle: const TextStyle(
                                    fontSize: 16,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                              Text(
                                'Request',
                                style: GoogleFonts.bebasNeue(
                                  textStyle: const TextStyle(
                                    fontSize: 16,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          onPressed: () {
                            Fluttertoast.showToast(
                                msg: 'Pending Request',
                                fontSize: 18,
                                backgroundColor: Colors.amber,
                                textColor: Colors.black);

                            setState(() {
                              _requestList = true;
                            });
                          }),
                      OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(150, 50),
                            shape: const StadiumBorder(),
                            side:
                                const BorderSide(width: 3, color: Colors.blue),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'On Going',
                                style: GoogleFonts.bebasNeue(
                                  textStyle: const TextStyle(
                                    fontSize: 16,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                              Text(
                                'Request',
                                style: GoogleFonts.bebasNeue(
                                  textStyle: const TextStyle(
                                    fontSize: 16,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          onPressed: () {
                            Fluttertoast.showToast(
                                msg: 'On Going Transaction',
                                fontSize: 18,
                                backgroundColor: Colors.amber,
                                textColor: Colors.black);
                            setState(() {
                              _requestList = false;
                            });
                          }),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                ],
              ),
            ),
            _requestList ? const RequestList() : const OnGoingList(),
          ],
        ),
      ),
    );
  }

  Widget onAdminVerify() {
    return Scaffold(
      body: Center(
        child: Text(
          'Your account is undergoing verification,\nplease wait until it is finished',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
