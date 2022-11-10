import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekalakal/adminUI/database/user_info.dart';
import 'package:flutter/material.dart';

class AdminCollectorsList extends StatefulWidget {
  const AdminCollectorsList({super.key});

  @override
  State<AdminCollectorsList> createState() => _AdminCollectorsListState();
}

class _AdminCollectorsListState extends State<AdminCollectorsList> {
  final items = ['NAME', 'STATUS', 'UID'];
  String? value = 'NAME';
  String toSearch = 'name';
  final searchBoxTEC = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        searchBar(),
        SizedBox(height: 8),
        listOfCollectors(),
      ],
    );
  }

  Widget listOfCollectors() => StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('userpos')
          .where('position', isEqualTo: 'collector')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
              if (searchBoxTEC.text.length != 0) {
                if (data.docs[index][toSearch.toString()] ==
                        searchBoxTEC.text ||
                    data.docs[index][toSearch.toString()]
                            .toString()
                            .toUpperCase() ==
                        searchBoxTEC.text ||
                    data.docs[index][toSearch.toString()]
                            .toString()
                            .toLowerCase() ==
                        searchBoxTEC.text) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 7, 62, 107),
                          borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        textColor: Colors.white,
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                        ),
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey,
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        title: Text(
                          'NAME: ${data.docs[index]['name'].toString().toUpperCase()}',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'STATUS: ${data.docs[index]['adminVerify'].toString().toUpperCase()}',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                            Text(
                              'UID: ${data.docs[index]['profileID'].toString()}',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return UserInfoinAdmin(
                              profileID: data.docs[index]['profileID'],
                              usersName:
                                  '${data.docs[index]['firstname'].toString().toUpperCase()} ${data.docs[index]['lastname'].toString().toUpperCase()}',
                              position: data.docs[index]['position'],
                              address: data.docs[index]['address'],
                              contactnumber: data.docs[index]['contact number'],
                              email: data.docs[index]['email'],
                              usersID: data.docs[index]['id'],
                              adminVerify: data.docs[index]['adminVerify'],
                            );
                          }));
                        },
                      ),
                    ),
                  );
                }
              }
              if (searchBoxTEC.text.length == 0) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 7, 62, 107),
                        borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      textColor: Colors.white,
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                      ),
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey,
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      title: Text(
                        'NAME: ${data.docs[index]['name'].toString().toUpperCase()}',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'STATUS: ${data.docs[index]['adminVerify'].toString().toUpperCase()}',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            'UID: ${data.docs[index]['profileID'].toString()}',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return UserInfoinAdmin(
                            profileID: data.docs[index]['profileID'],
                            usersName:
                                '${data.docs[index]['firstname'].toString().toUpperCase()} ${data.docs[index]['lastname'].toString().toUpperCase()}',
                            position: data.docs[index]['position'],
                            address: data.docs[index]['address'],
                            contactnumber: data.docs[index]['contact number'],
                            email: data.docs[index]['email'],
                            usersID: data.docs[index]['id'],
                            adminVerify: data.docs[index]['adminVerify'],
                          );
                        }));
                      },
                    ),
                  ),
                );
              }
              return Container();
            });
      });

  Widget searchBar() {
    return Container(
      color: Colors.grey,
      height: 60,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(5)),
                height: 40,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                      value: value,
                      menuMaxHeight: 400,
                      onChanged: (value) {
                        if (value == 'NAME') {
                          setState(() {
                            this.value = value;
                            toSearch = 'name';
                          });
                        }
                        if (value == 'STATUS') {
                          setState(() {
                            this.value = value;
                            toSearch = 'adminVerify';
                          });
                        }
                        if (value == 'UID') {
                          setState(() {
                            this.value = value;
                            toSearch = 'profileID';
                          });
                        }
                      },
                      items: items.map(buildMenuItems).toList()),
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Container(
                  height: 45,
                  width: 300,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5)),
                  child: TextField(
                    controller: searchBoxTEC,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {});
                          },
                          icon: Icon(Icons.search),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5))),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  DropdownMenuItem<String> buildMenuItems(String item) => DropdownMenuItem(
      value: item,
      child: Text(
        item,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ));
}
