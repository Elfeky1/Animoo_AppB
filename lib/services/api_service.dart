import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.1.2:5000';

  ///    LOGIN
  static Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
      return true;
    }
    return false;
  }

  ///    REGISTER
  static Future<bool> register(
    String name,
    String email,
    String phone,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
        }),
      );

      return response.statusCode == 201;
    } catch (_) {
      return false;
    }
  }

  ///   SEND OTP
  ///  user enters phone
  ///  OTP sent to email
  static Future<bool> sendOtp(String phone, String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/send-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'phone': phone,
        'email': email,
      }),
    );

    return response.statusCode == 200;
  }

  ///             VERIFY OTP
  /// verify using email + otp
  static Future<bool> verifyOtp(String email, String otp) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/verify-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'otp': otp,
      }),
    );

    return response.statusCode == 200;
  }

  static Future<bool> resetPassword(
    String email,
    String newPassword,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/reset-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': newPassword,
      }),
    );

    return response.statusCode == 200;
  }
}
