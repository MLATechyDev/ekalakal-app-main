import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekalakal/collectorUi/database/collectorAppInfo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CollectorList extends StatefulWidget {
  const CollectorList({super.key});

  @override
  State<CollectorList> createState() => _CollectorListState();
}

class _CollectorListState extends State<CollectorList> {
  final streamUser = FirebaseFirestore.instance
      .collection('userpos')
      .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
      .snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: streamUser,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Something went wrong'),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return snapshot.requireData.docs.first['isVerify'] == 'new'
                ? Center(
                    child: Text(
                      'You need to setup your profile first',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  )
                : Column(
                    children: [
                      const Divider(
                        height: 15,
                        thickness: 2,
                      ),
                      Text('Accepted Appointments',
                          style: GoogleFonts.bebasNeue(
                            textStyle: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          )),
                      const Divider(
                        height: 15,
                        thickness: 2,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('appointments')
                              .where('acceptBy',
                                  isEqualTo:
                                      FirebaseAuth.instance.currentUser!.uid)
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            }
                            if (snapshot.hasError) {
                              return const Center(
                                child: Text('Something went wrong'),
                              );
                            }
                            if (snapshot.requireData.size == 0) {
                              return const Center(
                                child: Text(
                                  'You need to accept an appointment request first.',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              );
                            }
                            final data = snapshot.requireData;

                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: data.size,
                              itemBuilder: (context, index) {
                                if (data.docs[index]['status'] == 'ongoing') {
                                  return Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 3),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Color.fromARGB(255, 7, 62, 107),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      child: ListTile(
                                        textColor: Colors.white,
                                        title: Text(
                                          'Name ${data.docs[index]['name']}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                'Address: ${data.docs[index]['address']}'),
                                            Text(
                                                'Time to Collect: ${data.docs[index]['expectedTimeArrival']}'),
                                            Text(
                                              "Date to Collect: ${DateFormat('MM-dd-yyyy').format(DateTime.parse(data.docs[index]['date']))}",
                                            ),
                                          ],
                                        ),
                                        trailing: const Icon(
                                          Icons.pin_drop_rounded,
                                          color: Colors.white,
                                        ),
                                        onTap: () {
                                          final String id =
                                              data.docs[index]['id'];
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CollectorAppInfo(
                                                name: data.docs[index]['name'],
                                                address: data.docs[index]
                                                    ['address'],
                                                contactnumber: data.docs[index]
                                                    ['contact number'],
                                                description: data.docs[index]
                                                    ['description'],
                                                id: id,
                                                acceptBy: data.docs[index]
                                                    ['acceptBy'],
                                                latitude: data.docs[index]
                                                    ['latitude'],
                                                longitude: data.docs[index]
                                                    ['longitude'],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                }
                                return Container();
                              },
                            );
                          },
                        ),
                      )
                    ],
                  );
          }),
    );
  }
}
