// lib/providers/auth_provider.dart
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  Map<String, dynamic>? _userData;

  bool get isLoggedIn => _isLoggedIn;
  Map<String, dynamic>? get userData => _userData;

  // Mock sign in for now
  Future<bool> signInWithGoogle() async {
    try {
      // This would be replaced with actual Google sign-in implementation
      await Future.delayed(const Duration(seconds: 1));

      _isLoggedIn = true;
      _userData = {
        'name': 'Student User',
        'email': 'student@university.edu',
        'photo': 'https://via.placeholder.com/150',
      };

      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  // Save additional user information
  Future<bool> saveAdditionalInfo({
    String? bankAccount,
    String? carNumber,
  }) async {
    try {
      // This would be replaced with actual API call
      await Future.delayed(const Duration(milliseconds: 500));

      if (_userData != null) {
        _userData!['bankAccount'] = bankAccount;
        _userData!['carNumber'] = carNumber;
        notifyListeners();
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    _isLoggedIn = false;
    _userData = null;
    notifyListeners();
  }
}
