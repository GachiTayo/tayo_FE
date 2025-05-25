// lib/providers/auth_provider.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  String? _userId;
  Map<String, dynamic>? _userData;

  bool get isLoggedIn => _isLoggedIn;
  String? get userId => _userId;
  Map<String, dynamic>? get userData => _userData;

  final String baseUrl = 'http://localhost:8080'; // Windows only

  Future<void> initUser() async {
    final prefs = await SharedPreferences.getInstance();
    final storedId = prefs.getString('userId');

    if (storedId != null) {
      _userId = storedId;
      _isLoggedIn = true;
      notifyListeners();
      debugPrint('✅ Loaded userId from storage: $_userId');
    } else {
      debugPrint('❌ No saved userId found');
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      _isLoggedIn = true;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> saveAdditionalInfo({
    required String name,
    required String email,
    required String bankAccount,
    required String carNumber,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/api/users');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'bankAccount': bankAccount,
          'carNum': carNumber,
        }),
      );

      debugPrint('POST ${url.toString()}');
      debugPrint('Payload: $name, $email, $bankAccount, $carNumber');
      debugPrint('Status: ${response.statusCode}');
      debugPrint('Response: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        _userId = data['userId'];
        _userData = data;
        _isLoggedIn = true;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', _userId!);

        notifyListeners();
        return true;
      } else if (response.statusCode == 500 &&
          response.body.contains('already exists')) {
        debugPrint('❗ User already exists');
        return false;
      } else {
        debugPrint('❌ Failed to create user: ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('❌ Exception: $e');
      return false;
    }
  }

  Future<void> signOut() async {
    _isLoggedIn = false;
    _userId = null;
    _userData = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    notifyListeners();
  }
}
