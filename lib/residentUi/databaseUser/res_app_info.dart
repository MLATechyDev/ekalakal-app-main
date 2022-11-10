import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ResListinfo extends StatefulWidget {
  final emailuid = FirebaseAuth.instance.currentUser!.uid;
  String name, address, contactnumber;
  String description;
  String collectorsName;
  String expectedTimeArrival;
  ResListinfo(
      {Key? key,
      required this.id,
      required this.status,
      required this.name,
      required this.address,
      required this.contactnumber,
      required this.description,
      required this.acceptBy,
      this.expectedTimeArrival = '',
      this.collectorsName = ''});
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

  double rating = 0;

  final commentTEC = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text('Your Appointment'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 3.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 200,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Status:',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                widget.status,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: widget.status == 'ongoing'
                                        ? Colors.green
                                        : Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ),
                      widget.status == 'pending' ? Container() : ifOngoing(),
                      SizedBox(
                        height: 8,
                      ),
                      appDetails()
                    ],
                  ),
                ),
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

                      return SingleChildScrollView(
                        child: Column(
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
                                        'This Appointment has no image or\n Did not upload correctly.',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  )
                                : Container(
                                    height: 300,
                                    width: 300,
                                    decoration: BoxDecoration(
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Colors.grey,
                                            blurRadius: 5,
                                            spreadRadius: 1,
                                            offset: Offset(4, 4)),
                                      ],
                                    ),
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
                        ),
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
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(100, 40),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30))),
                      onPressed: () async {
                        QuerySnapshot isRating = await FirebaseFirestore
                            .instance
                            .collection('ratings')
                            .where('userID',
                                isEqualTo:
                                    FirebaseAuth.instance.currentUser!.uid)
                            .get();
                        isRating.size != 0
                            ? scrapCompleted()
                            : showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                      title: Text('Rate this app'),
                                      content: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Give us an star rating.',
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          buildRating(),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          commentRating(),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              scrapCompleted();
                                              Navigator.pop(context);
                                            },
                                            child: Text('Later',
                                                style:
                                                    TextStyle(fontSize: 16))),
                                        TextButton(
                                            onPressed: () async {
                                              scrapCompleted();
                                              userRating();

                                              Navigator.pop(context);
                                            },
                                            child: Text('Done',
                                                style: TextStyle(fontSize: 16)))
                                      ],
                                    ));
                      },
                      child: Text(
                        'Scrap Collected',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      )),
            ],
          ),
        ),
      ),
    );
  }

  void scrapCompleted() {
    final docUser =
        FirebaseFirestore.instance.collection('appointments').doc(widget.id);

    docUser.delete();
    deleteAppointment(widget.id);
    Fluttertoast.showToast(
        msg: 'Done', fontSize: 18, backgroundColor: Colors.amberAccent);
  }

  Future userRating() async {
    final docUser = FirebaseFirestore.instance
        .collection('ratings')
        .doc(FirebaseAuth.instance.currentUser!.uid);
    docUser.set({
      'userID': FirebaseAuth.instance.currentUser!.uid.toString(),
      'ratings': rating.toString(),
      'comment': commentTEC.text,
    });
  }

  Widget commentRating() {
    return TextField(
        controller: commentTEC,
        decoration: InputDecoration(
            hintText: 'Please leave a comment', border: OutlineInputBorder()));
  }

  Widget buildRating() {
    return RatingBar.builder(
        minRating: 1,
        initialRating: 1,
        itemSize: 46,
        updateOnDrag: true,
        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
        itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
        onRatingUpdate: (rating) => setState(() {
              this.rating = rating;
            }));
  }

  Widget ifOngoing() {
    return Container(
      padding: EdgeInsets.all(5.0),
      color: Colors.lightBlue[50],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Collector Information',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          Divider(
            height: 3,
            thickness: 1,
          ),
          Row(
            children: [
              Text('Collectors Name: ',
                  style: TextStyle(
                    fontSize: 15,
                  )),
              Text(widget.collectorsName,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
            ],
          ),
          Row(
            children: [
              Text('Expected Time Arrival: ',
                  style: TextStyle(
                    fontSize: 15,
                  )),
              Text(widget.expectedTimeArrival,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }

  Widget appDetails() {
    return Container(
      color: Colors.pink[50],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Information',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          Divider(
            height: 3,
            thickness: 1,
          ),
          Row(
            children: [
              Text('Name: ',
                  style: TextStyle(
                    fontSize: 15,
                  )),
              Text(widget.name,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
            ],
          ),
          Row(
            children: [
              Text('Address: ',
                  style: TextStyle(
                    fontSize: 15,
                  )),
              Text(widget.address,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
            ],
          ),
          Row(
            children: [
              Text('Contact Number: ',
                  style: TextStyle(
                    fontSize: 15,
                  )),
              Text(widget.contactnumber,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
            ],
          ),
          Row(
            children: [
              Text('Item Description: ',
                  style: TextStyle(
                    fontSize: 15,
                  )),
              Text(widget.description,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
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
