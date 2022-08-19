import './page/profile_page.dart';
import './page/home_page.dart';
import './page/book_page.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:google_fonts/google_fonts.dart';

class ResidentMainApp extends StatefulWidget {
  ResidentMainApp({Key? key}) : super(key: key);

  @override
  State<ResidentMainApp> createState() => _ResidentMainAppState();
}

class _ResidentMainAppState extends State<ResidentMainApp> {
  //final navigationKey = GlobalKey<CurvedNavigationBarState>();

  final screen = [
    HomePage(),
    BookPage(),
    ProfilePage(),
  ];

  int index = 0;

  final items = <Widget>[
    const Icon(
      Icons.home,
      size: 30,
    ),
    const Icon(
      Icons.add,
      size: 30,
    ),
    const Icon(
      Icons.person,
      size: 30,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'E-KALAKAL',
          style: GoogleFonts.alfaSlabOne(
            textStyle: const TextStyle(fontSize: 30, color: Colors.black),
          ),
        ),
      ),
      body: screen[index],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        child: CurvedNavigationBar(
          //key: navigationKey,
          height: 60,
          backgroundColor: Colors.transparent,
          animationDuration: const Duration(milliseconds: 300),
          color: Colors.blue,
          items: items,
          onTap: (index) => setState(() => this.index = index),
        ),
      ),
    );
  }
}
