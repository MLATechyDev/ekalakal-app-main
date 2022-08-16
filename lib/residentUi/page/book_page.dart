import 'package:flutter/material.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

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
            Text(
              'Book your Kalakal',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            SizedBox(
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
            SizedBox(height: 10),
            KeyboardDismisser(
              gestures: [GestureType.onTap],
              child: Center(
                child: Column(
                  children: [
                    buildTextName(),
                    SizedBox(
                      height: 5,
                    ),
                    buildTextAddress(),
                    SizedBox(
                      height: 5,
                    ),
                    buildTextContact(),
                    SizedBox(
                      height: 5,
                    ),
                    buildDescription(),
                    SizedBox(
                      height: 5,
                    ),
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
          prefixIcon: Icon(Icons.person),
          suffixIcon: IconButton(
            icon: Icon(Icons.close),
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
          prefixIcon: Icon(Icons.house),
          suffixIcon: IconButton(
            icon: Icon(Icons.close),
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
          prefixIcon: Icon(Icons.contact_phone),
          suffixIcon: IconButton(
            icon: Icon(Icons.close),
            onPressed: () => contactController.clear(),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        keyboardType: TextInputType.phone,
      );
  Widget buildDescription() => TextField(
        controller: descriptionController,
        decoration: InputDecoration(
          labelText: 'Description',
          prefixIcon: Icon(Icons.description),
          suffixIcon: IconButton(
            icon: Icon(Icons.close),
            onPressed: () => descriptionController.clear(),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        keyboardType: TextInputType.text,
      );
}
