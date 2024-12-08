import 'package:flutter/material.dart';
import 'package:parking_shared/parking_shared.dart';

class ParkingView extends StatefulWidget {
  const ParkingView({super.key});

  @override
  State<StatefulWidget> createState() => _ParkingViewState();
}

class _ParkingViewState extends State<ParkingView> {
  // Future which gets parkingSpaces, initialized as an empty list
  late Future<List<ParkingSpace>> getParkingSpaces = Future.value([]);
  late Future<List<Parking>> getParkings = Future.value([]);
  late List<ParkingSpace> parkingSpaces;
  late List<Parking> parkings;

  @override
  void initState() {
    super.initState();
    _fetchParkingSpaces();
    _fetchParkings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Active parkings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'List of active parkings',
              style: TextStyle(
                fontSize: 26,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: FutureBuilder<List<Parking>>(
                  future: getParkings,
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
                          var parking = snapshot.data![index];

                          return ListTile(
                            title: Text(
                                'Parking at ${parking.parkingSpace.address.toString()}'),
                            subtitle: Text(
                                'Licenseplate: ${parking.vehicle.licensePlate}\nStart time: ${parking.start}'),
                          );
                        },
                      );
                    }
                    return const CircularProgressIndicator();
                  }),
            ),
          ],
        ),
      ),
    );
  }

  void _fetchParkingSpaces() {
    ParkingSpaceRepository().getAll().then((spaces) {
      setState(() {
        parkingSpaces = spaces;
        getParkingSpaces = Future.value(parkingSpaces);
      });
    }).catchError((error) {
      setState(() {
        getParkingSpaces = Future.value(<ParkingSpace>[]);
      });
    });
  }

  void _fetchParkings() {
    ParkingRepository().getAll().then((items) {
      List<Parking> activeParkings =
          items.where((parking) => parking.stop == null).toList();
      setState(() {
        parkings = activeParkings;
        getParkings = Future.value(parkings);
      });
    }).catchError((error) {
      setState(() {
        getParkings = Future.value(<Parking>[]);
      });
    });
  }
}
