import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekalakal/adminUI/database/ongoingAppointments.dart';
import 'package:ekalakal/adminUI/database/pending_appointments.dart';
import 'package:ekalakal/adminUI/database/reported_appointments.dart';
import 'package:ekalakal/adminUI/database/totalAppointments.dart';
import 'package:ekalakal/adminUI/database/user_info.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminDashBoard extends StatefulWidget {
  const AdminDashBoard({super.key});

  @override
  State<AdminDashBoard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashBoard> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          shrinkWrap: true,
          children: [
            Container(
              height: (screenHeight) * 0.1,
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 7, 62, 107),
                  borderRadius:
                      BorderRadius.only(bottomRight: Radius.circular(30))),
              child: Padding(
                padding: const EdgeInsets.only(top: 15, left: 8),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Welcome Admin',
                    style: GoogleFonts.bebasNeue(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 25,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: (screenHeight) * 0.7,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30))),
              child: Container(
                  // height: double.infinity,
                  // width: double.infinity,
                  child: button()),
            ),
            GestureDetector(
              onTap: dropUpTab,
              child: Container(
                height: (screenHeight) * 0.2,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 7, 62, 107),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    )),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.keyboard_arrow_up),
                          Align(
                            alignment: Alignment.topCenter,
                            child: Row(
                              children: [
                                textTab(),
                                AutoSizeText(
                                  ' NEW USERS',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                )
                              ],
                            ),
                          ),
                          Icon(Icons.keyboard_arrow_up),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Divider(
                        color: Colors.black,
                        height: 1,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  dropUpTab() {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          return Container(
              height: 400,
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 7, 62, 107),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  )),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.keyboard_arrow_down),
                            Text(
                              'NEW USER',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Icon(Icons.keyboard_arrow_down),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.black,
                      thickness: 1,
                      height: 1,
                    ),
                    Container(
                      child: newUsers(),
                    ),
                  ],
                ),
              ));
        });
  }

  Widget textTab() => StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('userpos')
          .where('adminVerify', isEqualTo: 'new')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        return AutoSizeText(
          snapshot.requireData.size.toString(),
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
        );
      });

  Widget button() => SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 5, right: 5, top: 5, bottom: 3),
                  child: totalBook(),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 5, right: 5, top: 5, bottom: 3),
                  child: pendingBook(),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 5, right: 5, top: 3, bottom: 8),
                  child: ongoingBook(),
                ),
                Padding(
                    padding: const EdgeInsets.only(
                        left: 5, right: 5, top: 3, bottom: 8),
                    child: reportedBook()),
              ],
            ),
          ],
        ),
      );

  Widget totalBook() => GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return TotalAppointments();
          }));
        },
        child: SizedBox(
          height: 140,
          width: 200,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: Colors.green[400],
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Total Appointments',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    functionTotalBooking(),
                    SizedBox(
                      width: 20,
                    ),
                    Icon(
                      Icons.library_books,
                      size: 70,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      );
  Widget pendingBook() => GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return PendingAppointments();
          }));
        },
        child: SizedBox(
          height: 140,
          width: 200,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: Colors.red[400],
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Pending Appointments',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    functionPendingBooking(),
                    SizedBox(
                      width: 20,
                    ),
                    Icon(
                      Icons.pending_actions,
                      size: 70,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      );
  Widget ongoingBook() => GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return OnGoingAppointments();
          }));
        },
        child: SizedBox(
          height: 140,
          width: 200,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: Colors.blue[400],
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'On-Going Appointments',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    functionOngoingBooking(),
                    SizedBox(
                      width: 20,
                    ),
                    Icon(
                      Icons.delivery_dining_sharp,
                      size: 70,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      );
  Widget reportedBook() => GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ReportedAppointments();
          }));
        },
        child: SizedBox(
          height: 140,
          width: 200,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: Colors.orange,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Canceled Appointments',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    functionReportedBooking(),
                    SizedBox(
                      width: 20,
                    ),
                    Icon(
                      Icons.warning_amber,
                      size: 70,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      );

  Widget functionTotalBooking() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('appointments').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        return Text(
          snapshot.requireData.size.toString(),
          style: TextStyle(
              fontSize: 70, fontWeight: FontWeight.bold, color: Colors.white),
        );
      },
    );
  }

  Widget functionPendingBooking() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('appointments')
          .where('status', isEqualTo: 'pending')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        return Text(
          snapshot.requireData.size.toString(),
          style: TextStyle(
              fontSize: 70, fontWeight: FontWeight.bold, color: Colors.white),
        );
      },
    );
  }

  Widget functionOngoingBooking() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('appointments')
          .where('status', isEqualTo: 'ongoing')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        return Text(
          snapshot.requireData.size.toString(),
          style: TextStyle(
              fontSize: 70, fontWeight: FontWeight.bold, color: Colors.white),
        );
      },
    );
  }

  Widget functionReportedBooking() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('appointments')
          .where('status', isEqualTo: 'cancel')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        return Text(
          snapshot.requireData.size.toString(),
          style: TextStyle(
              fontSize: 70, fontWeight: FontWeight.bold, color: Colors.white),
        );
      },
    );
  }

  Widget newUsers() => SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 400,
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('userpos')
                      .where('adminVerify', isEqualTo: 'new')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    final data = snapshot.requireData;
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: data.size,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 3),
                            child: Container(
                              decoration: BoxDecoration(
                                color:
                                    data.docs[index]['position'] == 'resident'
                                        ? Colors.amberAccent
                                        : Colors.red[200],
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return UserInfoinAdmin(
                                      profileID: data.docs[index]['profileID'],
                                      usersName: data.docs[index]['name'],
                                      position: data.docs[index]['position'],
                                      address: data.docs[index]['address'],
                                      contactnumber: data.docs[index]
                                          ['contact number'],
                                      email: data.docs[index]['email'],
                                      usersID: data.docs[index]['id'],
                                      adminVerify: data.docs[index]
                                          ['adminVerify'],
                                    );
                                  }));
                                },
                                trailing: Icon(Icons.new_releases),
                                title: Text(
                                  'Name: ${data.docs[index]['name']}',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                subtitle: Text(
                                  'Position: ${data.docs[index]['position']}',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          );
                        });
                  }),
            ),
          ],
        ),
      );

  Future onRefresh() async {
    await Future.delayed(Duration(seconds: 4));
    setState(() {});
  }
}
