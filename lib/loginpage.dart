import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekalakal/authentication/emailverification.dart';
import 'package:ekalakal/authentication/resetpassword.dart';
import 'package:ekalakal/wrapper.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'registrationpage.dart';
import 'package:ekalakal/main.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:email_validator/email_validator.dart';
import 'residentUi/resident_main.dart';
import 'collectorUi/collector_main.dart';
import 'authentication/usersAuth.dart';
import 'authentication/userPosition.dart';

var _errorMsg;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final Stream<QuerySnapshot> userPos =
      FirebaseFirestore.instance.collection('userpos').snapshots();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(
            child: Text("Something went wrong!"),
          );
        } else if (snapshot.hasData) {
          return const EmailVerification();
        } else {
          return LoginPageUI();
        }
      },
    );
  }
}

class LoginPageUI extends StatefulWidget {
  LoginPageUI({Key? key}) : super(key: key);

  @override
  State<LoginPageUI> createState() => _LoginPageUIState();
}

class _LoginPageUIState extends State<LoginPageUI> {
  final formKey = GlobalKey<FormState>();
  bool _obscureTextPass = true;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 300,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50)),
                ),
                child: Column(
                  children: [
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Opacity(
                          opacity: 0.8,
                          child: Image.asset(
                            'assets/ekalakal_logo.png',
                            height: 150,
                            width: 150,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      "E KALAKAL",
                      style: GoogleFonts.mouseMemoirs(
                        textStyle:
                            const TextStyle(fontSize: 40, color: Colors.white),
                      ),
                    ),
                    const Text(
                      '"Turn Trash Into Cash"',
                      style: TextStyle(fontSize: 20, color: Colors.white70),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    right: 8, left: 8, bottom: 8, top: 30),
                child: Column(
                  children: [
                    //ErrorBox
                    // errorMsgBox(),
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
                        validator: (value) => value != null && value.length < 8
                            ? "Enter at least 8 characters"
                            : null,
                        controller: passwordController,
                        obscureText: _obscureTextPass,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscureTextPass = !_obscureTextPass;
                                });
                              },
                              icon: Icon(_obscureTextPass
                                  ? Icons.remove_red_eye
                                  : Icons.security)),
                          labelText: "Password",
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),

                    //SignButton
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: ElevatedButton(
                        onPressed: signIn,
                        style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50))),
                            minimumSize: const Size(double.infinity, 50)),
                        child: const Text(
                          "Sign In",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                    //ForgotPasswordButton
                    TextButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return const ResetPassword();
                          }));
                        },
                        child: const Text("Forgot Password?")),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account yet? "),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) {
                                return WrapperPage();
                              }));
                            },
                            child: const Text("Sign Up"))
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget errorMsgBox() {
  //   if (_errorMsg != null) {
  //     return Container(
  //       decoration: const BoxDecoration(
  //           color: Colors.amberAccent,
  //           borderRadius: BorderRadius.all(Radius.circular(30))),
  //       width: double.infinity,
  //       padding: const EdgeInsets.all(8.0),
  //       height: 50,
  //       child: SingleChildScrollView(
  //         scrollDirection: Axis.horizontal,
  //         child: Row(
  //           children: [
  //             const Icon(Icons.error_outline),
  //             Padding(
  //               padding: const EdgeInsets.only(left: 8.0),
  //               child: Expanded(child: AutoSizeText(_errorMsg)),
  //             ),
  //             IconButton(
  //                 onPressed: () {
  //                   setState(() {
  //                     _errorMsg = null;
  //                   });
  //                 },
  //                 icon: const Icon(Icons.close))
  //           ],
  //         ),
  //       ),
  //     );
  //   }
  //   return const SizedBox(
  //     height: 0,
  //   );
  // }

  Future signIn() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      Fluttertoast.showToast(
        msg: 'Login Succeed',
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
      // setState(() {
      //   _errorMsg = e.message.toString();
      // });
    }

    //Navigator.of(context) not working!!
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
