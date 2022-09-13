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
                  Text(
                    'Your Appointments',
                    style: GoogleFonts.archivoBlack(
                      textStyle: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
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
                            children: const [
                              Text(
                                'Pending',
                                style: TextStyle(fontSize: 15),
                              ),
                              Text('Request', style: TextStyle(fontSize: 15)),
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
                            children: const [
                              Text(
                                'On Going',
                                style: TextStyle(fontSize: 15),
                              ),
                              Text('Request', style: TextStyle(fontSize: 15)),
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
}
