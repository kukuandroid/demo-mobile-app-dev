import 'package:cinemabooking/features/auth/services/auth_service.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  Map<String, dynamic>? _user;
  bool _isLoading = false;
  String? _error;

  Map<String, dynamic>? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _user != null;

  Future<void> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      final result = await AuthService.register(
        name: name,
        email: email,
        password: password,
        phone: phone,
      );

      if (result['success']) {
        _user = result['data']['user'];
        notifyListeners();
      } else {
        _setError(result['message']);
      }
    } catch (e) {
      _setError('Registration failed: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> login({required String email, required String password}) async {
    _setLoading(true);
    _setError(null);

    try {
      final result = await AuthService.login(email: email, password: password);

      if (result['success']) {
        _user = result['data']['user'];
        notifyListeners();
      } else {
        _setError(result['message']);
      }
    } catch (e) {
      _setError('Login failed: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _setLoading(true);
    _setError(null);

    try {
      final result = await AuthService.logout();
      if (result['success']) {
        _user = null;
        notifyListeners();
      } else {
        _setError(result['message']);
      }
    } catch (e) {
      _setError('Logout failed: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> checkAuthStatus() async {
    final isLoggedIn = await AuthService.isLoggedIn();
    if (isLoggedIn) {
      await loadUser();
    }
  }

  Future<void> loadUser() async {
    _setLoading(true);
    try {
      final result = await AuthService.getCurrentUser();
      if (result['success']) {
        _user = result['data']['user'];
        notifyListeners();
      } else {
        _user = null;
        notifyListeners();
      }
    } catch (e) {
      _user = null;
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> forgotPassword(String email) async {
    _setLoading(true);
    _setError(null);

    try {
      final result = await AuthService.forgotPassword(email);
      if (!result['success']) {
        _setError(result['message']);
      }
    } catch (e) {
      _setError('Failed to send reset email: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      final result = await AuthService.resetPassword(
        token: token,
        newPassword: newPassword,
      );

      if (!result['success']) {
        _setError(result['message']);
      }
    } catch (e) {
      _setError('Failed to reset password: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      final result = await AuthService.updatePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      if (!result['success']) {
        _setError(result['message']);
      }
    } catch (e) {
      _setError('Failed to update password: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
