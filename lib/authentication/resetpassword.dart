import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();
  final emailTEC = TextEditingController();
  @override
  void dispose() {
    emailTEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            'Reset Password',
            style: TextStyle(color: Colors.white),
          )),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(
                child: Text(
                  'Receive an email to\nreset your password.',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: emailTEC,
                textInputAction: TextInputAction.done,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (email) =>
                    email != null && !EmailValidator.validate(email)
                        ? 'Enter a valid email'
                        : null,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(200, 40)),
                  onPressed: resetpassword,
                  icon: const Icon(
                    Icons.mail,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Reset Password',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Future resetpassword() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailTEC.text.trim());
      Fluttertoast.showToast(
        msg: 'Reset password verification email was sent.',
        fontSize: 15,
        backgroundColor: Colors.amber,
        textColor: Colors.black,
      );
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      print(e);
      Fluttertoast.showToast(
        msg: e.message.toString(),
        fontSize: 15,
        backgroundColor: Colors.amber,
        textColor: Colors.black,
      );
    }
  }
}
