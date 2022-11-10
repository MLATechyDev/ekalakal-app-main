import 'package:cloud_firestore/cloud_firestore.dart';

class UserInfo {
  String id;
  String status;
  String useruid;
  String date;
  String time;
  String acceptBy;
  final String longitude;
  final String latitude;
  final String name;
  final String address;
  final String contactnumber;
  final String description;
  // final String imageUrl;

  UserInfo({
    this.acceptBy = '',
    this.date = '',
    this.time = '',
    this.id = '',
    this.status = '',
    this.useruid = '',
    required this.latitude,
    required this.longitude,
    required this.name,
    required this.address,
    required this.contactnumber,
    required this.description,
    // required this.imageUrl,
  });

  Map<String, dynamic> toJson() => {
        'acceptBy': acceptBy,
        'date': date,
        'time': time,
        'userid': useruid,
        'id': id,
        'status': status,
        'name': name,
        'address': address,
        'contact number': contactnumber,
        'description': description,
        'longitude': longitude,
        'latitude': latitude,

        // 'imageURL': imageUrl,
      };

  static UserInfo fromJson(Map<String, dynamic> json) => UserInfo(
        name: json['name'],
        address: json['address'],
        contactnumber: json['contactnumber'],
        description: json['description'],
        longitude: json['longitude'],
        latitude: json['latitude'],
      );
  // imageUrl: json['imageURL']);
}

Stream<List<UserInfo>> readUser() => FirebaseFirestore.instance
    .collection('appointments')
    .snapshots()
    .map((snapshot) =>
        snapshot.docs.map((doc) => UserInfo.fromJson(doc.data())).toList());

class CounterNum {
  int counter;

  CounterNum(this.counter);
}
