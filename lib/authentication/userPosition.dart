import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekalakal/adminUI/admin_main.dart';
import 'package:ekalakal/collectorUi/collector_main.dart';
import 'package:ekalakal/loginpage.dart';
import 'package:ekalakal/residentUi/resident_main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class UserWrap extends StatefulWidget {
  UserWrap({super.key});

  @override
  State<UserWrap> createState() => _UserWrapState();
}

class _UserWrapState extends State<UserWrap> {
  final Stream<QuerySnapshot> userPosition = FirebaseFirestore.instance
      .collection('userpos')
      .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: userPosition,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong!'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Text('Loading please wait!'),
            );
          }

          final data = snapshot.requireData;
          int index = 0;

          if (data.docs[index]['adminVerify'] == 'disable') {
            return DisableAccount();
          } else {
            return data.docs[index]['position'] == 'collector'
                ? CollectorMain()
                : data.docs[index]['position'] == 'resident'
                    ? ResidentMainApp()
                    : data.docs[index]['position'] == 'admin'
                        ? AdminMain()
                        : LoginPage();
          }
        },
      ),
    );
  }
}

class DisableAccount extends StatefulWidget {
  const DisableAccount({super.key});

  @override
  State<DisableAccount> createState() => _DisableAccountState();
}

class _DisableAccountState extends State<DisableAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'NOTICE',
          style: GoogleFonts.passionOne(
            textStyle: const TextStyle(fontSize: 35, color: Colors.white),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: Center(
        child: Text(
          'Your account are temporarily disable',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
