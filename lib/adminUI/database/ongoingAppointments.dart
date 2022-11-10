import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekalakal/adminUI/appointments/appointmentsINFO.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OnGoingAppointments extends StatefulWidget {
  const OnGoingAppointments({super.key});

  @override
  State<OnGoingAppointments> createState() => _OnGoingAppointmentsState();
}

class _OnGoingAppointmentsState extends State<OnGoingAppointments> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 7, 62, 107),
        centerTitle: true,
        foregroundColor: Colors.white,
        title: Text(
          'ON-GOING APPOINTMENTS',
          style: GoogleFonts.passionOne(
            textStyle: const TextStyle(fontSize: 30, color: Colors.white),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('appointments')
                .where('status', isEqualTo: 'ongoing')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              final data = snapshot.requireData;
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: data.size,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 3),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue[400],
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return AppoinmentInfoDetails(
                                status: data.docs[index]['status'],
                                name: data.docs[index]['name'],
                                userID: data.docs[index]['userid'],
                                address: data.docs[index]['address'],
                                description: data.docs[index]['description'],
                                collectorName: data.docs[index]
                                    ['collectorsName'],
                                collectorUID: data.docs[index]['acceptBy'],
                                imageID: data.docs[index]['id'],
                              );
                            }));
                          },
                          textColor: Colors.white,
                          trailing: Icon(Icons.delivery_dining_sharp),
                          title: Text(
                            'Name: ${data.docs[index]['name']}',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Address: ${data.docs[index]['address']}',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            }),
      ),
    );
  }
}
