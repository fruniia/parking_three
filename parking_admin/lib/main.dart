import 'package:flutter/material.dart';
import 'package:parking_admin/views/navigation_view.dart';

void main() {
  runApp(const ParkingAdmin());
}

class ParkingAdmin extends StatelessWidget {
  const ParkingAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parking app',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
        useMaterial3: true,
      ),
      home: const NavigationView(),
    );
  }
}