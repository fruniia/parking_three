import 'package:flutter/material.dart';
import 'package:parking_admin/utils/index.dart';
import 'package:parking_shared_logic/parking_shared_logic.dart';
import 'package:parking_shared_ui/parking_shared_ui.dart';

class EditParkingSpaceWidget extends StatefulWidget {
  final ParkingSpace parkingSpace;

  const EditParkingSpaceWidget({super.key, required this.parkingSpace});
  @override
  State<StatefulWidget> createState() => _EditParkingSpaceWidgetState();
}

class _EditParkingSpaceWidgetState extends State<EditParkingSpaceWidget> {
  final _formkey = GlobalKey<FormState>();
  late TextEditingController addressController;
  late TextEditingController priceController;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    addressController =
        TextEditingController(text: widget.parkingSpace.address);
    priceController = TextEditingController(
        text: widget.parkingSpace.pricePerHour.toString());
  }

  void _checkForChanges() {
    setState(() {
      _hasChanges = addressController.text != widget.parkingSpace.address ||
          priceController.text != widget.parkingSpace.pricePerHour.toString();
    });
  }

  void _saveChanges() async {
    if (_formkey.currentState?.validate() ?? false) {
      if (!_hasChanges) {
        showCustomSnackBar(context, 'No changes made');
        return;
      }

      setState(() {
        widget.parkingSpace.address = addressController.text;
        widget.parkingSpace.pricePerHour =
            double.tryParse(priceController.text) ??
                widget.parkingSpace.pricePerHour;
      });

      await ParkingSpaceRepository()
          .update(widget.parkingSpace.id, widget.parkingSpace);

      if (mounted) {
        showCustomSnackBar(context,
            'Parkingspace ${widget.parkingSpace.address}, ${widget.parkingSpace.pricePerHour} updated',
            type: 'success');
        Navigator.pop(context, widget.parkingSpace);
      }
    } else {
      showCustomSnackBar(context, 'Please fix the errors in the form',
          type: 'error');
    }
  }

  @override
  Widget build(BuildContext context) {
    addressController.addListener(_checkForChanges);
    priceController.addListener(_checkForChanges);

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
                validator: validateAddress,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Price per hour',
                  border: OutlineInputBorder(),
                ),
                validator: validatePrice,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveChanges,
                  child: const Text('Save changes'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
