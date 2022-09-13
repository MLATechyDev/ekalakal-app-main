import 'package:ekalakal/residentUi/databaseUser/users.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      .where('userid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
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
                  if (data.docs[index]['status'] == 'pending') {
                    return Column(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              color: Colors.amberAccent,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: ListTile(
                            leading: Icon(Icons.star),
                            title: Text(
                              'Name: ${data.docs[index]['name']}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
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
                                      acceptBy: data.docs[index]['acceptBy'],
                                    );
                                  },
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
                                  data.docs[index]['date'],
                                  style: const TextStyle(color: Colors.black54),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(top: 8.0))
                      ],
                    );
                  }
                  return Container();
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
  final Stream<QuerySnapshot> appointments = FirebaseFirestore.instance
      .collection('appointments')
      .where('userid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
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
                  if (data.docs[index]['status'] == 'ongoing') {
                    return Column(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              color: Colors.lightBlue,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: ListTile(
                            textColor: Colors.white,
                            leading: const Icon(Icons.star),
                            title: Text(
                              'Name: ${data.docs[index]['name']}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
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
                                        acceptBy: data.docs[index]['acceptBy']);
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(top: 8.0))
                      ],
                    );
                  }
                  return Container();
                });
          }),
    );
  }
}
