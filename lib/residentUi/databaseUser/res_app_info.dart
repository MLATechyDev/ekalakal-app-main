import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekalakal/authentication/storage_services.dart';
import '../databaseUser/requestlist.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ResListinfo extends StatefulWidget {
  final emailuid = FirebaseAuth.instance.currentUser!.uid;
  String name, address, contactnumber;
  String description;
  ResListinfo(
      {Key? key,
      required this.id,
      required this.status,
      required this.name,
      required this.address,
      required this.contactnumber,
      required this.description,
      required this.acceptBy});
  String status;
  String id;

  String acceptBy;
  @override
  State<ResListinfo> createState() => _ResListinfoState();
}

class _ResListinfoState extends State<ResListinfo> {
  final Stream<QuerySnapshot> resAppInfo =
      FirebaseFirestore.instance.collection('appointments').snapshots();

  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text('Your Appointment'),
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Appointment status: ${widget.status}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Name : ${widget.name}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Address : ${widget.address}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Contact # : ${widget.contactnumber}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Item Description : ${widget.description}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  widget.acceptBy == 'none'
                      ? Container()
                      : Text('Accept by: ${widget.acceptBy}'),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 400,
                child: FutureBuilder(
                    future: listFiles(),
                    builder: (BuildContext context,
                        AsyncSnapshot<firebase_storage.ListResult> snapshot) {
                      if (snapshot.hasError) {
                        return const Scaffold(
                          body: Center(
                            child: Text('Something went Wrong!'),
                          ),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Scaffold(
                          body: Center(
                            child: Text('Loading....'),
                          ),
                        );
                      }

                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                  iconSize: 30,
                                  color: index == 0 ? Colors.grey : Colors.blue,
                                  onPressed: () {
                                    if (index > 0) {
                                      setState(() {
                                        index = index - 1;
                                      });
                                    }
                                  },
                                  icon:
                                      const Icon(Icons.arrow_back_ios_rounded)),
                              IconButton(
                                  iconSize: 30,
                                  color:
                                      index == snapshot.data!.items.length - 1
                                          ? Colors.grey
                                          : Colors.blue,
                                  onPressed: () {
                                    if (index <
                                        snapshot.data!.items.length - 1) {
                                      setState(() {
                                        index = index + 1;
                                      });
                                    }
                                  },
                                  icon: const Icon(
                                      Icons.arrow_forward_ios_rounded)),
                            ],
                          ),
                          Text('Images ${index + 1}'),
                          Container(
                            height: 300,
                            width: 300,
                            child: FutureBuilder(
                                future: downloadURL(
                                    snapshot.data!.items[index].name),
                                builder: (BuildContext context,
                                    AsyncSnapshot<String> image) {
                                  if (image.hasError) {
                                    return const Scaffold(
                                      body: Center(
                                        child: Text('Something went Wrong!'),
                                      ),
                                    );
                                  }
                                  if (image.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Scaffold(
                                      body: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  }
                                  return SizedBox(
                                    width: 150,
                                    height: 150,
                                    child: Image.network(
                                      image.data!,
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                }),
                          ),
                        ],
                      );
                    }),
              ),
              const SizedBox(
                height: 20,
              ),
              widget.acceptBy == 'none'
                  ? Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: () {
                          final docUser = FirebaseFirestore.instance
                              .collection('appointments')
                              .doc(widget.id);

                          docUser.delete();
                          deleteAppointment(widget.id);
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Cancel Appointment',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Future<firebase_storage.ListResult> listFiles() async {
    firebase_storage.ListResult result = await storage.ref(widget.id).listAll();

    result.items.forEach((firebase_storage.Reference ref) {
      print('Found file: $ref');
    });
    return result;
  }

  Future<String> downloadURL(String imageName) async {
    String downloadURL =
        await storage.ref('${widget.id}/$imageName').getDownloadURL();

    return downloadURL;
  }

  Future deleteAppointment(String path) async {
    await firebase_storage.FirebaseStorage.instance
        .ref(path)
        .listAll()
        .then((value) {
      for (var element in value.items) {
        firebase_storage.FirebaseStorage.instance
            .ref(element.fullPath)
            .delete();
      }
    });
  }
}
