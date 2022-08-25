import 'package:flutter/material.dart';

class CollectorList extends StatefulWidget {
  const CollectorList({super.key});

  @override
  State<CollectorList> createState() => _CollectorListState();
}

class _CollectorListState extends State<CollectorList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Center(child: Text('List')),
    ));
  }
}
