import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekalakal/adminUI/appointments/noticeMessage.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './page/profile_page.dart';
import './page/home_page.dart';
import './page/book_page.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:google_fonts/google_fonts.dart';

class ResidentMainApp extends StatefulWidget {
  ResidentMainApp({Key? key}) : super(key: key);

  @override
  State<ResidentMainApp> createState() => _ResidentMainAppState();
}

class _ResidentMainAppState extends State<ResidentMainApp> {
  //final navigationKey = GlobalKey<CurvedNavigationBarState>();

  final screen = [
    BookPage(),
    HomePage(),
    ProfilePage(),
  ];

  int index = 1;

  final items = <Widget>[
    const Icon(
      Icons.add,
      size: 30,
    ),
    const Icon(
      Icons.home,
      size: 30,
    ),
    const Icon(
      Icons.person,
      size: 30,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          index == 0
              ? 'BOOKING'
              : index == 1
                  ? 'DASHBOARD'
                  : 'PROFILE',
          style: GoogleFonts.passionOne(
            textStyle: const TextStyle(fontSize: 35, color: Colors.white),
          ),
        ),
        actions: [
          Stack(children: [
            bellIcon(),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('adminmessage')
                  .where('uid',
                      isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                  .where('isRead', isEqualTo: 'notread')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return bellIcon();
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                final data = snapshot.requireData;
                return Positioned(
                  right: 12,
                  bottom: 35,
                  child: CircleAvatar(
                    radius: 5,
                    backgroundColor:
                        data.size != 0 ? Colors.red : Colors.transparent,
                  ),
                );
              },
            ),
          ]),
        ],
      ),
      body: screen[index],
      endDrawer: navDrawer(context),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        child: CurvedNavigationBar(
          index: index,
          //key: navigationKey,
          height: 60,
          backgroundColor: Colors.transparent,
          animationDuration: const Duration(milliseconds: 400),
          color: Colors.lightBlue,
          items: items,
          onTap: (index) => setState(() => this.index = index),
        ),
      ),
    );
  }

  Widget buildHeader() => Container(
        padding: EdgeInsets.only(top: 40),
        color: Colors.lightBlue,
        width: double.infinity,
        child: Container(
            child: Center(
          child: Text(
            'NOTIFICATION',
            style: GoogleFonts.passionOne(
              textStyle: const TextStyle(fontSize: 35, color: Colors.white),
            ),
          ),
        )),
      );

  Widget navDrawer(BuildContext context) {
    return Drawer(
      width: 400,
      child: SingleChildScrollView(
        child: Column(
          children: [
            buildHeader(),
            buildMenuItems(),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItems() => Container(
        height: MediaQuery.of(context).size.height,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('adminmessage')
              .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return bellIcon();
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            final data = snapshot.requireData;
            return ListView.builder(
                itemCount: data.size,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Container(
                        height: 60,
                        color: Colors.amber,
                        child: ListTile(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return NoticeMessage(
                                id: data.docs[index]['id'],
                                message: data.docs[index]['message'],
                                time: data.docs[index]['time'],
                                date: data.docs[index]['date'],
                              );
                            }));
                          },
                          leading: data.docs[index]['isRead'] == 'notread'
                              ? Icon(Icons.mail)
                              : Icon(Icons.drafts),
                          title: Text(
                            'REPORT NOTICE',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(data.docs[index]['time']),
                              Text(data.docs[index]['date']),
                            ],
                          ),
                        )),
                  );
                });
          },
        ),
      );

  Widget bellIcon() {
    return Builder(builder: (context) {
      return IconButton(
          onPressed: () {
            Scaffold.of(context).openEndDrawer();
          },
          icon: Icon(
            Icons.notifications,
            size: 30,
            color: Colors.white,
          ));
    });
  }
}
