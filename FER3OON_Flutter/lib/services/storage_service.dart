import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // UID
  Future<void> saveUID(String uid) async {
    await _prefs?.setString(AppConstants.keyUID, uid);
  }

  String? getUID() {
    return _prefs?.getString(AppConstants.keyUID);
  }

  // Device ID
  Future<void> saveDeviceID(String deviceId) async {
    await _prefs?.setString(AppConstants.keyDeviceID, deviceId);
  }

  String? getDeviceID() {
    return _prefs?.getString(AppConstants.keyDeviceID);
  }

  // User Status
  Future<void> saveUserStatus(String status) async {
    await _prefs?.setString(AppConstants.keyUserStatus, status);
  }

  String? getUserStatus() {
    return _prefs?.getString(AppConstants.keyUserStatus);
  }

  // Login State
  Future<void> setLoggedIn(bool value) async {
    await _prefs?.setBool(AppConstants.keyIsLoggedIn, value);
  }

  bool isLoggedIn() {
    return _prefs?.getBool(AppConstants.keyIsLoggedIn) ?? false;
  }

  // Clear all data (logout)
  Future<void> clearAll() async {
    await _prefs?.clear();
  }

  // Check if user has session
  bool hasSession() {
    final uid = getUID();
    final deviceId = getDeviceID();
    return uid != null && deviceId != null && isLoggedIn();
  }
}
