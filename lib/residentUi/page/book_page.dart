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
  final nameTextController = TextEditingController();
  final addressController = TextEditingController();
  final contactController = TextEditingController();
  final descriptionController = TextEditingController();
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        btnBook(),
                        const SizedBox(
                          width: 20,
                        ),
                        btnUploadPhoto()
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextName() => TextField(
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

  Widget buildTextAddress() => TextField(
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
  Widget buildTextContact() => TextField(
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
        style: ElevatedButton.styleFrom(minimumSize: Size(100, 50)),
        onPressed: () {
          final user = UserInfo(
              name: nameTextController.text,
              address: addressController.text,
              contactnumber: contactController.text,
              description: descriptionController.text);

          createuser(user);
          nameTextController.clear();
          addressController.clear();
          contactController.clear();
          descriptionController.clear();
          Fluttertoast.showToast(
            msg: 'Book Successfully!',
            fontSize: 18,
          );
        },
        child: const Text("Book"),
      );

  Widget btnUploadPhoto() => ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(minimumSize: Size(100, 50)),
        child: const Text(
          "Upload Photo",
        ),
      );

  Future createuser(UserInfo user) async {
    final docUser = FirebaseFirestore.instance.collection('appointments').doc();

    user.id = docUser.id;
    final json = user.toJson();
    await docUser.set(json);
  }
}
