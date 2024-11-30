import 'package:flutter/material.dart';
import 'package:parking_shared/parking_shared.dart';

class ParkingSpaceEditWidget extends StatefulWidget {
  final ParkingSpace parkingSpace;

  const ParkingSpaceEditWidget({super.key, required this.parkingSpace});
  @override
  State<StatefulWidget> createState() => _ParkingSpaceEditWidgetState();
}

class _ParkingSpaceEditWidgetState extends State<ParkingSpaceEditWidget> {
  final _formkey = GlobalKey<FormState>();
  late TextEditingController addressController;
  late TextEditingController priceController;

  @override
  void initState() {
    super.initState();
    addressController =
        TextEditingController(text: widget.parkingSpace.address);
    priceController = TextEditingController(
        text: widget.parkingSpace.pricePerHour.toString());
  }

  String? _validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a price';
    }
    final price = double.tryParse(value);
    if (price == null || price <= 0) {
      return 'Please enter a valid price';
    }
    return null;
  }

  String? _validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an address';
    }
    return null;
  }

  void _saveChanges() async {
    if (_formkey.currentState?.validate() ?? false) {
      setState(() {
        widget.parkingSpace.address = addressController.text;
        widget.parkingSpace.pricePerHour =
            double.tryParse(priceController.text) ??
                widget.parkingSpace.pricePerHour;
      });

      await ParkingSpaceRepository()
          .update(widget.parkingSpace.id, widget.parkingSpace);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          content: Text(
              'Parkingspace ${widget.parkingSpace.address}, ${widget.parkingSpace.pricePerHour} updated'),
        ));
      }
      _navigateBack();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fix the errors in the form'),
            backgroundColor: Colors.red),
      );
    }
  }

  void _navigateBack() {
    if (mounted) {
      Navigator.pop(context, widget.parkingSpace);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
                validator: _validateAddress,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Price per hour',
                  border: OutlineInputBorder(),
                ),
                validator: _validatePrice,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveChanges,
                child: const Text('Save changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
