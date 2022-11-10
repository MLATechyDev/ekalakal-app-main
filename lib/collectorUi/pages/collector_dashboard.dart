import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekalakal/collectorUi/database/collectorAppInfo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CollectorDashboard extends StatefulWidget {
  const CollectorDashboard({super.key});

  @override
  State<CollectorDashboard> createState() => _CollectorDashboardState();
}

class _CollectorDashboardState extends State<CollectorDashboard> {
  Stream<QuerySnapshot> residentAppointment = FirebaseFirestore.instance
      .collection('appointments')
      .orderBy('date')
      // .where('status', isEqualTo: 'pending')
      .snapshots();

  int appointmentCount = 0;

  final date = DateTime.now();
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

  Widget isVerify() {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: RefreshIndicator(
          onRefresh: onRefresh,
          child: ListView(
            shrinkWrap: true,
            children: [
              Container(
                height: screenHeight,
                child: Column(
                  children: [
                    topUi(),
                    Divider(
                      height: 10,
                      thickness: 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Text(
                        'List of Appointments',
                        style: GoogleFonts.bebasNeue(
                          textStyle: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      thickness: 1,
                    ),
                    appointmentList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget topUi() => Container(
        height: 200,
        width: 250,
        child: Image.asset(
          'assets/collector-icon.png',
          fit: BoxFit.cover,
        ),
      );

  Widget appointmentList() {
    return StreamBuilder<QuerySnapshot>(
        stream: residentAppointment,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong!'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Text('loading please wait!'),
            );
          }
          if (snapshot.requireData.size == 0) {
            return Center(
              child: Text(
                'There is no appointment request from resident,\nCheck it back later.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }
          final data = snapshot.requireData;

          return ListView.builder(
              shrinkWrap: true,
              itemCount: data.size,
              itemBuilder: (context, index) {
                final isRecommend = int.parse(DateFormat('dd').format(date));
                final appDate = int.parse(DateFormat('dd')
                    .format(DateTime.parse(data.docs[index]['date'])));

                if (data.docs[index]['status'] == 'pending') {
                  return Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.amberAccent,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: ListTile(
                        leading: appDate > isRecommend
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.recommend),
                                  Text(
                                    'recommended',
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              )
                            : Icon(Icons.fiber_new),
                        title: Text(
                          'Name: ${data.docs[index]['name']}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle:
                            Text('Address: ${data.docs[index]['address']}'),
                        onTap: () {
                          final String id = data.docs[index]['id'];
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => CollectorAppInfo(
                                longitude: data.docs[index]['longitude'],
                                latitude: data.docs[index]['latitude'],
                                name: data.docs[index]['name'],
                                address: data.docs[index]['address'],
                                contactnumber: data.docs[index]
                                    ['contact number'],
                                description: data.docs[index]['description'],
                                id: id,
                                acceptBy: data.docs[index]['acceptBy'],
                              ),
                            ),
                          );
                        },
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              data.docs[index]['time'],
                              style: const TextStyle(color: Colors.black54),
                            ),
                            Text(
                              DateFormat('MM-dd-yyyy').format(
                                  DateTime.parse(data.docs[index]['date'])),
                              style: const TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                return Container();
              });
        });
  }

  Future onRefresh() async {
    await Future.delayed(Duration(seconds: 4));
    setState(() {});
  }
}
