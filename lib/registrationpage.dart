import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekalakal/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:email_validator/email_validator.dart';
import 'authentication/usersAuth.dart';

class RegistrationPageUI extends StatefulWidget {
  final String loginAs;
  RegistrationPageUI({Key? key, required this.loginAs}) : super(key: key);

  @override
  State<RegistrationPageUI> createState() => _RegistrationPageUIState();
}

class _RegistrationPageUIState extends State<RegistrationPageUI> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final verifypasswordController = TextEditingController();
  Color verifypassword = Colors.grey;
  bool _obscureText = true;
  final _formkey = GlobalKey<FormState>();
  final profileID = FirebaseAuth.instance.currentUser;
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        foregroundColor: Colors.white,
        title: Text(
          'CREATE ACCOUNT',
          style: GoogleFonts.passionOne(
            textStyle: const TextStyle(fontSize: 35, color: Colors.white),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child:
              // Container(
              //   height: 300,
              //   width: double.infinity,
              //   decoration: const BoxDecoration(
              //     color: Colors.blueGrey,
              //     borderRadius: BorderRadius.only(
              //         bottomLeft: Radius.circular(50),
              //         bottomRight: Radius.circular(50)),
              //   ),
              //   child: Column(
              //     children: [
              //       SafeArea(
              //         child: Padding(
              //           padding: const EdgeInsets.only(top: 8),
              //           child: Opacity(
              //             opacity: 0.8,
              //             child: Image.asset(
              //               'assets/ekalakal_logo.png',
              //               height: 150,
              //               width: 150,
              //             ),
              //           ),
              //         ),
              //       ),
              //       Text(
              //         "E KALAKAL",
              //         style: GoogleFonts.mouseMemoirs(
              //           textStyle:
              //               const TextStyle(fontSize: 40, color: Colors.white),
              //         ),
              //       ),
              //       const Text(
              //         '"Turn Trash Into Cash"',
              //         style: TextStyle(fontSize: 20, color: Colors.white70),
              //       ),
              //     ],
              //   ),
              // ),
              // errorMsgBox(),
              Column(
            children: [
              Container(
                height: 200,
                width: 200,
                child: Image.asset(
                  'assets/create-account.png',
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    right: 8, left: 8, bottom: 8, top: 50),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      //EmailTextField
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (email) =>
                            email != null && !EmailValidator.validate(email)
                                ? "Enter a valid email"
                                : null,
                        controller: emailController,
                        decoration: const InputDecoration(
                          suffixIcon: Icon(Icons.email),
                          labelText: "Email",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      // space

                      //PasswordTextField
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) =>
                              value != null && value.length < 8
                                  ? "Enter at least 8 characters"
                                  : null,
                          controller: passwordController,
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                                icon: Icon(_obscureText
                                    ? Icons.remove_red_eye
                                    : Icons.security)),
                            labelText: "Password",
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) => value != passwordController.text
                              ? "Password not match"
                              : null,
                          controller: verifypasswordController,
                          obscureText: true,
                          onChanged: (value) {
                            setState(() {
                              if (value == passwordController.text) {
                                verifypassword = Colors.green;
                              }
                            });
                          },
                          decoration: InputDecoration(
                            suffixIcon: Icon(
                              Icons.check,
                              color: verifypassword,
                            ),
                            labelText: "Confirm Password",
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),

                      //SignButton
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: ElevatedButton(
                          onPressed: () {
                            signUp();
                          },
                          style: ElevatedButton.styleFrom(
                              onPrimary: Colors.white,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50))),
                              minimumSize: const Size(double.infinity, 50)),
                          child: Text(
                            "Sign Up",
                            style: GoogleFonts.libreBaskerville(
                              textStyle: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an account? "),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) {
                                  return const LoginPage();
                                }));
                              },
                              child: const Text("Sign In"))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future signUp() async {
    final isValid = _formkey.currentState!.validate();
    if (!isValid) return;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      final user = UserLoginPosition(
        email: emailController.text,
        position: widget.loginAs,
        name: 'set now',
        firstname: 'set now',
        middlename: 'set now',
        lastname: 'set now',
        address: 'set now',
        contactnumber: 'set now',
      );
      createUserPosition(user);
      Fluttertoast.showToast(
        msg: 'Account Created',
        fontSize: 15,
        backgroundColor: Colors.amber,
        textColor: Colors.black,
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      Fluttertoast.showToast(
        msg: e.message.toString(),
        fontSize: 15,
        backgroundColor: Colors.amber,
        textColor: Colors.black,
      );
    }

    //Navigator.of(context) not working!!
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  Future createUserPosition(UserLoginPosition user) async {
    final docUser = FirebaseFirestore.instance.collection('userpos').doc();
    user.id = docUser.id;
    user.isVerify = 'new';
    user.adminVerify = 'new';
    final json = user.toJson();
    await docUser.set(json);
  }
}
