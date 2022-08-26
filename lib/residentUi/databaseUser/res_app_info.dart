import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../databaseUser/requestlist.dart';

class ResListinfo extends StatefulWidget {
  String name, address, contactnumber;
  String description;
  ResListinfo(
      {Key? key,
      required this.id,
      required this.status,
      required this.name,
      required this.address,
      required this.contactnumber,
      required this.description});
  String status;
  String id;
  @override
  State<ResListinfo> createState() => _ResListinfoState();
}

class _ResListinfoState extends State<ResListinfo> {
  final Stream<QuerySnapshot> resAppInfo =
      FirebaseFirestore.instance.collection('appointments').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Appointment'),
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Appointment status: ${widget.status}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Name : ${widget.name}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Address : ${widget.address}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Contact # : ${widget.contactnumber}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Item Description : ${widget.description}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 50,
            ),
            Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                    onPressed: () {
                      final docUser = FirebaseFirestore.instance
                          .collection('appointments')
                          .doc(widget.id);

                      docUser.delete();

                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Cancel Appointment',
                      style: TextStyle(fontSize: 20),
                    )))
          ],
        ),
      ),
    );
  }
}
