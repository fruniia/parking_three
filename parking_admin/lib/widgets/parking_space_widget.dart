import 'package:flutter/material.dart';
import 'package:parking_admin/widgets/delete_parking_space_widget.dart';
import 'package:parking_admin/widgets/edit_parking_space_widget.dart';
import 'package:parking_shared/parking_shared.dart';

class ParkingSpaceWidget extends StatefulWidget {
  const ParkingSpaceWidget(
      {super.key, required this.parkingSpace, required this.index, required this.onDelete});
  final ParkingSpace parkingSpace;
  final int index;
  final Function(ParkingSpace) onDelete;

  @override
  State<StatefulWidget> createState() => _ParkingSpaceWidgetState();
}

class _ParkingSpaceWidgetState extends State<ParkingSpaceWidget> {
  late ParkingSpace parkingSpace;
  late int index;

  @override
  void initState() {
    super.initState();
    parkingSpace = widget.parkingSpace;
    index = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
           CircleAvatar(
              child: Text('${index + 1}'),
            ),
            const SizedBox(width: 16,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  parkingSpace.address,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
                Text('Price per hour: SEK ${parkingSpace.pricePerHour.toString()}'),
              ],
            ),const Spacer(),
             SizedBox(
              width: 80,
              child: Row(mainAxisAlignment: MainAxisAlignment.end, mainAxisSize: MainAxisSize.min, children: [
                Tooltip(
                  message: 'Edit',
                  child: IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blueGrey),
                    onPressed: () async {
                      _editParkingSpace(context, parkingSpace);
                    },
                  ),
                ),
                Tooltip(
                  message: 'Delete',
                  child: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.blueGrey),
                    onPressed: () async {
                      _deleteParkingSpace(context, parkingSpace);
                    },
                  ),
                ),
              ]),
            ),
        ],
      ),
    );
  }

  void _editParkingSpace(
      BuildContext context, ParkingSpace parkingSpace) async {
    final updatedParkingSpace = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            EditParkingSpaceWidget(parkingSpace: parkingSpace),
      ),
    );
    if (updatedParkingSpace != null) {
      setState(() {
        this.parkingSpace = updatedParkingSpace;
      });
    }
  }

  void _deleteParkingSpace(
      BuildContext context, ParkingSpace parkingSpace) async {
    final deleteParkingSpace = await showDialog<ParkingSpace>(
        context: context,
        builder: (context) =>
            DeleteParkingSpaceWidget(parkingSpace: parkingSpace));
    if (deleteParkingSpace != null) {
      setState(() {
        widget.onDelete(parkingSpace);
      });
    }
  }
}
