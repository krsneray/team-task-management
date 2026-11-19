import 'package:flutter/material.dart';
import 'package:team_task_management/models/auth_response.dart';
import 'package:team_task_management/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final _authService = AuthService();

  bool _isLoading = false;
  String? _errorMessage;

  AuthResponse? _authResponse;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  AuthResponse? get authResponse => _authResponse;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      final response = await _authService.login(email, password);

      _authResponse = response;

      _isLoading = false;
      notifyListeners();

      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll("Exception: ", "");

      notifyListeners();

      return false;
    }
  }

  Future<String?> getToken() async {
    return await _authService.getToken();
  }

  Future<void> logout() async {
    await _authService.logout();
    _authResponse = null;
    notifyListeners();
  }
}
