import 'package:flutter/material.dart';
import 'package:parking_admin/utils/validate.dart';
import 'package:parking_shared/parking_shared.dart';

class CreateParkingSpaceWidget extends StatefulWidget {
  const CreateParkingSpaceWidget({super.key});

  @override
  State<CreateParkingSpaceWidget> createState() =>
      _CreateParkingSpaceWidgetState();
}

class _CreateParkingSpaceWidgetState extends State<CreateParkingSpaceWidget> {
  late ParkingSpace parkingSpace;
  final _formkey = GlobalKey<FormState>();
  TextEditingController addressController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new parkingspace'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formkey,
          child: ListView(padding: const EdgeInsets.all(16.0), children: [
            TextFormField(
              controller: addressController,
              decoration: const InputDecoration(
                hintText: 'Address',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
              validator: validateAddress,
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: priceController,
              decoration: const InputDecoration(
                hintText: 'Price per hour',
                border: OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(),
              validator: validatePrice,
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(onPressed: _saveData, child: const Text('Save'))
          ]),
        ),
      ),
    );
  }

  void _saveData() async {
    if (_formkey.currentState?.validate() ?? false) {
      setState(() {
        parkingSpace = ParkingSpace.withUUID(
            address: addressController.text,
            pricePerHour: double.parse(priceController.text));
      });

      await ParkingSpaceRepository().add(parkingSpace);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          content: Text(
              'Parkingspace ${parkingSpace.address}, ${parkingSpace.pricePerHour} created'),
        ));
        Navigator.pop(context, true);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fix the errors in the form'),
            backgroundColor: Colors.red),
      );
    }
  }
}
