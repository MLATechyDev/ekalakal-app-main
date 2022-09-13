import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekalakal/collectorUi/collector_main.dart';
import 'package:ekalakal/residentUi/resident_main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

          return data.docs[index]['position'] == 'collector'
              ? CollectorMain()
              : ResidentMainApp();
        },
      ),
    );
  }
}
