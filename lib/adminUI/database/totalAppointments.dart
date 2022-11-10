import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TotalAppointments extends StatefulWidget {
  const TotalAppointments({super.key});

  @override
  State<TotalAppointments> createState() => _TotalAppointmentsState();
}

class _TotalAppointmentsState extends State<TotalAppointments> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 7, 62, 107),
        centerTitle: true,
        foregroundColor: Colors.white,
        title: Text(
          'TOTAL APPOINTMENTS',
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
                          color: data.docs[index]['status'] == 'pending'
                              ? Colors.red[400]
                              : data.docs[index]['status'] == 'ongoing'
                                  ? Colors.blue[400]
                                  : Colors.orange,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: ListTile(
                          onTap: () {
                            // Navigator.push(context,
                            //     MaterialPageRoute(builder: (context) {
                            //   return UserInfoinAdmin(
                            //     profileID: data.docs[index]['profileID'],
                            //     usersName: data.docs[index]['name'],
                            //     position: data.docs[index]['position'],
                            //     address: data.docs[index]['address'],
                            //     contactnumber: data.docs[index]
                            //         ['contact number'],
                            //     email: data.docs[index]['email'],
                            //     usersID: data.docs[index]['id'],
                            //   );
                            // }));
                          },
                          textColor: Colors.white70,
                          trailing: data.docs[index]['status'] == 'pending'
                              ? Icon(Icons.pending)
                              : data.docs[index]['status'] == 'ongoing'
                                  ? Icon(Icons.delivery_dining_sharp)
                                  : Icon(Icons.warning),
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
                                'Status: ' +
                                    data.docs[index]['status']
                                        .toString()
                                        .toUpperCase(),
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
