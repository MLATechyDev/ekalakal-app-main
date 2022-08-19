import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
            return ListView.builder(
                shrinkWrap: true,
                itemCount: data.size,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Container(
                        color: Colors.amberAccent,
                        child: ListTile(
                          leading: Icon(Icons.heart_broken),
                          title: Text('Name: ${data.docs[index]['name']}'),
                          subtitle:
                              Text('Address: ${data.docs[index]['address']}'),
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
              color: Colors.lightBlue,
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
