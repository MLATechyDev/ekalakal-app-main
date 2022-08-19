import 'package:cloud_firestore/cloud_firestore.dart';

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
      backgroundColor: Colors.blue[100],
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
                            minimumSize: Size(150, 50),
                            shape: StadiumBorder(),
                          ),
                          child: Text('Request'),
                          onPressed: () {
                            Fluttertoast.showToast(
                              msg: 'Pending Request',
                              fontSize: 18,
                            );

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
                          child: const Text('On Going'),
                          onPressed: () {
                            Fluttertoast.showToast(
                              msg: 'On Going Transaction',
                              fontSize: 18,
                            );
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

            // Container(
            //   margin: EdgeInsets.all(8.0),
            //   child: StreamBuilder<QuerySnapshot>(
            //       stream: appointments,
            //       builder: (BuildContext context,
            //           AsyncSnapshot<QuerySnapshot> snapshot) {
            //         if (snapshot.hasError) {
            //           return Center(
            //             child: Text('Something went wrong!'),
            //           );
            //         }
            //         if (snapshot.connectionState == ConnectionState.waiting) {
            //           return Center(
            //             child: Text('Loading'),
            //           );
            //         }
            //         final data = snapshot.requireData;
            //         return ListView.builder(
            //             shrinkWrap: true,
            //             itemCount: data.size,
            //             itemBuilder: (context, index) {
            //               return Column(
            //                 children: [
            //                   Container(
            //                     color: Colors.amberAccent,
            //                     child: ListTile(
            //                       leading: Icon(Icons.heart_broken),
            //                       title:
            //                           Text('Name: ${data.docs[index]['name']}'),
            //                       subtitle: Text(
            //                           'Address: ${data.docs[index]['address']}'),
            //                     ),
            //                   ),
            //                   const Padding(padding: EdgeInsets.only(top: 8.0))
            //                 ],
            //               );
            //             });
            //       }),
            // ),

            _requestList ? const RequestList() : const OnGoingList(),
          ],
        ),
      ),
    );
  }
}
