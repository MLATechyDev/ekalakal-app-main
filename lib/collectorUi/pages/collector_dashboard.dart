import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekalakal/collectorUi/database/collectorAppInfo.dart';
import 'package:flutter/material.dart';

class CollectorDashboard extends StatefulWidget {
  const CollectorDashboard({super.key});

  @override
  State<CollectorDashboard> createState() => _CollectorDashboardState();
}

class _CollectorDashboardState extends State<CollectorDashboard> {
  Stream<QuerySnapshot> residentAppointment = FirebaseFirestore.instance
      .collection('appointments')
      .where('status', isEqualTo: 'pending')
      .snapshots();

  int appointmentCount = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              topUi(),
              const Text(
                'List of Appointments',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              appointmentList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget topUi() => Container(
        height: 200,
        width: double.infinity,
        child: Image.asset(
          'assets/bg_junk.jpg',
          fit: BoxFit.cover,
        ),
      );

  Widget appointmentList() {
    return StreamBuilder<QuerySnapshot>(
        stream: residentAppointment,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong!'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Text('loading please wait!'),
            );
          }
          final data = snapshot.requireData;

          return ListView.builder(
              shrinkWrap: true,
              itemCount: data.size,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.amberAccent,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.star),
                      title: Text(
                        'Name: ${data.docs[index]['name']}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('Address: ${data.docs[index]['address']}'),
                      onTap: () {
                        final String id = data.docs[index]['id'];
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CollectorAppInfo(
                              name: data.docs[index]['name'],
                              address: data.docs[index]['address'],
                              contactnumber: data.docs[index]['contact number'],
                              description: data.docs[index]['description'],
                              id: id,
                              acceptBy: data.docs[index]['acceptBy'],
                            ),
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
                );
              });
        });
  }
}
