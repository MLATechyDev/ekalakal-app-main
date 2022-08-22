import 'package:ekalakal/residentUi/databaseUser/users.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../databaseUser/res_app_info.dart';

var counterKey;

class RequestList extends StatefulWidget {
  const RequestList({super.key});

  @override
  State<RequestList> createState() => _RequestListState();
}

class _RequestListState extends State<RequestList> {
  final Stream<QuerySnapshot> appointments =
      FirebaseFirestore.instance.collection('appointments').snapshots();

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
            // final List<UserInfo> resList = List.generate(
            //     data.size,
            //     (index) => UserInfo(
            //         name: data.docs[index]['name'].toString(),
            //         address: data.docs[index]['address'].toString(),
            //         contactnumber: data.docs[index]['contactnumber'],
            //         description: data.docs[index]['description']));
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
                            counterKey = index;
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return ResListinfo();
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
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: 1,
          itemBuilder: (context, index) {
            return Container(
              decoration: const BoxDecoration(
                  color: Colors.lightBlue,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: const ListTile(
                leading: Icon(Icons.star),
                title: Text('Name: Sample stactic'),
                subtitle: Text('Address: Static'),
              ),
            );
          }),
    );
  }
}
