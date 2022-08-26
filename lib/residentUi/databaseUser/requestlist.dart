import 'package:ekalakal/residentUi/databaseUser/users.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../databaseUser/res_app_info.dart';

class RequestList extends StatefulWidget {
  const RequestList({super.key});

  @override
  State<RequestList> createState() => _RequestListState();
}

class _RequestListState extends State<RequestList> {
  final Stream<QuerySnapshot> appointments = FirebaseFirestore.instance
      .collection('appointments')
      .where('status', isEqualTo: 'pending')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: StreamBuilder<QuerySnapshot>(
          stream: appointments,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                itemCount: data.size,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            color: Colors.amberAccent,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: ListTile(
                          leading: Icon(Icons.star),
                          title: Text('Name: ${data.docs[index]['name']}'),
                          subtitle:
                              Text('Address: ${data.docs[index]['address']}'),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return ResListinfo(
                                    status: data.docs[index]['status'],
                                    name: data.docs[index]['name'],
                                    address: data.docs[index]['address'],
                                    contactnumber: data.docs[index]
                                        ['contact number'],
                                    description: data.docs[index]
                                        ['description'],
                                    id: data.docs[index]['id'],
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 8.0))
                    ],
                  );
                });
          }),
    );
  }
}

class OnGoingList extends StatefulWidget {
  const OnGoingList({super.key});

  @override
  State<OnGoingList> createState() => _OnGoingListState();
}

class _OnGoingListState extends State<OnGoingList> {
  Stream<QuerySnapshot> appointments = FirebaseFirestore.instance
      .collection('appointments')
      .where('status', isEqualTo: 'ongoing')
      .snapshots();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: StreamBuilder<QuerySnapshot>(
          stream: appointments,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                itemCount: data.size,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            color: Colors.lightBlue,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: ListTile(
                          leading: Icon(Icons.star),
                          title: Text('Name: ${data.docs[index]['name']}'),
                          subtitle:
                              Text('Address: ${data.docs[index]['address']}'),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return ResListinfo(
                                    status: data.docs[index]['status'],
                                    name: data.docs[index]['name'],
                                    address: data.docs[index]['address'],
                                    contactnumber: data.docs[index]
                                        ['contact number'],
                                    description: data.docs[index]
                                        ['description'],
                                    id: data.docs[index]['id'],
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 8.0))
                    ],
                  );
                });
          }),
    );
  }
}
