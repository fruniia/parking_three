import 'package:parking_shared/parking_shared.dart';
import 'package:parking_shared/src/utils/fetch_data.dart';

class PersonRepository implements InterfaceRepository<Person> {
  final baseUrl = "http://localhost:8080/persons";

  @override
  Future<Person?> add(Person person) async {
    return await fetchData<Person>(
      url: baseUrl,
      method: 'POST',
      body: person.toJson(),
      fromJson: (data) => Person.fromJson(data),
    );
  }

  @override
  Future<Person?> delete(String id) async {
    return await fetchData<Person>(
      url: '$baseUrl/$id',
      method: 'DELETE',
      fromJson: (data) => Person.fromJson(data),
    );
  }

  @override
  Future<List<Person>> getAll() async {
    return await fetchData<List<Person>>(
      url: baseUrl,
      method: 'GET',
      fromJson: (data) {
        return (data as List).map((person) => Person.fromJson(person)).toList();
      },
    );
  }

  @override
  Future<Person?> getById(String id) async {
    return await fetchData<Person>(
      url: '$baseUrl/$id',
      method: 'GET',
      fromJson: (data) => Person.fromJson(data),
    );
  }

  @override
  Future<Person?> update(String id, Person newItem) async {
    return await fetchData<Person>(
      url: '$baseUrl/$id',
      method: 'PUT',
      body: newItem.toJson(),
      fromJson: (data) => Person.fromJson(data),
    );
  }
}
