import 'package:flutter/material.dart';
import 'package:parking_shared/parking_shared.dart';

class ParkingSpaceWidget extends StatelessWidget {
  const ParkingSpaceWidget({super.key, required this.parkingSpace});

  final ParkingSpace parkingSpace;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(parkingSpace.address),
    );
  }
}