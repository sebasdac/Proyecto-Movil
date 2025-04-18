import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class AuthService {
  final String baseUrl = 'https://security-module.vercel.app';

  Future<User?> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {
        'Content-Type': 'application/json',
        'email': username,
        'password': password
      
      },
     
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return User.fromJson(data);
    } else {
      throw Exception('Login fallido');
    }
  }
}
