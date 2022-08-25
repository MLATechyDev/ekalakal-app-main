import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekalakal/collectorUi/pages/collector_dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CollectorAppInfo extends StatelessWidget {
  final String name, address, contactnumber, description;
  CollectorAppInfo({
    Key? key,
    required this.name,
    required this.address,
    required this.contactnumber,
    required this.description,
    required this.id,
  }) : super(key: key);
  final String id;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment Information'),
      ),
      body: Container(
        height: 300,
        width: double.infinity,
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: $name',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              'Address: $address',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              'Contact #: $contactnumber',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              'Description: $description',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                btnDecline(),
                const SizedBox(
                  width: 15,
                ),
                btnAccept(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget btnAccept() => ElevatedButton(
        onPressed: () {
          final docUser =
              FirebaseFirestore.instance.collection('appointments').doc(id);

          docUser.update({'status': 'ongoing'});
        },
        child: const Text('Accept'),
        style: ElevatedButton.styleFrom(
            primary: Colors.red, minimumSize: Size(100, 40)),
      );

  Widget btnDecline() => ElevatedButton(
        onPressed: () {},
        child: const Text('Decline'),
        style: ElevatedButton.styleFrom(minimumSize: Size(100, 40)),
      );
}
