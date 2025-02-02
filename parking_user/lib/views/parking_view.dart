import 'package:flutter/material.dart';
import 'package:parking_shared_logic/parking_shared_logic.dart';
import 'package:parking_shared_ui/parking_shared_ui.dart';
import 'package:parking_user/utils/utils.dart';
import 'package:parking_user/widgets/index.dart';
import 'package:provider/provider.dart';

class ParkingView extends StatefulWidget {
  const ParkingView({super.key});

  @override
  State<StatefulWidget> createState() => _ParkingViewState();
}

class _ParkingViewState extends State<ParkingView> {
  @override
  void initState() {
    super.initState();

    _loadData();
  }

  void _loadData() {
    try {
      final parkingService = context.read<ParkingProvider>();
      final parkingSpaceService = context.read<ParkingSpaceProvider>();
      final vehicleService = context.read<VehicleProvider>();
      final authService = context.read<AuthProvider>();

      parkingSpaceService.loadParkingSpaces();
      parkingService.loadActiveParkingSessions(authService);
      parkingService.loadCompletedParkingSessions(authService);
      vehicleService.loadVehicles();
    } catch (e) {
      if (context.mounted) {
        showCustomSnackBar(context, 'Failed to load data: $e', type: 'error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final parkingService = context.watch<ParkingProvider>();
    final parkingSpaceService = context.watch<ParkingSpaceProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text('My Parkings'),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _sectionTitle('Available parking spaces:'),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final parkingSpace = parkingSpaceService.parkingSpaces[index];
                return ListTile(
                  tileColor: getBackgroundColor(index),
                  title: Text(parkingSpace.address),
                  subtitle:
                      Text('Price per hour: ${parkingSpace.pricePerHour}'),
                );
              },
              childCount: parkingSpaceService.parkingSpaces.length,
            ),
          ),
          const SliverToBoxAdapter(child: Divider()),
          SliverToBoxAdapter(
            child: _sectionTitle('Active parking sessions:'),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final parking = parkingService.activeParkingSessions[index];
                return ListTile(
                  title: Text(parking.parkingSpace.address),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(parking.vehicle.licensePlate),
                      Text('Start: ${formatDateAndTime(parking.start)}'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.stop),
                    onPressed: () async {
                      try {
                        await context
                            .read<ParkingProvider>()
                            .stopParkingSession(
                                parking.id, context.read<AuthProvider>());
                        if (context.mounted) {
                          showCustomSnackBar(context,
                              'Parking stopped at ${parking.parkingSpace.address}',
                              type: 'success');
                        }
                      } catch (e) {
                        if (context.mounted) {
                          showCustomSnackBar(
                              context, 'Failed to stop parking: $e',
                              type: 'error');
                        }
                      }
                    },
                  ),
                );
              },
              childCount: parkingService.activeParkingSessions.length,
            ),
          ),
          const SliverToBoxAdapter(
            child: Divider(),
          ),
          SliverToBoxAdapter(
            child: _sectionTitle('Completed parking sessions:'),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final parking = parkingService.completedParkingSessions[index];
                return ListTile(
                  tileColor: getBackgroundColor(index),
                  title: Text(parking.parkingSpace.address),
                  subtitle: Text(
                      'Start: ${formatDateAndTime(parking.start)}\nStop: ${formatDateAndTime(parking.stop)}'),
                );
              },
              childCount: parkingService.completedParkingSessions.length,
            ),
          )
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FloatingActionButton.extended(
          onPressed: navigateToCreateView,
          backgroundColor: Colors.lightBlue.shade200,
          icon: Icon(Icons.add),
          label: Text(
            'Add parking',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }

  Padding _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(title),
    );
  }

  void navigateToCreateView() async {
    final parkingService = context.read<ParkingProvider>();
    final authService = context.read<AuthProvider>();

    try {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ParkVehicleWidget()),
      );
      if (result == true) {
        if (mounted) {
          parkingService.loadActiveParkingSessions(authService);
        }
      }
    } catch (e) {
      if (mounted) {
        showCustomSnackBar(
            context, 'Failed to navigate or load active sessions: $e',
            type: 'error');
      }
    }
  }
}
