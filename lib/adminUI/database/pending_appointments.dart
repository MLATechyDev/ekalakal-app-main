import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekalakal/adminUI/appointments/appointmentsINFO.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PendingAppointments extends StatefulWidget {
  const PendingAppointments({super.key});

  @override
  State<PendingAppointments> createState() => _PendingAppointmentState();
}

class _PendingAppointmentState extends State<PendingAppointments> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 7, 62, 107),
        centerTitle: true,
        foregroundColor: Colors.white,
        title: Text(
          'PENDING APPOINTMENTS',
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
                .where('status', isEqualTo: 'pending')
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
                          color: Colors.red[400],
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
                                contactnumber: data.docs[index]
                                    ['contact number'],
                                date: data.docs[index]['date'],
                                time: data.docs[index]['time'],
                                imageID: data.docs[index]['id'],
                                description: data.docs[index]['description'],
                              );
                            }));
                          },
                          textColor: Colors.white70,
                          trailing: Icon(Icons.pending_rounded),
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
