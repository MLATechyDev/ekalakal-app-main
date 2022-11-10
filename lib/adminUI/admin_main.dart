import 'package:ekalakal/adminUI/navigationDrawer/adminDashBoard.dart';
import 'package:ekalakal/adminUI/navigationDrawer/adminRatings.dart';
import 'package:ekalakal/adminUI/navigationDrawer/adminResidentList.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'navigationDrawer/adminCollectorsList.dart';

class AdminMain extends StatefulWidget {
  const AdminMain({super.key});

  @override
  State<AdminMain> createState() => _AdminMainState();
}

class _AdminMainState extends State<AdminMain> {
  final screen = [
    AdminDashBoard(),
    AdminResidentList(),
    AdminCollectorsList(),
    UserRatings(),
  ];
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 7, 62, 107),
        centerTitle: true,
        foregroundColor: Colors.white,
        title: Text(
          index == 0
              ? 'DASHBOARD'
              : index == 1
                  ? 'RESIDENT LIST'
                  : index == 2
                      ? 'COLLECTOR LIST'
                      : 'USER RATINGS',
          style: GoogleFonts.passionOne(
            textStyle: const TextStyle(fontSize: 35, color: Colors.white),
          ),
        ),
      ),
      body: screen[index],
      drawer: navDrawer(context),
    );
  }

  Widget navDrawer(BuildContext context) {
    return Drawer(
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

  Widget buildHeader() => Container(
        padding: EdgeInsets.only(top: 50),
        color: Color.fromARGB(255, 7, 62, 107),
        width: double.infinity,
        height: 200,
        child: Container(
          child: Column(
            children: [
              CircleAvatar(
                radius: 40,
                foregroundImage: AssetImage('assets/ekalakal_logo.png'),
              ),
              SizedBox(
                height: 3,
              ),
              Text(
                'EKALAKAL ADMIN',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Text(FirebaseAuth.instance.currentUser!.email.toString(),
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white))
            ],
          ),
        ),
      );

  Widget buildMenuItems() => Container(
        color: Colors.green[300],
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(24),
        child: Wrap(
          runSpacing: 16,
          children: [
            ListTile(
              iconColor: Color.fromARGB(255, 7, 62, 107),
              textColor: Color.fromARGB(255, 7, 62, 107),
              leading: Icon(
                Icons.dashboard,
                size: 40,
              ),
              title: Text(
                'DASHBOARD',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                setState(() {
                  index = 0;
                });
                Navigator.pop(context);
              },
            ),
            Divider(
              thickness: 1,
            ),
            ListTile(
              iconColor: Color.fromARGB(255, 7, 62, 107),
              textColor: Color.fromARGB(255, 7, 62, 107),
              leading: Icon(
                Icons.people_alt,
                size: 40,
              ),
              title: Text(
                'RESIDENT LIST',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                setState(() {
                  index = 1;
                });
                Navigator.pop(context);
              },
            ),
            Divider(
              thickness: 1,
            ),
            ListTile(
              iconColor: Color.fromARGB(255, 7, 62, 107),
              textColor: Color.fromARGB(255, 7, 62, 107),
              leading: Icon(
                Icons.delivery_dining_sharp,
                size: 40,
              ),
              title: Text(
                'COLLECTOR LIST',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                setState(() {
                  index = 2;
                });
                Navigator.pop(context);
              },
            ),
            Divider(
              thickness: 1,
            ),
            ListTile(
              iconColor: Color.fromARGB(255, 7, 62, 107),
              textColor: Color.fromARGB(255, 7, 62, 107),
              leading: Icon(
                Icons.trending_up,
                size: 40,
              ),
              title: Text(
                'USERS RATINGS',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                setState(() {
                  index = 3;
                });
                Navigator.pop(context);
              },
            ),
            Divider(
              thickness: 1,
            ),
            ListTile(
              iconColor: Color.fromARGB(255, 7, 62, 107),
              textColor: Color.fromARGB(255, 7, 62, 107),
              leading: Icon(
                Icons.logout,
                size: 40,
              ),
              title: Text(
                'LOG OUT',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                FirebaseAuth.instance.signOut();
              },
            ),
            Divider(
              thickness: 1,
            ),
          ],
        ),
      );
}
