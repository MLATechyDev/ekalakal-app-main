import 'dart:io';

import 'package:ekalakal/authentication/storage_services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as basename;

class ProfileUpload extends StatefulWidget {
  const ProfileUpload({super.key});

  @override
  State<ProfileUpload> createState() => _ProfileUploadState();
}

class _ProfileUploadState extends State<ProfileUpload> {
  final user = FirebaseAuth.instance.currentUser!;
  File? image;
  var _fileName;
  final FirebaseApi storage = FirebaseApi();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'PROFILE',
          style: GoogleFonts.alfaSlabOne(
            textStyle: const TextStyle(fontSize: 30, color: Colors.white),
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Todo proile pic
              Container(
                padding: const EdgeInsets.all(8.0),
                height: 300,
                width: 300,
                child: image != null
                    ? Image.file(
                        image!,
                        height: 160,
                        width: 160,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        height: 160,
                        width: 160,
                        decoration: BoxDecoration(
                          color: Colors.grey[350],
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: const Center(
                            child: Icon(
                          Icons.person,
                          size: 100,
                        )),
                      ),
              ),
              const SizedBox(
                height: 20,
              ),
              image == null ? btnUpload() : btnSave()
            ],
          ),
        ),
      ),
    );
  }

  Widget btnUpload() => Column(
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50), onPrimary: Colors.white),
            onPressed: () {
              imagePicker(ImageSource.gallery);
            },
            child: const Text(
              'Upload Photo',
              style: TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          OutlinedButton(
            style: ElevatedButton.styleFrom(minimumSize: const Size(200, 50)),
            onPressed: () {
              imagePicker(ImageSource.camera);
            },
            child: const Text(
              'Use Camera',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      );

  Widget btnSave() => Column(
        children: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50), onPrimary: Colors.white),
              onPressed: () {
                imageSave();
              },
              child: const Text('Save', style: TextStyle(fontSize: 20))),
          const SizedBox(
            height: 20,
          ),
          OutlinedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel', style: TextStyle(fontSize: 20))),
        ],
      );

  Future imagePicker(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTemp = File(image.path);
      _fileName = FirebaseAuth.instance.currentUser!.uid;

      setState(() {
        this.image = imageTemp;
      });
    } on PlatformException catch (e) {
      // TODO
      print('Failed to pick an image $e');
    }
  }

  Future imageSave() async {
    final profileUpdate =
        FirebaseStorage.instance.ref().child('profilePic/${user.uid}').delete();

    await storage.uploadFile(image!.path, _fileName).then(
          (value) => print('Done'),
        );
  }

  // Future filePicker() async {
  //   final result = await FilePicker.platform.pickFiles(

  //       allowMultiple: true,
  //       type: FileType.custom,
  //       allowedExtensions: ['png', 'jpg', 'jpeg']);

  //   if (result == null) return;
  //   final imagesTemp = File(result.files.single.path!);
  //   // fileName = result.files.single.name;
  //   final fileName = result.files.single.name;

  //   storage
  //       .uploadFile(
  //         imagesTemp.path,
  //       )
  //       .then(
  //         (value) => print('Done'),
  //       );
  //   setState(() {
  //     image = imagesTemp;
  //   });
  // }
}
