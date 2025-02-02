import 'package:flutter/material.dart';
import 'package:parking_shared_logic/parking_shared_logic.dart';
import 'package:parking_shared_ui/parking_shared_ui.dart';

class ParkingProvider extends ChangeNotifier {
  final ParkingRepository parkingRepository;
  final ParkingSpaceRepository parkingSpaceRepository;
  final ParkingCostService parkingCostService;

  List<Parking> _completedParkingSessions = [];
  List<Parking> _activeParkingSessions = [];
  List<ParkingSpace> _parkingSpaces = [];

  bool _parkingSpacesLoaded = false;
  bool _activeSessionsLoaded = false;
  bool _completedSessionsLoaded = false;

  bool isAdmin = false;

  List<Parking> get activeParkingSessions => _activeParkingSessions;
  List<Parking> get completedParkingSessions => _completedParkingSessions;
  List<ParkingSpace> get parkingSpaces => _parkingSpaces;

  ParkingProvider(
      {required this.parkingRepository,
      required this.parkingSpaceRepository,
      required this.parkingCostService,
      this.isAdmin = false});

  Future<List<ParkingSpace>> loadParkingSpaces() async {
    if (_parkingSpaces.isNotEmpty && _parkingSpacesLoaded) {
      return _parkingSpaces;
    }

    try {
      final parkingSpaces = await ParkingSpaceRepository().getAll();

      _parkingSpaces.clear();
      _parkingSpaces.addAll(parkingSpaces);
      _parkingSpacesLoaded = true;

      notifyListeners();
    } catch (e) {
      _parkingSpaces = [];
      throw Exception('Failed to load parkingspaces');
    }
    return _parkingSpaces;
  }

  Future<void> deleteParkingSpace(ParkingSpace parkingSpace) async {
    try {
      await ParkingSpaceRepository().delete(parkingSpace.id);
      _parkingSpaces.remove(parkingSpace);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to delete parking space: $e');
    }
  }

  Future<List<Parking>> loadActiveParkingSessions(
      AuthProvider? authService) async {
    if (authService?.currentUser == null && !isAdmin && authService != null) {
      throw Exception('User is not authenticated');
    }
    if (_activeSessionsLoaded) return _activeParkingSessions;

    try {
      notifyListeners();
      final allParkings = await ParkingRepository().getAll();

      _activeParkingSessions.clear();
      if (isAdmin) {
        // get all active parking sessions
        _activeParkingSessions =
            allParkings.where((parking) => parking.stop == null).toList();
      } else {
        // get users active parking sessions
        _activeParkingSessions.addAll(
          allParkings
              .where((parking) =>
                  parking.stop == null &&
                  parking.vehicle.owner.id == authService?.currentUser?.id)
              .toList(),
        );
      }

      _activeSessionsLoaded = true;

      notifyListeners();
    } catch (e) {
      _activeParkingSessions = [];
      throw Exception('Could not load active parking sessions');
    }
    return _activeParkingSessions;
  }

  Future<List<Parking>> loadCompletedParkingSessions(
      AuthProvider? authService) async {
    if (authService?.currentUser == null && !isAdmin && authService != null) {
      throw Exception('User is not authenticated');
    }

    if (_completedSessionsLoaded) return _completedParkingSessions;

    try {
      final allParkings = await ParkingRepository().getAll();

      _completedParkingSessions.clear();

      if (isAdmin) {
        _completedParkingSessions.addAll(
            allParkings.where((parking) => parking.stop != null).toList());
      } else {
        _completedParkingSessions.addAll(
          allParkings
              .where((parking) =>
                  parking.stop != null &&
                  parking.vehicle.owner.id == authService?.currentUser!.id)
              .toList(),
        );
      }
      _completedSessionsLoaded = true;

      notifyListeners();
    } catch (e) {
      _completedParkingSessions = [];
      throw Exception('Could not load completed parking sessions');
    }
    return _completedParkingSessions;
  }

  Future<void> startParkingSession(Vehicle vehicle, ParkingSpace parkingSpace,
      AuthProvider authService) async {
    if (authService.currentUser == null) {
      throw Exception('User is not authenticated');
    }

    if (vehicle.owner.id != authService.currentUser?.id) {
      throw Exception('You are not authorized to park this vehicle');
    }

    try {
      final parking =
          Parking.withUUID(vehicle: vehicle, parkingSpace: parkingSpace);
      await ParkingRepository().add(parking);
      _activeParkingSessions.add(parking);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to start parking: $e');
    }
  }

  Future<void> stopParkingSession(
      String parkingId, AuthProvider authService) async {
    if (authService.currentUser == null) {
      throw Exception('User is not authenticated');
    }

    try {
      final parking = _activeParkingSessions.firstWhere(
        (p) => p.id == parkingId,
        orElse: () => throw Exception('Parking session not found'),
      );

      if (parking.vehicle.owner.id != authService.currentUser!.id) {
        throw Exception('You are not authorized to stop this parking');
      }

      parking.updateStop(DateTime.now());
      await ParkingRepository().update(parkingId, parking);

      _activeParkingSessions.remove(parking);
      _completedParkingSessions.add(parking);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to stop parking: $e');
    }
  }

  List<Map<String, dynamic>> get mostPopularParkingSpaces {
    final allParkingSessions = [
      ..._activeParkingSessions,
      ..._completedParkingSessions
    ];

    if (allParkingSessions.isEmpty) {
      return [];
    }

    return ParkingStatisticsService.getMostPopularParkingSpaces(
        allParkingSessions);
  }
}
