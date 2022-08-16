import 'package:flutter/material.dart';
import 'registrationpage.dart';

class MsgBoxError extends StatefulWidget {
  MsgBoxError({super.key});

  @override
  State<MsgBoxError> createState() => _MsgBoxErrorState();
}

class _MsgBoxErrorState extends State<MsgBoxError> {
  late String errorMsg;
  @override
  Widget build(BuildContext context) {
    if (errorMsg != null) {
      return Container(
        color: Colors.red,
        width: double.infinity,
        padding: const EdgeInsets.all(8.0),
        height: 50,
        child: Row(
          children: [
            Icon(Icons.error_outline),
          ],
        ),
      );
    }
    return SizedBox(
      height: 0,
    );
  }
}
