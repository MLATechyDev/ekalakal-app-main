import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserRatings extends StatefulWidget {
  const UserRatings({super.key});

  @override
  State<UserRatings> createState() => _UserRatingsState();
}

class _UserRatingsState extends State<UserRatings> {
  final items = ['All', '5.0', '4.0', '3.0', '2.0', '1.0'];
  String? value = 'All';
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 8,
          ),
          dropDownList(),
          SizedBox(
            height: 10,
          ),
          listViewRating(),
        ],
      ),
    );
  }

  Widget listViewRating() => Container(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('ratings').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Something went wrong'),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            final data = snapshot.requireData;
            return ListView.builder(
                shrinkWrap: true,
                itemCount: data.size,
                itemBuilder: (context, index) {
                  if (value != 'All') {
                    if (data.docs[index]['ratings'] == value) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Container(
                          color: Colors.amberAccent,
                          child: ListTile(
                            leading: Icon(Icons.star),
                            title: SelectableText(
                              'UID: ${data.docs[index]['userID']}',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w700),
                            ),
                            subtitle: SelectableText(
                              'comment: ${data.docs[index]['comment']}',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                            trailing: Text(
                              data.docs[index]['ratings'],
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      );
                    }
                  }
                  if (value == 'All') {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 5),
                      child: Container(
                        color: Colors.amberAccent,
                        child: ListTile(
                          leading: Icon(Icons.star),
                          title: SelectableText(
                            'UID: ${data.docs[index]['userID']}',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w700),
                          ),
                          subtitle: SelectableText(
                            'comment: ${data.docs[index]['comment']}',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                          trailing: Text(
                            data.docs[index]['ratings'],
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    );
                  }
                  return Container();
                });
          },
        ),
      );

  Widget dropDownList() => Container(
        color: Colors.grey,
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(3),
          decoration: BoxDecoration(
              color: Colors.white70, borderRadius: BorderRadius.circular(5)),
          height: 40,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
                value: value,
                menuMaxHeight: 400,
                onChanged: (value) {
                  setState(() {
                    this.value = value;
                  });
                },
                items: items.map(buildMenuItems).toList()),
          ),
        ),
      );

  DropdownMenuItem<String> buildMenuItems(String item) => DropdownMenuItem(
      value: item,
      child: Text(
        item,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ));
}
