import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekalakal/collectorUi/collectorMaps/collectorMaps.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class CollectorAppInfo extends StatefulWidget {
  final String name, address, contactnumber, description;
  CollectorAppInfo(
      {Key? key,
      required this.longitude,
      required this.latitude,
      required this.name,
      required this.address,
      required this.contactnumber,
      required this.description,
      required this.id,
      required this.acceptBy})
      : super(key: key);
  final String id;
  final String acceptBy;
  final String longitude;
  final String latitude;

  @override
  State<CollectorAppInfo> createState() => _CollectorAppInfoState();
}

class _CollectorAppInfoState extends State<CollectorAppInfo> {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  int index = 0;
  final reasonTEC = TextEditingController();
  final dateTime = DateTime.now();

  final user = FirebaseAuth.instance.currentUser!;
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              appDetails(),
              // Text(
              //   'Name: ${widget.name}',
              //   style: const TextStyle(fontSize: 18),
              // ),
              // const SizedBox(
              //   height: 8,
              // ),
              // Text(
              //   'Address: ${widget.address}',
              //   style: const TextStyle(fontSize: 18),
              // ),
              // const SizedBox(
              //   height: 8,
              // ),
              // Text(
              //   'Contact #: ${widget.contactnumber}',
              //   style: const TextStyle(fontSize: 18),
              // ),
              // const SizedBox(
              //   height: 8,
              // ),
              // Text(
              //   'Description: ${widget.description}',
              //   style: const TextStyle(fontSize: 18),
              // ),

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
                      if (!snapshot.hasData) {
                        return Center(
                          child: SizedBox(
                            height: 300,
                            width: 300,
                            child: Text('Image load Failed due to internet'),
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
                      if (snapshot.hasData) {
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                    iconSize: 30,
                                    color:
                                        index == 0 ? Colors.grey : Colors.blue,
                                    onPressed: () {
                                      if (index > 0) {
                                        setState(() {
                                          index = index - 1;
                                        });
                                      }
                                    },
                                    icon: const Icon(
                                        Icons.arrow_back_ios_rounded)),
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
                            snapshot.data!.items.length == 0
                                ? Container(
                                    height: 300,
                                    width: 300,
                                    child: Center(
                                      child: Text(
                                          'This Appointment has no image or\n Did not upload correctly.'),
                                    ),
                                  )
                                : Container(
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
                                                child: Text(
                                                    'Something went Wrong!'),
                                              ),
                                            );
                                          }

                                          if (image.connectionState ==
                                              ConnectionState.waiting) {
                                            return const Scaffold(
                                              body: Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                            );
                                          }
                                          return Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30)),
                                            height: 150,
                                            width: 150,
                                            child: Image.network(
                                              image.data!,
                                              fit: BoxFit.cover,
                                            ),
                                          );
                                        }),
                                  ),
                          ],
                        );
                      }
                      return Container();
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
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Center(child: btnrouteAppointment()),
                            SizedBox(
                              width: 10,
                            ),
                            Center(child: btnCancelAppointment()),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget appDetails() {
    return Container(
      color: Colors.pink[50],
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Name:',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              Text(
                widget.name,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                'Address:',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              Text(
                widget.address,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                'Contact Number:',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              Text(
                widget.contactnumber,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                'Item Description:',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              Text(
                widget.description,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget btnCancelAppointment() => OutlinedButton(
        style: OutlinedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: Colors.white,
            primary: Colors.red,
            side: const BorderSide(width: 1, color: Colors.red),
            minimumSize: Size(100, 40)),
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return SizedBox(
                  height: 400,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                    child: Center(
                        child: Column(
                      children: [
                        Text(
                          'Why do you want to cancel? Please specify.',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        CupertinoButton(
                            child: Text('Wrong Address'),
                            onPressed: () {
                              final docUser = FirebaseFirestore.instance
                                  .collection('appointments')
                                  .doc(widget.id);

                              docUser.update({
                                'status': 'cancel',
                              });
                              docUser.set({'reason': 'Wrong Address'},
                                  SetOptions(merge: true)).then((value) {
                                // Do your stuff.
                              });
                              Fluttertoast.showToast(
                                  msg: 'Your response have been reviewed',
                                  fontSize: 15,
                                  textColor: Colors.black,
                                  backgroundColor: Colors.amberAccent);
                              Navigator.pop(context);
                            }),
                        Divider(
                          color: Colors.grey,
                          thickness: 1,
                          height: 2,
                        ),
                        CupertinoButton(
                            child: Text('Fake Booking'),
                            onPressed: () {
                              final docUser = FirebaseFirestore.instance
                                  .collection('appointments')
                                  .doc(widget.id);

                              docUser.update({
                                'status': 'cancel',
                              });
                              docUser.set({'reason': 'Fake Booking'},
                                  SetOptions(merge: true)).then((value) {
                                // Do your stuff.
                              });
                              Fluttertoast.showToast(
                                  msg: 'Your response have been reviewed',
                                  fontSize: 15,
                                  textColor: Colors.black,
                                  backgroundColor: Colors.amberAccent);
                              Navigator.pop(context);
                            }),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          height: 50,
                          child: TextField(
                            controller: reasonTEC,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'If others please specify.'),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              minimumSize: Size(100, 50),
                              onPrimary: Colors.white),
                          onPressed: () {
                            if (reasonTEC.text.length != 0) {
                              final docUser = FirebaseFirestore.instance
                                  .collection('appointments')
                                  .doc(widget.id);

                              docUser.update({
                                'status': reasonTEC.text,
                              });
                              docUser.set({'reason': 'Fake Booking'},
                                  SetOptions(merge: true)).then((value) {
                                // Do your stuff.
                              });
                              Fluttertoast.showToast(
                                  msg: 'Your response have been reviewed',
                                  fontSize: 15,
                                  textColor: Colors.black,
                                  backgroundColor: Colors.amberAccent);
                              Navigator.pop(context);
                            } else {
                              Fluttertoast.showToast(
                                  msg: 'Please select a reason',
                                  fontSize: 15,
                                  textColor: Colors.white,
                                  backgroundColor: Colors.red);
                            }
                          },
                          child: Text('Submit'),
                        ),
                      ],
                    )),
                  ),
                );
              });
        },
        child: Text(
          'Cancel Appointment',
          style: TextStyle(fontSize: 15),
        ),
      );

  Widget btnrouteAppointment() => ElevatedButton(
      style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          onPrimary: Colors.white,
          primary: Colors.red,
          minimumSize: Size(200, 40)),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return RouteMap(
                latitude: this.widget.latitude,
                longitude: this.widget.longitude,
              );
            },
          ),
        );
      },
      child: Text(
        'Route Resident',
        style: TextStyle(fontSize: 15),
      ));

  expectedTimeArrival() {
    final newTime = dateTime.add(Duration(hours: 3));
    final expectedTimeArrival = DateFormat('hh:mm a').format(newTime);

    return expectedTimeArrival;
  }

  Widget btnAccept() => ElevatedButton(
        onPressed: () async {
          QuerySnapshot fullname = await FirebaseFirestore.instance
              .collection('userpos')
              .where('email', isEqualTo: user.email!)
              .get();

          final docUser = FirebaseFirestore.instance
              .collection('appointments')
              .doc(widget.id);

          docUser.update({
            'status': 'ongoing',
            'acceptBy': user.uid,
          });
          docUser.set({
            'collectorsName': fullname.docs.first['name'],
            'expectedTimeArrival': expectedTimeArrival().toString(),
          }, SetOptions(merge: true)).then((value) {
            // Do your stuff.
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
