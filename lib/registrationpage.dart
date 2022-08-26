import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekalakal/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:email_validator/email_validator.dart';
import 'authentication/usersAuth.dart';
import 'package:auto_size_text/auto_size_text.dart';

var _errorMsg;

class RegistrationPageUI extends StatefulWidget {
  final String loginAs;
  RegistrationPageUI({Key? key, required this.loginAs}) : super(key: key);

  @override
  State<RegistrationPageUI> createState() => _RegistrationPageUIState();
}

class _RegistrationPageUIState extends State<RegistrationPageUI> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _obscureText = true;
  final _formkey = GlobalKey<FormState>();

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
        key: _formkey,
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
                        child: Image.asset(
                          'assets/ekalakal_logo.png',
                          height: 150,
                          width: 150,
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
              errorMsgBox(),
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

                      //SignButton
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            final user = UserLoginPosition(
                                email: emailController.text,
                                position: widget.loginAs);

                            signUp();
                            createUserPosition(user);
                          },
                          style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50))),
                              minimumSize: const Size(double.infinity, 50)),
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(fontSize: 20),
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

  Widget errorMsgBox() {
    if (_errorMsg != null) {
      return Container(
        decoration: const BoxDecoration(
            color: Colors.amberAccent,
            borderRadius: BorderRadius.all(Radius.circular(30))),
        width: double.infinity,
        padding: const EdgeInsets.all(8.0),
        height: 50,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              const Icon(Icons.error_outline),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Expanded(child: AutoSizeText(_errorMsg)),
              ),
              IconButton(
                  onPressed: () {
                    setState(() {
                      _errorMsg = null;
                    });
                  },
                  icon: const Icon(Icons.close))
            ],
          ),
        ),
      );
    }
    return const SizedBox(
      height: 0,
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
    } on FirebaseAuthException catch (e) {
      print(e);

      setState(() {
        _errorMsg = e.message.toString();
      });
    }

    //Navigator.of(context) not working!!
    navigatorKey.currentState!.pop();
  }

  Future createUserPosition(UserLoginPosition user) async {
    final docUser = FirebaseFirestore.instance.collection('userpos').doc();

    user.id = docUser.id;
    final json = user.toJson();
    await docUser.set(json);
  }
}
