import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final nameInfomation = FirebaseFirestore.instance
      .collection('userpos')
      .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
      .snapshots();

  final nameTEC = TextEditingController();
  final addressTEC = TextEditingController();
  final contactTEC = TextEditingController();
  final formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('Update Information'),
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
                      child: Form(
                        key: formkey,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 50,
                            ),
                            TextFormField(
                              controller: nameTEC,
                              textAlign: TextAlign.right,
                              decoration: const InputDecoration(
                                labelText: 'Name ',
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
                              controller: addressTEC,
                              textAlign: TextAlign.right,
                              decoration: const InputDecoration(
                                labelText: 'Address ',
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
                              controller: contactTEC,
                              textAlign: TextAlign.right,
                              decoration: const InputDecoration(
                                labelText: 'Contact number',
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
                            ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    final docUser = FirebaseFirestore.instance
                                        .collection('userpos')
                                        .doc(data.docs[index]['id']);

                                    docUser.update({
                                      'name': nameTEC.text,
                                      'address': addressTEC.text,
                                      'contact number': contactTEC.text,
                                    });
                                    Fluttertoast.showToast(
                                      msg: 'Update Successfully',
                                      fontSize: 18,
                                      backgroundColor: Colors.amber,
                                      textColor: Colors.black,
                                    );
                                  });
                                },
                                child: const Text('Save'))
                          ],
                        ),
                      ),
                    ),
                  );
                });
          }),
    );
  }
}
