import 'package:ekalakal/loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChangePasswordForm extends StatefulWidget {
  const ChangePasswordForm({super.key});

  @override
  State<ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  final _formKey = GlobalKey<FormState>();

  final _newPasswordTEC = TextEditingController();
  var newPassword = '';
  bool obscureText = true;

  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text('Change Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                obscureText: obscureText,
                controller: _newPasswordTEC,
                decoration: InputDecoration(
                  hintText: 'New Password',
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obscureText = !obscureText;
                        });
                      },
                      icon: obscureText
                          ? Icon(Icons.remove_red_eye)
                          : Icon(Icons.security)),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    newPassword = _newPasswordTEC.text;
                  });
                  changePassword();
                },
                child: Text(
                  'Update Password',
                  style: TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(200, 50),
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  changePassword() async {
    try {
      await user.updatePassword(newPassword);
      FirebaseAuth.instance.signOut();
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return LoginPage();
      }));

      Fluttertoast.showToast(
          msg: 'Your Password has been change, Login Again',
          fontSize: 15,
          backgroundColor: Colors.amberAccent,
          textColor: Colors.black);
    } catch (e) {
      print(e);
    }
  }
}
