import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:app/constants.dart';

class AuthProvider with ChangeNotifier {
  final storage = FlutterSecureStorage();

  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  Future<void> login(
      BuildContext context, String email, String password) async {
    final response = await http.post(
      Uri.parse('${Constants.apiUrl}/auth'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await storage.write(key: 'token', value: data['token']);
      _isAuthenticated = true;
      notifyListeners();
      navigateToHome(context); // Passa o contexto para a função
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }

  Future<void> register(
      BuildContext context, String name, String email, String password) async {
    print('register');

    final response = await http.post(
      Uri.parse('${Constants.apiUrl}/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    print(response.body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await storage.write(key: 'token', value: data['token']);
      _isAuthenticated = true;
      notifyListeners();
      navigateToHome(context); // Passa o contexto para a função
    } else {
      throw Exception('Failed to register');
    }
  }

  void navigateToHome(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/home');
  }
}
