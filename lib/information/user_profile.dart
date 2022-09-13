import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekalakal/information/edit_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final nameInfomation = FirebaseFirestore.instance
      .collection('userpos')
      .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Profile Information'),
      ),
      body: StreamBuilder(
          stream: nameInfomation,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('Something went wrong!'),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Text('Loading please wait!'),
              );
            }
            final data = snapshot.requireData;

            return ListView.builder(
                itemCount: data.size,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 50,
                          ),
                          TextFormField(
                            enabled: false,
                            textAlign: TextAlign.right,
                            initialValue: data.docs[index]['name'],
                            decoration: const InputDecoration(
                              prefix: Text('Name '),
                              contentPadding: EdgeInsets.only(
                                right: 50,
                                left: 10,
                              ),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            enabled: false,
                            textAlign: TextAlign.right,
                            initialValue: data.docs[index]['address'],
                            decoration: const InputDecoration(
                              prefix: Text('Address '),
                              contentPadding: EdgeInsets.only(
                                right: 50,
                                left: 10,
                              ),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            enabled: false,
                            textAlign: TextAlign.right,
                            initialValue: data.docs[index]['contact number'],
                            decoration: const InputDecoration(
                              prefix: Text('Contact number '),
                              contentPadding: EdgeInsets.only(
                                right: 50,
                                left: 10,
                              ),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            enabled: false,
                            textAlign: TextAlign.right,
                            initialValue: data.docs[index]['email'],
                            decoration: const InputDecoration(
                              prefix: Text('Email '),
                              contentPadding: EdgeInsets.only(
                                right: 50,
                                left: 10,
                              ),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Divider(
                            height: 2,
                            color: Colors.grey.shade200,
                            thickness: 2,
                          ),
                          Container(
                            padding: EdgeInsets.zero,
                            alignment: Alignment.topLeft,
                            child: TextButton(
                                onPressed: () {},
                                child: Text('Change Password')),
                          ),
                          Divider(
                            height: 2,
                            color: Colors.grey.shade300,
                            thickness: 2,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          OutlinedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return const EditProfile();
                                    },
                                  ),
                                );
                              },
                              child: const Text('Edit'))
                        ],
                      ),
                    ),
                  );
                });
          }),
    );
  }
}
