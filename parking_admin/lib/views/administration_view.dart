import 'package:flutter/material.dart';
import 'package:parking_admin/widgets/parking_space_widget.dart';
import 'package:parking_shared/parking_shared.dart';

class AdministrationView extends StatefulWidget {
  const AdministrationView({super.key});

  @override
  State<StatefulWidget> createState() => _AdministrationViewState();
}

class _AdministrationViewState extends State<AdministrationView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Edit parkings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'List of parkingspaces',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: FutureBuilder<List<ParkingSpace>>(
                  future: ParkingSpaceRepository().getAll(),
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
}
