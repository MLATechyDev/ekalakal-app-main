import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Container(
              color: Colors.white70,
              height: 180,
              child: Row(
                children: [
                  Icon(Icons.person_rounded, size: 100),
                  SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Sign in as",
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        user.email!,
                        style: TextStyle(fontSize: 20),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => FirebaseAuth.instance.signOut(),
                        label: const Text("Sign out"),
                        icon: const Icon(Icons.logout),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // const Text(
          //   "Sign in as",
          //   style: TextStyle(fontSize: 16),
          // ),
          // const SizedBox(
          //   height: 8,
          // ),
          // Text(
          //   user.email!,
          //   style: TextStyle(fontSize: 20),
          // ),
          // const SizedBox(
          //   height: 8,
          // ),
          // ElevatedButton.icon(
          //   onPressed: () => FirebaseAuth.instance.signOut(),
          //   label: const Text("Sign out"),
          //   icon: const Icon(Icons.arrow_back),
          // )
        ],
      ),
    );
  }
}
