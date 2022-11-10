import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NoticeMessage extends StatefulWidget {
  String time;
  String date;
  String message;
  String id;
  NoticeMessage({
    Key? key,
    this.time = '',
    this.date = '',
    this.id = '',
    this.message = '',
  });

  @override
  State<NoticeMessage> createState() => _NoticeMessageState();
}

class _NoticeMessageState extends State<NoticeMessage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'REPORT NOTICE',
          style: GoogleFonts.passionOne(
            textStyle: const TextStyle(fontSize: 35, color: Colors.white),
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'DATE: ${widget.date}',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'TIME: ${widget.time}',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              'MESSAGE',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                widget.message,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: () async {
                      final docUser = await FirebaseFirestore.instance
                          .collection('adminmessage')
                          .doc(widget.id);

                      docUser.delete();
                      Navigator.pop(context);
                    },
                    child: Text(
                      'DELETE',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    )),
                SizedBox(
                  width: 70,
                ),
                TextButton(
                    onPressed: () async {
                      final docUser = await FirebaseFirestore.instance
                          .collection('adminmessage')
                          .doc(widget.id);
                      docUser.update({'isRead': 'read'});

                      Navigator.pop(context);
                    },
                    child: Text(
                      'MARK AS READ',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
