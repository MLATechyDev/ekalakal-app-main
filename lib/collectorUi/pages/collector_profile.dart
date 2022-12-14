import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekalakal/authentication/storage_services.dart';
import 'package:ekalakal/information/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../information/profile_upload.dart';

class CollectorProfile extends StatefulWidget {
  CollectorProfile({Key? key}) : super(key: key);

  @override
  State<CollectorProfile> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<CollectorProfile> {
  final double profileHeight = 150;
  final double coverHeight = 150;

  final user = FirebaseAuth.instance.currentUser!;
  FirebaseApi storage = FirebaseApi();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          buildTop(),
          buildContent(),
        ],
      ),
    );
  }

  Stack buildTop() {
    final top = coverHeight - profileHeight / 2;
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: profileHeight / 2),
          child: buildCoverImage(),
        ),
        Positioned(
          top: top,
          child: buildProfileImage(),
        ),
        Positioned(
          bottom: 2,
          right: 130,
          child: Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(100),
            ),
            child: CircleAvatar(
              backgroundColor: Colors.lightBlue[400],
              child: IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: ((context) {
                      return const ProfileUpload();
                    })));
                  },
                  icon: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                  )),
            ),
          ),
        ),
      ],
    );
  }

  // Stack buildTop() {
  //   final top = coverHeight - profileHeight / 2;
  //   return Stack(
  //     clipBehavior: Clip.none,
  //     alignment: Alignment.center,
  //     children: [
  //       Container(
  //         margin: EdgeInsets.only(bottom: profileHeight / 2),
  //         child: buildCoverImage(),
  //       ),
  //       Positioned(
  //         top: top,
  //         child: buildProfileImage(),
  //       ),
  //     ],
  //   );
  // }

  Widget buildCoverImage() => Container(
        color: Colors.grey,
        child: Image.asset(
          'assets/bg1.png',
          width: double.infinity,
          height: coverHeight,
          fit: BoxFit.cover,
        ),
      );

  Widget buildProfileImage() => Container(
        height: 150,
        width: 150,
        child: FutureBuilder(
            future: storage.downloadURL(user.uid.toString()),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                return Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100)),
                  child: CircleAvatar(
                    radius: profileHeight / 2,
                    backgroundColor: Colors.grey,
                    backgroundImage: !snapshot.hasData
                        ? const NetworkImage(
                            'https://www.salisburyut.com/wp-content/uploads/2020/09/avatar-1-scaled.jpeg')
                        : NetworkImage(snapshot.data!),
                  ),
                );
              }
              return Container();
            }),
      );

  Widget buildContent() => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 5,
            ),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('userpos')
                    .where('email', isEqualTo: user.email!)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    const Scaffold(
                      body: Center(
                        child: Text('Something went wrong.'),
                      ),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    const Scaffold(
                      body: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  if (snapshot.hasData) {
                    return Text(
                      snapshot.requireData.docs.first['name'],
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    );
                  }
                  return Container();
                }),

            // Text(
            //   user.email!,
            //   style: const TextStyle(
            //     fontWeight: FontWeight.bold,
            //     fontSize: 30,
            //   ),
            // ),
            const Divider(
              height: 30,
              thickness: 1,
              indent: 20,
              endIndent: 20,
              color: Colors.black,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Align(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return const UserProfile();
                        }));
                      },
                      icon: const Icon(Icons.person),
                      label: const Text('Profile Information'),
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(
                          fontSize: 18,
                          inherit: false,
                        ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.history),
                      label: const Text('History'),
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(
                          fontSize: 18,
                          inherit: false,
                        ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text('Logout'),
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(
                          fontSize: 18,
                          //  inherit: false,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}
