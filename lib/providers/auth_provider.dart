import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../models/user_model.dart';
import 'package:uuid/uuid.dart';

class AuthProvider with ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();
  bool _isLoggedIn = false;
  User? _currentUser;
  bool _isLoading = false;

  bool get isLoggedIn => _isLoggedIn;
  User? get currentUser => _currentUser;
  String? get username => _currentUser?.username;
  bool get isLoading => _isLoading;

  // Login
  Future<bool> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = await _dbService.authenticateUser(username, password);
      if (user != null) {
        _isLoggedIn = true;
        _currentUser = user;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Register
  Future<void> register(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final newUser = User(
        id: const Uuid().v4(),
        username: username,
        password: password,
        createdAt: DateTime.now(),
      );
      await _dbService.registerUser(newUser);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void logout() {
    _isLoggedIn = false;
    _currentUser = null;
    notifyListeners();
  }
}
