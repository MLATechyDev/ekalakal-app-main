import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:ekalakal/collectorUi/collectorMaps/collectorMaps.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './pages/collector_dashboard.dart';
import './pages/collector_list.dart';
import './pages/collector_profile.dart';

class CollectorMain extends StatefulWidget {
  const CollectorMain({super.key});

  @override
  State<CollectorMain> createState() => _CollectorMainState();
}

class _CollectorMainState extends State<CollectorMain> {
  int index = 0;

  final screen = [CollectorDashboard(), CollectorList(), CollectorProfile()];

  final items = <Widget>[
    const Icon(
      Icons.home,
      size: 30,
    ),
    const Icon(
      Icons.list_alt_rounded,
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
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          index == 0
              ? 'DASHBOARD'
              : index == 1
                  ? 'MAPS'
                  : 'PROFILE',
          style: GoogleFonts.alfaSlabOne(
            textStyle: const TextStyle(fontSize: 30, color: Colors.white),
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
            color: Colors.lightBlue,
            items: items,
            onTap: (index) {
              setState(() {
                this.index = index;
              });
            }),
      ),
    );
  }
}
