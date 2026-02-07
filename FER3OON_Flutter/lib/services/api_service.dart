import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final String _baseUrl = AppConstants.baseUrl;

  // Register user with UID and Device ID
  Future<Map<String, dynamic>> registerUser(String uid, String deviceId) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl${AppConstants.registerEndpoint}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'uid': uid,
          'deviceId': deviceId,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'data': jsonDecode(response.body),
        };
      } else {
        return {
          'success': false,
          'message': jsonDecode(response.body)['message'] ?? 'Registration failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  // Check user status
  Future<Map<String, dynamic>> checkUserStatus(String uid, String deviceId) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl${AppConstants.checkStatusEndpoint}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'uid': uid,
          'deviceId': deviceId,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'status': data['status'],
          'data': data,
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to check status',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  // Get signal
  Future<Map<String, dynamic>> getSignal(String uid) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl${AppConstants.getSignalEndpoint}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'uid': uid,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'signal': data['signal'],
          'timestamp': data['timestamp'],
        };
      } else {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to get signal',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  // Health check
  Future<bool> checkHealth() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/ping'),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
