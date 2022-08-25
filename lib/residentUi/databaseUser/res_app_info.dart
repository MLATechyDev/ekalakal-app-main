import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../databaseUser/requestlist.dart';

class ResListinfo extends StatefulWidget {
  const ResListinfo({super.key});

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
          child: StreamBuilder(
        stream: resAppInfo,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong!'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Text('Loading'),
            );
          }
          final data = snapshot.requireData;

          return ListView.builder(
              shrinkWrap: true,
              itemCount: 1,
              itemBuilder: (context, index) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 200,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Appointment status: ${data.docs[index = counterKey]['status']}',
                                style: TextStyle(fontSize: 20),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Name: ${data.docs[index = counterKey]['name']}',
                                style: TextStyle(fontSize: 20),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Address: ${data.docs[index = counterKey]['address']}',
                                style: TextStyle(fontSize: 20),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Contact #: ${data.docs[index = counterKey]['contact number']}',
                                style: TextStyle(fontSize: 20),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Description: ${data.docs[index = counterKey]['description']}',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection('appointments')
                                .doc(data.docs[index]['id'])
                                .delete();

                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'Cancel Appointment',
                            style: TextStyle(fontSize: 15),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              });
        },
      )),
    );
  }
}
