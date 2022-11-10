import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekalakal/information/user_location.dart';
import 'package:ekalakal/information/user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import 'changepassForm.dart';
// import 'package:geolocator/geolocator.dart';

class EditProfile extends StatefulWidget {
  EditProfile({
    Key? key,
  });
  // String longitude, latitude;

  // EditProfile({
  //   required this.longitude,
  //   required this.latitude,
  // });

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final nameInfomation = FirebaseFirestore.instance
      .collection('userpos')
      .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
      .snapshots();

  final user = FirebaseAuth.instance.currentUser!;

  final firstnameTEC = TextEditingController();
  final middlenameTEC = TextEditingController();
  final lastnameTEC = TextEditingController();
  var addressTEC = TextEditingController();

  final contactTEC = TextEditingController();
  final formkey = GlobalKey<FormState>();

  late Position position;

  final ImagePicker _picker = ImagePicker();
  List<XFile> _selectedFiles = [];

  FirebaseStorage _storageRef = FirebaseStorage.instance;

  List<String> _arrImageURL = [];

  double locationHeight = 60;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
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
                  firstnameTEC.text = data.docs[index]['firstname'];
                  middlenameTEC.text = data.docs[index]['middlename'];
                  lastnameTEC.text = data.docs[index]['lastname'];
                  contactTEC.text = data.docs[index]['contact number'];

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: Form(
                        key: formkey,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Contact',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            SizedBox(
                              height: 8,
                            ),
                            TextFormField(
                              validator: (value) {
                                if (lastnameTEC.text.isEmpty || value == null) {
                                  return " Please fill this field!";
                                } else if (value.length < 3) {
                                  return "Please enter a valid Last Name";
                                } else {
                                  return null;
                                }
                              },
                              onTap: () {
                                lastnameTEC.text = '';
                              },
                              onEditingComplete: () {
                                this.lastnameTEC.text = lastnameTEC.text;
                              },
                              controller: lastnameTEC,
                              decoration: const InputDecoration(
                                suffix: Icon(Icons.edit),
                                labelText: 'Last Name ',
                                contentPadding: EdgeInsets.only(
                                  right: 10,
                                  left: 10,
                                ),
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            TextFormField(
                              validator: (value) {
                                if (firstnameTEC.text.isEmpty ||
                                    value == null) {
                                  return " Please fill this field!";
                                } else if (value.length < 3) {
                                  return "Please enter a valid First Name";
                                } else {
                                  return null;
                                }
                              },
                              onTap: () {
                                firstnameTEC.text = '';
                              },
                              onEditingComplete: () {
                                this.firstnameTEC.text = firstnameTEC.text;
                              },
                              controller: firstnameTEC,
                              decoration: const InputDecoration(
                                suffix: Icon(Icons.edit),
                                labelText: 'First Name',
                                contentPadding: EdgeInsets.only(
                                  right: 10,
                                  left: 10,
                                ),
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            TextFormField(
                              validator: (value) {
                                if (middlenameTEC.text.isEmpty ||
                                    value == null) {
                                  return " Please fill this field!";
                                } else if (value.length < 3) {
                                  return "Please enter a valid Middle Name";
                                } else {
                                  return null;
                                }
                              },
                              onTap: () {
                                middlenameTEC.text = '';
                              },
                              onEditingComplete: () {
                                this.middlenameTEC.text = middlenameTEC.text;
                              },
                              controller: middlenameTEC,
                              decoration: const InputDecoration(
                                suffix: Icon(Icons.edit),
                                labelText: 'Middle Name',
                                contentPadding: EdgeInsets.only(
                                  right: 10,
                                  left: 10,
                                ),
                                border: OutlineInputBorder(),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            TextFormField(
                              validator: (value) {
                                if (contactTEC.text.isEmpty || value == null) {
                                  return " Please fill this field!";
                                } else if (value.length < 11 ||
                                    value.length > 11) {
                                  return "Invalid Contact Number";
                                } else {
                                  return null;
                                }
                              },
                              onTap: () {
                                contactTEC.text = '';
                              },
                              onEditingComplete: () {
                                this.contactTEC.text = contactTEC.text;
                              },
                              controller: contactTEC,
                              decoration: const InputDecoration(
                                suffix: Icon(Icons.edit),
                                labelText: 'Contact number',
                                contentPadding: EdgeInsets.only(
                                  right: 10,
                                  left: 10,
                                ),
                                border: OutlineInputBorder(),
                              ),
                            ),
                            Divider(
                              color: Colors.black45,
                              thickness: 1,
                              height: 30,
                            ),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Address',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            SizedBox(
                              height: 8,
                            ),
                            btnLocation(),
                            const SizedBox(
                              height: 10,
                            ),
                            txtAddress(),
                            Divider(
                              color: Colors.black45,
                              thickness: 1,
                              height: 30,
                            ),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Verification',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            Divider(
                              thickness: 1,
                              height: 1,
                            ),
                            uploadID(),
                            Divider(
                              thickness: 1,
                              height: 1,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 5.0, bottom: 5.0),
                              child: TextFormField(
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
                            ),
                            const SizedBox(
                              height: 10,
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
                                  onPressed: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return ChangePasswordForm();
                                    }));
                                  },
                                  child: Text(
                                    'Change Password',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  )),
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
                                  final isValid =
                                      formkey.currentState!.validate();
                                  if (!isValid) return;

