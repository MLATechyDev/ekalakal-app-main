import 'dart:async';

import 'package:ekalakal/authentication/userPosition.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EmailVerification extends StatefulWidget {
  const EmailVerification({Key? key}) : super(key: key);

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    // user need to be created before!
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(
        Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();

    super.dispose();
  }

  Future checkEmailVerified() async {
    // call after email verification!
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) timer?.cancel();
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() => canResendEmail = false);
      await Future.delayed(Duration(seconds: 15));
      setState(() => canResendEmail = true);
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        fontSize: 15,
        backgroundColor: Colors.amber,
        textColor: Colors.black,
      );
    }
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? UserWrap()
      : Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: const Text(
              'Email Verification',
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.mail_lock,
                size: 50,
              ),
              const Center(
                child: Text(
                  'An verification email has been sent to your email.\nverified first to continue. ',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              ElevatedButton.icon(
                onPressed: canResendEmail ? sendVerificationEmail : null,
                label: const Text(
                  'Resend Email',
                ),
                icon: const Icon(Icons.mail),
              ),
              const SizedBox(height: 8),
              TextButton(
                  onPressed: () => FirebaseAuth.instance.signOut(),
                  child: const Text('Cancel'))
            ],
          ),
        );
}
