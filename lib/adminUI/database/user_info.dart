import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekalakal/authentication/storage_services.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class UserInfoinAdmin extends StatefulWidget {
  String profileID;
  String usersName;
  String position;
  String address;
  String contactnumber;
  String email;
  String usersID;
  String adminVerify;
  UserInfoinAdmin({
    Key? key,
    this.adminVerify = '',
    this.profileID = '',
    this.usersName = '',
    this.position = '',
    this.address = '',
    this.contactnumber = '',
    this.email = '',
    this.usersID = '',
  });

  @override
  State<UserInfoinAdmin> createState() => _UserInfoinAdminState();
}

class _UserInfoinAdminState extends State<UserInfoinAdmin> {
  String fakeBookingMessage =
      'We received reports that your account commits "FAKE BOOKING".\nOnce it is repeated again we can disable or ban your account.';
  String wrongAddressMessage =
      'We have received reports that your account is placing false information about placing the "Wrong Address",\nmaking sure to put in the right detail to avoid this problem.';
  final messageTEC = TextEditingController();
  final double profileHeight = 150;
  final double coverHeight = 150;
  FirebaseApi storage = FirebaseApi();
  final getDate = DateTime.now();

  int reportCount = 0;

  final firebase_storage.FirebaseStorage uploadedID =
      firebase_storage.FirebaseStorage.instance;
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 7, 62, 107),
        foregroundColor: Colors.white,
        title: Text(
          'USER INFO',
          style: GoogleFonts.passionOne(
            textStyle: const TextStyle(fontSize: 35, color: Colors.white),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildTop(),
            buildContent(),
          ],
        ),
      ),
    );
  }

  Stack buildTop() {
    final top = coverHeight - profileHeight / 2;
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: profileHeight / 2),
          child: buildCoverImage(),
        ),
        Positioned(
          left: 20,
          top: top,
          child: buildProfileImage(),
        ),
        Positioned(
            left: 175,
            bottom: 40,
            child: Text(
              widget.usersName.toString(),
              style: GoogleFonts.bebasNeue(
                textStyle: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1),
              ),
            )),
      ],
    );
  }

  Widget buildCoverImage() => Container(
        color: Colors.grey,
        child: Image.asset(
          'assets/bg1.png',
          width: double.infinity,
          height: coverHeight,
          fit: BoxFit.cover,
        ),
      );

  Widget buildProfileImage() => Container(
        height: 150,
        width: 150,
        child: FutureBuilder(
            future: storage.downloadURL(widget.profileID.toString()),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                return Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100)),
                  child: CircleAvatar(
                    radius: profileHeight / 2,
                    backgroundColor: Colors.grey,
                    backgroundImage: !snapshot.hasData
                        ? const NetworkImage(
                            'https://www.salisburyut.com/wp-content/uploads/2020/09/avatar-1-scaled.jpeg')
                        : NetworkImage(snapshot.data!),
                  ),
                );
              }
              return Container();
            }),
      );

  Widget buildContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'DETAILS',
            style: GoogleFonts.bebasNeue(
              textStyle: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w500, letterSpacing: 1),
            ),
          ),
          Divider(
            thickness: 2,
          ),
          details(
              'ADMIN VERIFY :', widget.adminVerify.toString().toUpperCase()),
          details('POSITION :', widget.position.toString().toUpperCase()),
          details('ADDRESS : ', widget.address.toString()),
          details('CONTACT NUMBER : ', widget.contactnumber.toString()),
          details('EMAIL : ', widget.email.toString()),
          Divider(
            thickness: 2,
          ),
          Container(
            height: 400,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(children: [
                Text(
                  'UPLOADED ID: ',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                                      color: index == 0
                                          ? Colors.grey
                                          : Colors.blue,
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
                                      color: index ==
                                              snapshot.data!.items.length - 1
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
                                      width: 400,
                                      child: Center(
                                        child: Text(
                                          'This User did not upload Any ID',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      height: 300,
                                      width: 400,
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
              ]),
            ),
          ),
          Divider(
            thickness: 2,
          ),
          Row(
            children: [
              details('REPORT COUNTS :', reportCount.toString()),
              TextButton(onPressed: showReportCount, child: Text('REFRESH'))
            ],
          ),
          Divider(
            thickness: 2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isViewed();
                  });

                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  primary: widget.adminVerify == 'new'
                      ? Colors.green
                      : widget.adminVerify == 'disable'
                          ? Colors.green
                          : Colors.red,
                ),
                child: Text(
                  widget.adminVerify == 'new'
                      ? 'VERIFY ACCOUNT'
                      : widget.adminVerify == 'disable'
                          ? 'ENABLE ACCOUNT'
                          : 'DISABLE ACCOUNT',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              sendWarning(),
            ],
          ),
          SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }

  Widget sendWarning() => ElevatedButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return SizedBox(
                  height: 600,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8, right: 8, top: 10, bottom: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    messageTEC.text = fakeBookingMessage;
                                  });
                                },
                                child: Text(
                                  'About Fake Booking',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                )),
                            SizedBox(
                              width: 10,
                            ),
                            OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    messageTEC.text = wrongAddressMessage;
                                  });
                                },
                                child: Text(
                                  'About Wrong Address',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                )),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: messageTEC,
                          maxLines: 5,
                          maxLength: 200,
                          decoration: InputDecoration(
                              labelText: 'Message',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            final docUser = await FirebaseFirestore.instance
                                .collection('adminmessage')
                                .doc();
                            docUser.set({
                              'id': docUser.id,
                              'isRead': 'notread',
                              'uid': widget.profileID,
                              'message': messageTEC.text,
                              'time': DateFormat('hh:mm a').format(getDate),
                              'date': DateFormat('yyyy-MM-dd').format(getDate),
                            }, SetOptions(merge: true)).then((value) {
                              // Do your stuff.
                            });

                            Navigator.pop(context);
                            Fluttertoast.showToast(
                                msg: 'Message Sent',
                                backgroundColor: Colors.amberAccent);
                          },
                          child: Text(
                            'Send Message',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.white),
                          )),
                    ],
                  ),
                );
              });
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.red,
        ),
        child: Text(
          'SEND WARNING',
          style: TextStyle(color: Colors.white),
        ),
      );

  Future showReportCount() async {
    QuerySnapshot count = await FirebaseFirestore.instance
        .collection('appointments')
        .where('userid', isEqualTo: widget.profileID)
        .where('status', isEqualTo: 'cancel')
        .get();

    setState(() {
      reportCount = count.size;
    });
  }

  Future isViewed() async {
    final docUser = await FirebaseFirestore.instance
        .collection('userpos')
        .doc(widget.usersID);

    if (widget.adminVerify == 'new') {
      docUser.update({
        'adminVerify': 'viewed',
      });
    }
    if (widget.adminVerify == 'viewed') {
      docUser.update({
        'adminVerify': 'disable',
      });
    }
    if (widget.adminVerify == 'disable') {
      docUser.update({
        'adminVerify': 'viewed',
      });
    }
  }

  Widget details(String title, String child) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            width: 20,
          ),
          Text(
            child,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }

  Future<firebase_storage.ListResult> listFiles() async {
    firebase_storage.ListResult result = await uploadedID
        .ref('uploadedID/${widget.profileID.toString()}')
        .listAll();

    result.items.forEach((firebase_storage.Reference ref) {
      print('Found file: $ref');
    });
    return result;
  }

  Future<String> downloadURL(String imageName) async {
    String downloadURL = await uploadedID
        .ref('uploadedID/${widget.profileID.toString()}/$imageName')
        .getDownloadURL();

    return downloadURL;
  }
}