                                  setState(() {
                                    final docUser = FirebaseFirestore.instance
                                        .collection('userpos')
                                        .doc(data.docs[index]['id']);

                                    docUser.update({
                                      'name':
                                          '${firstnameTEC.text} ${lastnameTEC.text}',
                                      'lastname': lastnameTEC.text,
                                      'firstname': firstnameTEC.text,
                                      'middlename': middlenameTEC.text,
                                      'address': addressTEC.text,
                                      'contact number': contactTEC.text,
                                      'isVerify': 'updated'
                                    });
                                    docUser.set({
                                      'longitude':
                                          position.longitude.toString(),
                                      'latitude': position.latitude.toString(),
                                      'profileID': FirebaseAuth
                                          .instance.currentUser!.uid,
                                    }, SetOptions(merge: true)).then((value) {
                                      //Do your stuff.
                                    });

                                    uploadFunction(_selectedFiles);

                                    Navigator.pop(context);
                                    Fluttertoast.showToast(
                                      msg: 'Update Successfully',
                                      fontSize: 18,
                                      backgroundColor: Colors.amber,
                                      textColor: Colors.black,
                                    );
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                    onPrimary: Colors.white),
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

  Widget btnLocation() {
    return ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
            onPrimary: Colors.white, minimumSize: Size(double.infinity, 40)),
        onPressed: () async {
          final location = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return UserLocation();
              },
            ),
          );

          position = location;
        },
        icon: Icon(Icons.location_on),
        label: Text('Select Location'));
  }

  Widget txtAddress() {
    return Column(
      children: [
        TextFormField(
          validator: (value) {
            if (addressTEC.text.isEmpty || value == null) {
              return " Please fill this field!";
            } else {
              return null;
            }
          },
          controller: addressTEC,
          onTap: () async {
            final address = await Navigator.push(context,
                MaterialPageRoute(builder: (context) {
              return EditAddress();
            }));

            addressTEC.text = address;
          },
          decoration: InputDecoration(
            suffixIcon: Icon(
              Icons.arrow_forward_ios,
              size: 20,
            ),
            labelText: 'Address',
            contentPadding: EdgeInsets.only(
              right: 10,
              left: 10,
            ),
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(
          height: 8,
        ),
      ],
    );
  }

  Widget uploadID() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.zero,
            alignment: Alignment.topLeft,
            child: TextButton(
                onPressed: () {
                  selectImage();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Upload ID ',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '(Upload any kind of id for verification)',
                      style:
                          TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                    ),
                  ],
                )),
          ),
          SizedBox(
            width: 20,
          ),
          Text('${_selectedFiles.length} file selected',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))
        ],
      ),
    );
  }

  Future selectImage() async {
    if (_selectedFiles != 0) {
      _selectedFiles.clear();
    }
    try {
      final List<XFile>? imgs = await _picker.pickMultiImage();
      if (imgs!.isNotEmpty) {
        _selectedFiles.addAll(imgs);
      }
      print('Selected items: ' + imgs.length.toString());
    } catch (e) {
      print(e.toString());
    }
    setState(() {});
  }

  //TODO upload mutiphoto
  void uploadFunction(List<XFile> images) {
    for (int i = 0; i < images.length; i++) {
      var imageURL = fileUpload(images[i]);
      _arrImageURL.add(imageURL.toString());
    }

    print('Done');
  }

  Future<String> fileUpload(XFile images) async {
    Reference reference =
        _storageRef.ref().child('uploadedID/${user.uid}').child(images.name);
    UploadTask uploadTask = reference.putFile(File(images.path));
    await uploadTask.whenComplete(() async {
      print(reference.getDownloadURL());
    });

    return await reference.getDownloadURL();
  }
}
