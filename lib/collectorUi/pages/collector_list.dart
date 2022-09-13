import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekalakal/collectorUi/collectorMaps/collectorMaps.dart';
import 'package:ekalakal/collectorUi/database/collectorAppInfo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CollectorList extends StatefulWidget {
  const CollectorList({super.key});

  @override
  State<CollectorList> createState() => _CollectorListState();
}

class _CollectorListState extends State<CollectorList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50, bottom: 50),
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return MapSample();
                  }));
                },
                child: const Text(
                  'Maps',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ),
          const Divider(
            height: 30,
            color: Colors.black,
            thickness: 5,
          ),
          const Text(
            'Accepted Appointments',
            style: TextStyle(fontSize: 18),
          ),
          const Divider(
            height: 30,
            color: Colors.black,
            thickness: 5,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('appointments')
                  .where('acceptBy',
                      isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Something went wrong'),
                  );
                }
                final data = snapshot.requireData;
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: data.size,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: const BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: ListTile(
                        textColor: Colors.white,
                        title: Text(
                          'Name ${data.docs[index]['name']}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle:
                            Text('Address ${data.docs[index]['address']}'),
                        trailing: const Icon(Icons.pin_drop_rounded),
                        onTap: () {
                          final String id = data.docs[index]['id'];
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => CollectorAppInfo(
                                name: data.docs[index]['name'],
                                address: data.docs[index]['address'],
                                contactnumber: data.docs[index]
                                    ['contact number'],
                                description: data.docs[index]['description'],
                                id: id,
                                acceptBy: data.docs[index]['acceptBy'],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
