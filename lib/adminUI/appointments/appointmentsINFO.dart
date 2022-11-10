import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:intl/intl.dart';

class AppoinmentInfoDetails extends StatefulWidget {
  String name;
  String address;
  String userID;
  String collectorName;
  String collectorUID;
  String reasontoCancelled;
  String imageID;
  String status;
  String contactnumber;
  String date, time;
  String description;

  AppoinmentInfoDetails({
    Key? key,
    this.name = '',
    this.address = '',
    this.userID = '',
    this.collectorName = '',
    this.collectorUID = '',
    this.reasontoCancelled = '',
    this.imageID = '',
    this.contactnumber = '',
    this.date = '',
    this.time = '',
    this.description = '',
    required this.status,
  });

  @override
  State<AppoinmentInfoDetails> createState() => _AppoinmentInfoDetailsState();
}

class _AppoinmentInfoDetailsState extends State<AppoinmentInfoDetails> {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 7, 62, 107),
        centerTitle: true,
        foregroundColor: Colors.white,
        title: Text('${widget.status} APPOINTMENT',
            style: GoogleFonts.bebasNeue(
                textStyle: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1))),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            widget.status == 'cancel'
                ? onReportedAppointments()
                : widget.status == 'pending'
                    ? pendingAppointments()
                    : widget.status == 'ongoing'
                        ? ongoingAppointments()
                        : Container(),
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
                                              child:
                                                  Text('Something went Wrong!'),
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
          ],
        ),
      ),
    );
  }

  Widget pendingAppointments() => SingleChildScrollView(
        child: Container(
          height: 150,
          width: double.infinity,
          color: Colors.grey[200],
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'RESIDENT DETAILS:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  detailingText(
                      DateFormat('MM-dd-yyyy')
                          .format(DateTime.parse(widget.date))
                          .toString(),
                      widget.time),
                  detailingText('UID:', widget.userID),
                  detailingText('NAME:', widget.name.toUpperCase()),
                  detailingText('ADDRESS:', widget.address.toUpperCase()),
                  detailingText('CONTACT NUMBER:', widget.contactnumber),
                  detailingText('DESCRIPTION', widget.description)
                ],
              ),
            ),
          ),
        ),
      );
  Widget onReportedAppointments() => Column(
        children: [
          Container(
            height: 120,
            width: double.infinity,
            color: Colors.red[100],
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'COLLECTOR DETAILS:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  detailingText('COLLECTOR UID:', widget.collectorUID),
                  detailingText('NAME:', widget.collectorName.toUpperCase()),
                  detailingText('REASON TO CANCEL:',
                      widget.reasontoCancelled.toUpperCase())
                ],
              ),
            ),
          ),
          Container(
            height: 120,
            width: double.infinity,
            color: Colors.grey[200],
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'RESIDENT DETAILS:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  detailingText('RESIDENT UID:', widget.userID),
                  detailingText('NAME:', widget.name.toUpperCase()),
                  detailingText('ADDRESS:', widget.address.toUpperCase()),
                  detailingText('DESCRIPTION:', widget.description),
                ],
              ),
            ),
          ),
        ],
      );
  Widget ongoingAppointments() => Column(
        children: [
          Container(
            height: 120,
            width: double.infinity,
            color: Colors.red[100],
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'COLLECTOR DETAILS:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  detailingText('COLLECTOR UID:', widget.collectorUID),
                  detailingText('NAME:', widget.collectorName.toUpperCase()),
                ],
              ),
            ),
          ),
          Container(
            height: 120,
            width: double.infinity,
            color: Colors.grey[200],
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'RESIDENT DETAILS:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  detailingText('RESIDENT UID:', widget.userID),
                  detailingText('NAME:', widget.name.toUpperCase()),
                  detailingText('ADDRESS:', widget.address.toUpperCase()),
                  detailingText('ITEM DESCRIPTION:', widget.description),
                ],
              ),
            ),
          ),
        ],
      );
  Widget detailingText(String title, String yourText) => Row(
        children: [
          SelectableText(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            width: 10,
          ),
          SelectableText(
            yourText,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      );

  Future<firebase_storage.ListResult> listFiles() async {
    firebase_storage.ListResult result =
        await storage.ref(widget.imageID).listAll();

    result.items.forEach((firebase_storage.Reference ref) {
      print('Found file: $ref');
    });
    return result;
  }

  Future<String> downloadURL(String imageName) async {
    String downloadURL =
        await storage.ref('${widget.imageID}/$imageName').getDownloadURL();

    return downloadURL;
  }
}
