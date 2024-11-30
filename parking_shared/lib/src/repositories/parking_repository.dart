import 'package:parking_shared/parking_shared.dart';
import 'package:parking_shared/src/utils/fetch_data.dart';

class ParkingRepository implements InterfaceRepository<Parking> {
  final baseUrl = "http://localhost:8080/parkings";

  @override
  Future<Parking?> add(Parking parking) async {
    return await fetchData<Parking>(
      url: baseUrl,
      method: 'POST',
      body: parking.toJson(),
      fromJson: (data) => Parking.fromJson(data),
    );
  }

  @override
  Future<Parking?> delete(String id) async {
    return await fetchData<Parking>(
      url: '$baseUrl/$id',
      method: 'DELETE',
      fromJson: (data) => Parking.fromJson(data),
    );
  }

  @override
  Future<List<Parking>> getAll() async {
    return await fetchData<List<Parking>>(
      url: baseUrl,
      method: 'GET',
      fromJson: (data) {
        return (data as List)
            .map((parking) => Parking.fromJson(parking))
            .toList();
      },
    );
  }

  @override
  Future<Parking?> getById(String id) async {
    return await fetchData<Parking>(
      url: '$baseUrl/$id',
      method: 'GET',
      fromJson: (data) => Parking.fromJson(data),
    );
  }

  @override
  Future<Parking?> update(String id, Parking newItem) async {
    return await fetchData<Parking>(
      url: '$baseUrl/$id',
      method: 'PUT',
      body: newItem.toJson(),
      fromJson: (data) => Parking.fromJson(data),
    );
  }
}