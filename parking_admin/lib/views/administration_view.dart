import 'package:flutter/material.dart';
import 'package:parking_admin/widgets/parking_space_widget.dart';
import 'package:parking_shared/parking_shared.dart';

class AdministrationView extends StatefulWidget {
  const AdministrationView({super.key});

  @override
  State<StatefulWidget> createState() => _AdministrationViewState();
}

class _AdministrationViewState extends State<AdministrationView> {
  Future<List<ParkingSpace>> getParkingSpaces =
      ParkingSpaceRepository().getAll();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Edit parkings'),
      ),
      body: FutureBuilder<List<ParkingSpace>>(
          future: getParkingSpaces,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ParkingSpaceWidget(
                    parkingSpace: snapshot.data![index],
                  );
                },
              );
            }
            return const CircularProgressIndicator();
          }),
    );
  }
}
