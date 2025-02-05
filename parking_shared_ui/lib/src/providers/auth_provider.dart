import 'package:flutter/material.dart';
import 'package:parking_shared_logic/parking_shared_logic.dart';

class AuthProvider extends ChangeNotifier {
  UserAuthStatus _status = UserAuthStatus.notAuthenticated;
  UserAuthStatus get status => _status;

  Person? _currentUser;
  Person? get currentUser => _currentUser;

  final PersonRepository personRepository = PersonRepository();

  Future<void> login(String ssn) async {
    if (_status == UserAuthStatus.inProgress) return;

    _status = UserAuthStatus.inProgress;
    notifyListeners();

    try {
      var persons = await personRepository.getAll();
      if (persons.isEmpty) {
        throw 'No users registrered';
      }
      _currentUser = persons.firstWhere(
        (person) => person.socialSecNumber == ssn,
        orElse: () => throw 'User does not exist',
      );
      _status = UserAuthStatus.authenticated;
      notifyListeners();
    } catch (e) {
      _status = UserAuthStatus.notAuthenticated;
      _currentUser = null;
      notifyListeners();
      throw 'Login failed.\n$e';
    }
  }

  void logout() {
    if (_status == UserAuthStatus.notAuthenticated) return;

    _status = UserAuthStatus.notAuthenticated;
    _currentUser = null;
    notifyListeners();
  }

  Future<void> addUser(Person person) async {
    try {
      await PersonRepository().add(person);
      _status = UserAuthStatus.authenticated;
      _currentUser = person;
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to add person.');
    }
  }

  Future<void> register(String ssn, String name) async {
    if (_status == UserAuthStatus.inProgress) return;

    _status = UserAuthStatus.inProgress;
    notifyListeners();

    try {
      if (!isValidLuhn(ssn)) {
        throw 'Invalid SSN';
      }
      var persons = await PersonRepository().getAll();

      if (persons.any((person) => person.socialSecNumber == ssn)) {
        throw 'SSN already registered';
      }

      Person newPerson = Person.withUUID(name: name, socialSecNumber: ssn);
      await addUser(newPerson);
      _status = UserAuthStatus.notAuthenticated;
      _currentUser = null;
      notifyListeners();

    } catch (e) {
      _status = UserAuthStatus.notAuthenticated;
      _currentUser = null;
      notifyListeners();
      throw 'Failed to register user:\n$e';
    }
  }

    Future<void> authenticateAfterRegistration(String ssn) async {
    try {
      await login(ssn);
    } catch (e) {
      throw 'Authentication failed after registration: $e';
    }
  }
}
