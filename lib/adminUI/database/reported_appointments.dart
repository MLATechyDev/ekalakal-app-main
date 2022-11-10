import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekalakal/adminUI/appointments/appointmentsINFO.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReportedAppointments extends StatefulWidget {
  const ReportedAppointments({super.key});

  @override
  State<ReportedAppointments> createState() => _ReportedAppointmentsState();
}

class _ReportedAppointmentsState extends State<ReportedAppointments> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 7, 62, 107),
        centerTitle: true,
        foregroundColor: Colors.white,
        title: Text(
          'CANCELED APPOINTMENTS',
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
                .where('status', isEqualTo: 'cancel')
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
                          color: Colors.orange,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return AppoinmentInfoDetails(
                                name: data.docs[index]['name'],
                                address: data.docs[index]['address'],
                                userID: data.docs[index]['userid'],
                                collectorName: data.docs[index]
                                    ['collectorsName'],
                                collectorUID: data.docs[index]['acceptBy'],
                                reasontoCancelled: data.docs[index]['reason'],
                                imageID: data.docs[index]['id'],
                                status: data.docs[index]['status'],
                                description: data.docs[index]['description'],
                              );
                            }));
                          },
                          textColor: Colors.white70,
                          trailing: Icon(Icons.warning),
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
                              Text(
                                'Reason: ${data.docs[index]['reason']}',
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
