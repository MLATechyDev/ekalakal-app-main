import 'dart:io';

import 'package:ekalakal/information/edit_profile.dart';
import 'package:firebase_auth/firebase_auth.dart' as currentuid;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../databaseUser/users.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class BookPage extends StatefulWidget {
  BookPage({Key? key}) : super(key: key);

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  final getDate = DateTime.now();
  final _formkey = GlobalKey<FormState>();

  final nameTextController = TextEditingController();
  final addressController = TextEditingController();
  final contactController = TextEditingController();
  final descriptionController = TextEditingController();

  late String longitude;
  late String latitude;
  bool isVerify = false;

  final ImagePicker _picker = ImagePicker();
  List<XFile> _selectedFiles = [];

  FirebaseStorage _storageRef = FirebaseStorage.instance;

  List<String> _arrImageURL = [];
  late String pathid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: SingleChildScrollView(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('userpos')
                .where('email',
                    isEqualTo:
                        currentuid.FirebaseAuth.instance.currentUser!.email)
                .snapshots(),
            builder: (BuildContext, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return SizedBox(
                  child: Center(
                    child: Text('Something went wrong'),
                  ),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (snapshot.requireData.docs.first['isVerify'] == 'new') {
                isVerify = true;
              } else {
                isVerify = false;
              }
              return isVerify
                  ? Container(
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                              'Setup Your Profile First',
                              style: GoogleFonts.bebasNeue(
                                textStyle: const TextStyle(
                                  fontSize: 20,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return EditProfile();
                                }));
                              },
                              child: Text(
                                'Setup now',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        Text(
                          'Book Your Kalakal',
                          style: GoogleFonts.bebasNeue(
                            textStyle: const TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: Form(
                            key: _formkey,
                            child: Column(
                              children: [
                                textFieldScreen(),
                                buildDescription(),
                                const SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                          ),
                        ),
                        btnUploadPhoto(),
                        const SizedBox(height: 8),
                        Center(child: gridBuilder()),
                        const SizedBox(height: 30),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: btnBook(),
                        ),
                      ],
                    );
            },
          ),
        ),
      ),
    );
  }

  Widget gridBuilder() => GridView.builder(
      shrinkWrap: true,
      itemCount: _selectedFiles.length,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.all(2.0),
          child: Image.file(
            File(_selectedFiles[index].path),
            fit: BoxFit.cover,
          ),
        );
      });

  Widget buildTextName() => TextFormField(
        validator: (value) {
          if (nameTextController.text.isEmpty || value == null) {
            return " Please fill this field!";
          } else if (value.length < 3) {
            return "Please enter a valid Name";
          } else {
            return null;
          }
        },
        controller: nameTextController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          labelText: 'Name',
          prefixIcon: const Icon(Icons.person),
          suffixIcon: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => nameTextController.clear(),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );

  Widget buildTextAddress() => TextFormField(
        validator: (value) {
          if (addressController.text.isEmpty || value == null) {
            return " Please fill this field!";
          } else if (value.length < 10) {
            return "Please enter a valid Address";
          } else {
            return null;
          }
        },
        controller: addressController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          labelText: 'Address',
          prefixIcon: const Icon(Icons.house),
          suffixIcon: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => addressController.clear(),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
  Widget buildTextContact() => TextFormField(
        validator: (value) {
          if (contactController.text.isEmpty || value == null) {
            return " Please fill this field!";
          } else if (value.length < 11 || value.length > 11) {
            return "Invalid Contact Number";
          } else {
            return null;
          }
        },
        controller: contactController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          labelText: 'Contact Number',
          prefixIcon: const Icon(Icons.contact_phone),
          suffixIcon: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => contactController.clear(),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        keyboardType: TextInputType.phone,
      );
  Widget buildDescription() => TextFormField(
        maxLength: 200,
        controller: descriptionController,
        decoration: InputDecoration(
          labelText: 'Item Description',
          prefixIcon: const Icon(Icons.description),
          suffixIcon: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => descriptionController.clear(),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        keyboardType: TextInputType.text,
      );

  Widget btnBook() => ElevatedButton(
        style: ElevatedButton.styleFrom(
            onPrimary: Colors.white,
            minimumSize: const Size(double.infinity, 50),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25)))),
        onPressed: () async {
          final isValid = _formkey.currentState!.validate();
          if (!isValid) return;

          final user = UserInfo(
            name: nameTextController.text,
            address: addressController.text,
            contactnumber: contactController.text,
            description: descriptionController.text,
            longitude: longitude,
            latitude: latitude,
          );

          // imageUrl: _fileName == 'No File Selected!'
          //     ? 'No File Selected'
          //     : _fileName);

          //TODO MultiPhoto
          if (_selectedFiles.isNotEmpty) {
            createBook(user);
            uploadFunction(_selectedFiles);
            descriptionController.clear();
            setState(() {
              _selectedFiles.clear();
            });
            Fluttertoast.showToast(
                msg: 'Book Successfully',
                fontSize: 18,
                backgroundColor: Colors.amber,
                textColor: Colors.black);
          } else {
            Fluttertoast.showToast(
                msg: 'Please Select Images',
                fontSize: 18,
                backgroundColor: Colors.amber,
                textColor: Colors.black);
          }
        },
        child: Text(
          'Book',
          style: GoogleFonts.bebasNeue(
            textStyle: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ),
      );

  Widget btnUploadPhoto() => OutlinedButton(
        onPressed: () {
          selectImage();
        },
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.blue,
          minimumSize: const Size(100, 50),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25))),
        ),
        child: Text(
          'Upload Photo',
          style: GoogleFonts.bebasNeue(
            textStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ),
      );

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

  Widget textFieldScreen() => StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('userpos')
          .where('email',
              isEqualTo: currentuid.FirebaseAuth.instance.currentUser!.email)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('Something went wrong'),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Text('Loading Please Wait'),
          );
        }
        final data = snapshot.requireData;

        return ListView.builder(
          shrinkWrap: true,
          itemCount: data.size,
          itemBuilder: (context, index) {
            nameTextController.text = data.docs[index]['name'];
            addressController.text = data.docs[index]['address'];
            contactController.text = data.docs[index]['contact number'];
            longitude = data.docs[index]['longitude'];
            latitude = data.docs[index]['latitude'];
            return Column(
              children: [
                buildTextName(),
                const SizedBox(
                  height: 8,
                ),
                buildTextAddress(),
                const SizedBox(
                  height: 8,
                ),
                buildTextContact(),
                const SizedBox(
                  height: 10,
                ),
              ],
            );
          },
        );
      });

//TODO upload mutiphoto
  void uploadFunction(List<XFile> images) {
    for (int i = 0; i < images.length; i++) {
      var imageURL = fileUpload(images[i]);
      _arrImageURL.add(imageURL.toString());
    }

    print('Done');
  }

  Future<String> fileUpload(XFile images) async {
    Reference reference = _storageRef.ref().child(pathid).child(images.name);
    UploadTask uploadTask = reference.putFile(File(images.path));
    await uploadTask.whenComplete(() async {
      print(reference.getDownloadURL());
    });

    return await reference.getDownloadURL();
  }

  Future createBook(UserInfo user) async {
    final docUser = FirebaseFirestore.instance.collection('appointments').doc();

    pathid = docUser.id;
    user.id = docUser.id;
    user.status = 'pending';
    user.acceptBy = 'none';

    user.useruid = currentuid.FirebaseAuth.instance.currentUser!.uid;
    user.date = DateFormat('yyyy-MM-dd').format(getDate);
    user.time = DateFormat('hh:mm a').format(getDate);
    final json = user.toJson();
    await docUser.set(json);
  }
}
