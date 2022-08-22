import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserInfo {
  String id;
  final String name;
  final String address;
  final String contactnumber;
  final String description;

  UserInfo({
    this.id = '',
    required this.name,
    required this.address,
    required this.contactnumber,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'address': address,
        'contact number': contactnumber,
        'description': description,
      };

  static UserInfo fromJson(Map<String, dynamic> json) => UserInfo(
      name: json['name'],
      address: json['address'],
      contactnumber: json['contactnumber'],
      description: json['description']);
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
