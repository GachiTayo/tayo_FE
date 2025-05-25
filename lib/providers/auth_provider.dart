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
      final url = Uri.parse('$baseUrl/api/users/$storedId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        _userId = storedId;
        _isLoggedIn = true;
        notifyListeners();
        print('userId is valid and loaded: $_userId');
      } else {
        // 저장하고 있는 유저 확인
        print('Stored userId is invalid. Removing...');
        await prefs.remove('userId');
        _userId = null;
        _isLoggedIn = false;
        notifyListeners();
      }
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

      print('POST ${url.toString()}');
      print('Payload: $name, $email, $bankAccount, $carNumber');
      print('Status: ${response.statusCode}');
      print('Response: ${response.body}');

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
        print('❗ User already exists');
        return false;
      } else {
        print('❌ Failed to create user: ${response.body}');
        return false;
      }
    } catch (e) {
      print('❌ Exception: $e');
      return false;
    }
  }

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    _userId = null;
    _userData = null;
    notifyListeners();
  }

  // MYPAGE ===============================
  Future<Map<String, dynamic>?> getUserInfo() async {
    if (_userId == null) return null;

    final url = Uri.parse('$baseUrl/api/users/$_userId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      // User not found (possibly deleted from DB)
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('userId');
      _userId = null;
      _isLoggedIn = false;
      notifyListeners();
      return null;
    } else {
      throw Exception('Failed to fetch user info: ${response.statusCode}');
    }
  }
}
