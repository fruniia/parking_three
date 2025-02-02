import 'package:flutter/material.dart';
import 'package:parking_admin/widgets/index.dart';
import 'package:parking_shared_logic/parking_shared_logic.dart';
import 'package:parking_shared_ui/parking_shared_ui.dart';
import 'package:provider/provider.dart';

class AdministrationView extends StatefulWidget {
  const AdministrationView({super.key});

  @override
  AdministrationViewState createState() => AdministrationViewState();
}

class AdministrationViewState extends State<AdministrationView> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    try {
      final parkingProvider = context.read<ParkingProvider>();
      await parkingProvider.loadParkingSpaces();
    } catch (e) {
      if (mounted) {
        showCustomSnackBar(context, 'Failed to load data: $e', type: 'error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Edit parkingspaces'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'List of parkingspaces',
              style: TextStyle(
                fontSize: 26,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: Consumer<ParkingProvider>(
                  builder: (context, parkingProvider, child) {
                if (parkingProvider.parkingSpaces.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return ListView.builder(
                    itemCount: parkingProvider.parkingSpaces.length,
                    itemBuilder: (context, index) {
                      return ParkingSpaceWidget(
                          parkingSpace: parkingProvider.parkingSpaces[index],
                          index: index,
                          onDelete: (ParkingSpace parkingSpace) {
                            parkingProvider.deleteParkingSpace(
                                parkingProvider.parkingSpaces[index]);
                          });
                    },
                  );
                }
              }),
            ),
            FloatingActionButton.extended(
              onPressed: () {
                navigateToCreateView(context);
              },
              label: const Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text('Add new parkingspace'),
                  Icon(Icons.add),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void navigateToCreateView(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateParkingSpaceWidget()),
    );
    if (result == true) {
      if (context.mounted) {
        final parkingProvider =
            Provider.of<ParkingProvider>(context, listen: false);
        await parkingProvider.loadParkingSpaces();
      }
    }
  }
}