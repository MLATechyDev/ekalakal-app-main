import 'package:ekalakal/authentication/storage_services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../databaseUser/users.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BookPage extends StatefulWidget {
  BookPage({Key? key}) : super(key: key);

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  final _formkey = GlobalKey<FormState>();

  final nameTextController = TextEditingController();
  final addressController = TextEditingController();
  final contactController = TextEditingController();
  final descriptionController = TextEditingController();

  final FirebaseApi storage = FirebaseApi();
  var path;
  var fileName;
  String _fileName = 'No File Selected!';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: Container(
        margin: EdgeInsets.fromLTRB(30, 30, 30, 0),
        child: ListView(
          children: [
            const Text(
              'Book your Kalakal',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            // Text(
            //   'Kalakal',
            //   style: TextStyle(
            //     fontSize: 20,
            //     fontWeight: FontWeight.bold,
            //     letterSpacing: 1,
            //   ),
            // ),
            const SizedBox(height: 10),
            KeyboardDismisser(
              gestures: const [GestureType.onTap],
              child: Center(
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      buildTextName(),
                      const SizedBox(
                        height: 5,
                      ),
                      buildTextAddress(),
                      const SizedBox(
                        height: 5,
                      ),
                      buildTextContact(),
                      const SizedBox(
                        height: 5,
                      ),
                      buildDescription(),
                      const SizedBox(
                        height: 5,
                      ),
                      btnUploadPhoto(),
                      const SizedBox(height: 5),
                      Text(_fileName),
                      const SizedBox(height: 100),
                      btnBook(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
          labelText: 'Name',
          prefixIcon: const Icon(Icons.person),
          suffixIcon: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => nameTextController.clear(),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        keyboardType: TextInputType.name,
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
          labelText: 'Address',
          prefixIcon: const Icon(Icons.house),
          suffixIcon: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => addressController.clear(),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        keyboardType: TextInputType.streetAddress,
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
          labelText: 'Contact Number',
          prefixIcon: const Icon(Icons.contact_phone),
          suffixIcon: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => contactController.clear(),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        keyboardType: TextInputType.phone,
      );
  Widget buildDescription() => TextFormField(
        maxLength: 200,
        controller: descriptionController,
        decoration: InputDecoration(
          labelText: 'Description',
          prefixIcon: const Icon(Icons.description),
          suffixIcon: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => descriptionController.clear(),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        keyboardType: TextInputType.text,
      );

  Widget btnBook() => ElevatedButton(
        style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)))),
        onPressed: () {
          final isValid = _formkey.currentState!.validate();
          if (!isValid) return;
          final user = UserInfo(
              name: nameTextController.text,
              address: addressController.text,
              contactnumber: contactController.text,
              description: descriptionController.text);

          createBook(user);
          fileUpload();

          nameTextController.clear();
          addressController.clear();
          contactController.clear();
          descriptionController.clear();
          Fluttertoast.showToast(
            msg: 'Book Successfully!',
            fontSize: 18,
          );
        },
        child: const Text(
          "Book",
          style: TextStyle(fontSize: 18),
        ),
      );

  Widget btnUploadPhoto() => OutlinedButton(
        onPressed: filePicker,
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.blue,
          minimumSize: const Size(100, 50),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
        ),
        child: const Text(
          "Upload Photo",
          style: TextStyle(fontSize: 18),
        ),
      );

  Future filePicker() async {
    final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg', 'jpeg']);

    if (result == null) return;
    path = result.files.single.path!;
    fileName = result.files.single.name;

    setState(() {
      _fileName = fileName;
    });

    // storage.fileUpload(path, fileName).then((value) => print('Done'));
  }

  Future fileUpload() async {
    await storage.uploadFile(path, fileName);
  }

  Future createBook(UserInfo user) async {
    final docUser = FirebaseFirestore.instance.collection('appointments').doc();

    user.id = docUser.id;
    user.status = 'pending';
    final json = user.toJson();
    await docUser.set(json);
  }
}
