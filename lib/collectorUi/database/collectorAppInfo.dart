import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekalakal/collectorUi/pages/collector_dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ekalakal/authentication/storage_services.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class CollectorAppInfo extends StatefulWidget {
  final String name, address, contactnumber, description;
  CollectorAppInfo(
      {Key? key,
      required this.name,
      required this.address,
      required this.contactnumber,
      required this.description,
      required this.id,
      required this.acceptBy})
      : super(key: key);
  final String id;
  final String acceptBy;

  @override
  State<CollectorAppInfo> createState() => _CollectorAppInfoState();
}

class _CollectorAppInfoState extends State<CollectorAppInfo> {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Appointment Information',
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Name: ${widget.name}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Address: ${widget.address}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Contact #: ${widget.contactnumber}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Description: ${widget.description}',
                    style: const TextStyle(fontSize: 18),
                  ),
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
              widget.acceptBy == 'none'
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        btnDecline(),
                        const SizedBox(
                          width: 15,
                        ),
                        btnAccept(),
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Widget btnAccept() => ElevatedButton(
        onPressed: () {
          final docUser = FirebaseFirestore.instance
              .collection('appointments')
              .doc(widget.id);

          docUser.update({
            'status': 'ongoing',
            'acceptBy': FirebaseAuth.instance.currentUser!.uid,
          });

          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
            onPrimary: Colors.white,
            primary: Colors.red,
            minimumSize: const Size(100, 40)),
        child: const Text('Accept'),
      );

  Widget btnDecline() => ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
            onPrimary: Colors.white, minimumSize: const Size(100, 40)),
        child: const Text('Decline'),
      );

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
}
