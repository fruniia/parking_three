import 'package:flutter/material.dart';
//import 'package:parking_admin/widgets/parking_space_edit_widget.dart';
import 'package:parking_shared/parking_shared.dart';

class ParkingSpaceWidget extends StatefulWidget {
  const ParkingSpaceWidget(
      {super.key, required this.parkingSpace, required this.index});
  final ParkingSpace parkingSpace;
  final int index;

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
    return ListTile(
      leading: CircleAvatar(
        child: Text('${index + 1}'),
      ),
      title: Text(
        parkingSpace.address,
        style: const TextStyle(fontSize: 16, color: Colors.black),
      ),
      subtitle:
          Text('Price per hour: SEK ${parkingSpace.pricePerHour.toString()}'),
      trailing: const SizedBox(
        width: 80,
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Icon(Icons.edit, color: Colors.blueGrey),
          Icon(Icons.delete, color: Colors.blueGrey),
        ]),
      ),
    );
  }
}
  // @override
  // Widget build(BuildContext context) {
  //   return InkWell(
  //     onTap: () {
  //       showDialog(
  //         context: context,
  //         barrierColor: Colors.greenAccent,
  //         builder: (context) {
  //           return AlertDialog(
  //             contentPadding: const EdgeInsets.all(20.0),
  //             content: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 Text(
  //                   parkingSpace.address,
  //                   style: const TextStyle(fontSize: 16, color: Colors.black),
  //                 ),
  //                 const SizedBox(height: 10),
  //                 const Text(
  //                   'Choose option',
  //                   style: TextStyle(
  //                     fontSize: 18,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //                 const SizedBox(height: 10),
  //                 Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: parkingSpaceListTile(context),
  //                 ),
  //               ],
  //             ),
  //           );
  //         },
  //       );
  //     },
  //     child: ListTile(
  //       title: Text(parkingSpace.address),
  //       subtitle: Text('SEK ${parkingSpace.pricePerHour}/hour'),
  //     ),
  //   );
  // }

//   List<Widget> parkingSpaceListTile(BuildContext context) {
//     return <Widget>[
//       _editParkingSpace(context),
//       ListTile(
//         title: const Text('Delete'),
//         onTap: () {
//           _showDeleteConfirmationDialog(context, parkingSpace);
//         },
//       ),
//     ];
//   }

//   ListTile _editParkingSpace(BuildContext context) {
//     return ListTile(
//       title: const Text('Edit'),
//       onTap: () async {
//         final updatedParkingSpace = await Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) =>
//                 ParkingSpaceEditWidget(parkingSpace: parkingSpace),
//           ),
//         );

//         if (context.mounted) {
//           Navigator.pop(context);
//         }

//         if (updatedParkingSpace != null) {
//           setState(() {
//             parkingSpace = updatedParkingSpace;
//           });
//         }
//       },
//     );
//   }
// }

// void _showDeleteConfirmationDialog(
//     BuildContext context, ParkingSpace parkingSpace) {
//   showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title:
//               const Text('Are you sure you want to delete this parkingspace'),
//           actions: [
//             TextButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 child: const Text('Cancel')),
//             TextButton(
//               onPressed: () async {
//                 try {
//                   await _deleteParkingSpace(context, parkingSpace);
//                   if (context.mounted) {
//                     Navigator.pop(context, parkingSpace);
//                   }
//                 } catch (e) {}
//               },
//               child: const Text('Delete'),
//             )
//           ],
//         );
//       });
// }

// Future<void> _deleteParkingSpace(
//     BuildContext context, ParkingSpace parkingSpace) async {
//   try {
//     await ParkingSpaceRepository().delete(parkingSpace.id);

//     if (context.mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Parkingspace deleted successfully')),
//       );
//     }
//   } catch (e) {
//     if (context.mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to delete parkingspace: $e')),
//       );
//     }
//   }
// }
