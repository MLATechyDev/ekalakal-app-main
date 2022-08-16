import 'package:flutter/material.dart';

class MySquare extends StatelessWidget {
  final String post;
  final String namePost;
  final String pic;

  MySquare({required this.post, required this.namePost, required this.pic});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Card(
        color: Colors.deepPurple[100],
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 100,
                height: 100,
                child: Image.asset(pic),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(post),
                    SizedBox(
                      height: 5,
                    ),
                    Text(namePost),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
