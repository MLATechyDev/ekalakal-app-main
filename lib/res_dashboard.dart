import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ResDashboard extends StatefulWidget {
  ResDashboard({Key? key}) : super(key: key);

  @override
  State<ResDashboard> createState() => _ResDashboardState();
}

class _ResDashboardState extends State<ResDashboard> {
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text(
            "DASHBOARD",
            style: TextStyle(fontSize: 30),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Column(
            children: [
              Container(
                color: Colors.grey.shade300,
                height: 200,
                width: double.infinity,
                child: Center(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(),
                      onPressed: () {},
                      child: const Text("BOOK APPOINMENT")),
                ),
              ),
              const Text(
                "Sign in as",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                user.email!,
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(
                height: 8,
              ),
              ElevatedButton.icon(
                onPressed: () => FirebaseAuth.instance.signOut(),
                label: const Text("Sign out"),
                icon: const Icon(Icons.arrow_back),
              )
            ],
          ),
        ));
  }
}
