import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';
import 'storage_service.dart';
import 'api_service.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final StorageService _storage = StorageService();
  final ApiService _api = ApiService();
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  // Get unique device ID
  Future<String> getDeviceID() async {
    String? savedDeviceId = _storage.getDeviceID();
    if (savedDeviceId != null) {
      return savedDeviceId;
    }

    String deviceId = '';
    
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await _deviceInfo.androidInfo;
        deviceId = androidInfo.id; // Android ID
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await _deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor ?? '';
      }
      
      if (deviceId.isNotEmpty) {
        await _storage.saveDeviceID(deviceId);
      }
      
      return deviceId;
    } catch (e) {
      // Fallback: generate a unique ID based on device info
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await _deviceInfo.androidInfo;
        deviceId = '${androidInfo.model}-${androidInfo.brand}-${androidInfo.device}';
      }
      
      await _storage.saveDeviceID(deviceId);
      return deviceId;
    }
  }

  // Register user
  Future<Map<String, dynamic>> register(String uid) async {
    final deviceId = await getDeviceID();
    
    final result = await _api.registerUser(uid, deviceId);
    
    if (result['success']) {
      await _storage.saveUID(uid);
      await _storage.saveDeviceID(deviceId);
      await _storage.saveUserStatus(result['data']['status']);
      await _storage.setLoggedIn(true);
    }
    
    return result;
  }

  // Check current status
  Future<Map<String, dynamic>> checkStatus() async {
    final uid = _storage.getUID();
    final deviceId = _storage.getDeviceID();
    
    if (uid == null || deviceId == null) {
      return {
        'success': false,
        'message': 'No saved credentials',
      };
    }
    
    final result = await _api.checkUserStatus(uid, deviceId);
    
    if (result['success']) {
      await _storage.saveUserStatus(result['status']);
    }
    
    return result;
  }

  // Logout
  Future<void> logout() async {
    await _storage.clearAll();
  }
}
