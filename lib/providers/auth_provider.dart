// lib/providers/auth_provider.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  Map<String, dynamic>? _userData;

  bool get isLoggedIn => _isLoggedIn;
  Map<String, dynamic>? get userData => _userData;

  final String baseUrl = 'http://localhost:8080';

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
      print('🟡 saveAdditionalInfo() called');
      print('🟡 name: "$name"');
      print('🟡 email: "$email"');
      print('🟡 bankAccount: "$bankAccount"');
      print('🟡 carNumber: "$carNumber"');

      debugPrint('📡 POST ${url.toString()}');
      debugPrint('📦 Payload: $name, $email, $bankAccount, $carNumber');
      debugPrint('📬 Status: ${response.statusCode}');
      debugPrint('📬 Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _userData = data;
        _isLoggedIn = true;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', data['userId']);

        notifyListeners();
        return true;
      } else if (response.statusCode == 500 &&
          response.body.contains('already exists')) {
        print('Email already exists');
        return false;
      } else {
        print('Unknown error: ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return false;
    }
  }

  Future<void> signOut() async {
    _isLoggedIn = false;
    _userData = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    notifyListeners();
  }
}
