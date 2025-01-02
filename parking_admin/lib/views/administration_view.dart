import 'package:flutter/material.dart';
import 'package:parking_admin/widgets/create_parking_space_widget.dart';
import 'package:parking_admin/widgets/parking_space_widget.dart';
import 'package:parking_shared/parking_shared.dart';

class AdministrationView extends StatefulWidget {
  const AdministrationView({super.key});

  @override
  State<StatefulWidget> createState() => _AdministrationViewState();
}

class _AdministrationViewState extends State<AdministrationView> {
  // Future which gets parkingSpaces, initialized as an empty list
  late Future<List<ParkingSpace>> getParkingSpaces = Future.value([]);
  late List<ParkingSpace> parkingSpaces;

  @override
  void initState() {
    super.initState();
    _fetchParkingSpaces();
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
              child: FutureBuilder<List<ParkingSpace>>(
                  future: getParkingSpaces,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error,
                                color: Colors.red, size: 50),
                            const SizedBox(height: 10),
                            Text(
                              'An error occurred: ${snapshot.error}',
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.red),
                            )
                          ],
                        ),
                      );
                    } else if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return ParkingSpaceWidget(
                            parkingSpace: snapshot.data![index],
                            index: index,
                            onDelete: _handleDeleteParkingSpace,
                          );
                        },
                      );
                    }
                    return const CircularProgressIndicator();
                  }),
            ),
            FloatingActionButton.extended(
              onPressed: navigateToCreateView,
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

  void navigateToCreateView() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateParkingSpaceWidget()),
    );
    if (result == true) {
      setState(() {
        getParkingSpaces = ParkingSpaceRepository().getAll();
      });
    }
  }

  void _handleDeleteParkingSpace(ParkingSpace parkingSpace) {
    setState(() {
      parkingSpaces.remove(parkingSpace);
      getParkingSpaces = Future.value(parkingSpaces);
    });
  }

  void _fetchParkingSpaces() {
    ParkingSpaceRepository().getAll().then((spaces) {
      setState(() {
        parkingSpaces = spaces;
        getParkingSpaces = Future.value(parkingSpaces);
      });
      return spaces;
    }).catchError((error) {
      setState(() {
        getParkingSpaces = Future.value(<ParkingSpace>[]);
      });
      return Future.value(<ParkingSpace>[]);
    });
  }
}
