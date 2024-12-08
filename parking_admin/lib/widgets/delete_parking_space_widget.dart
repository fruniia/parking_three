import 'package:flutter/material.dart';
import 'package:parking_shared/parking_shared.dart';

class DeleteParkingSpaceWidget extends StatefulWidget {
  final ParkingSpace parkingSpace;

  const DeleteParkingSpaceWidget({super.key, required this.parkingSpace});
  @override
  State<StatefulWidget> createState() => _DeleteParkingSpaceWidgetState();
}

class _DeleteParkingSpaceWidgetState extends State<DeleteParkingSpaceWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final parkingSpace = widget.parkingSpace;
    return AlertDialog(
      title: Text(
          'Are you sure you want to delete this parkingspace \n${parkingSpace.address}'),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context, null);
            },
            child: const Text('Cancel')),
        TextButton(
          onPressed: () async {
            try {
              await ParkingSpaceRepository().delete(parkingSpace.id);

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      backgroundColor: Colors.green,
                      content:
                          Text('${parkingSpace.address} deleted successfully')),
                );
                Navigator.pop(context, parkingSpace);
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to delete parkingspace: $e')),
                );
              }
            }
          },
          child: const Text('Confirm'),
        )
      ],
    );
  }
}
