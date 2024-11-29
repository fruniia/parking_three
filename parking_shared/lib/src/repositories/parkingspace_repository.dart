import 'package:parking_shared/parking_shared.dart';
import 'package:parking_shared/src/utils/fetch_data.dart';

class ParkingSpaceRepository implements InterfaceRepository<ParkingSpace> {
  final baseUrl = "http://localhost:8080/parkingSpaces";

  @override
  Future<ParkingSpace?> add(ParkingSpace parkingSpace) async {
    return await fetchData<ParkingSpace>(
      url: baseUrl,
      method: 'POST',
      body: parkingSpace.toJson(),
      fromJson: (data) => ParkingSpace.fromJson(data),
    );
  }

  @override
  Future<ParkingSpace?> delete(String id) async {
    return await fetchData<ParkingSpace>(
      url: '$baseUrl/$id',
      method: 'DELETE',
      fromJson: (data) => ParkingSpace.fromJson(data),
    );
  }

  @override
  Future<List<ParkingSpace>> getAll() async {
    return await fetchData<List<ParkingSpace>>(
      url: baseUrl,
      method: 'GET',
      fromJson: (data) {
        return (data as List)
            .map((parkingSpace) => ParkingSpace.fromJson(parkingSpace))
            .toList();
      },
    );
  }

  @override
  Future<ParkingSpace?> getById(String id) async {
    return await fetchData<ParkingSpace>(
      url: '$baseUrl/$id',
      method: 'GET',
      fromJson: (data) => ParkingSpace.fromJson(data),
    );
  }

  @override
  Future<ParkingSpace?> update(String id, ParkingSpace newItem) async {
    return await fetchData<ParkingSpace>(
      url: '$baseUrl/$id',
      method: 'PUT',
      body: newItem.toJson(),
      fromJson: (data) => ParkingSpace.fromJson(data),
    );
  }
}
