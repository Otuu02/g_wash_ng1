// FILE: lib/data/datasources/local/shared_prefs_service.dart
// PURPOSE: Manages local storage using SharedPreferences for lightweight data

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  static SharedPreferences? _prefs;
  
  // Singleton pattern
  static final SharedPrefsService _instance = SharedPrefsService._internal();
  factory SharedPrefsService() => _instance;
  SharedPrefsService._internal();
  
  // Initialize SharedPreferences
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }
  
  // Check if initialized
  static void _checkInitialized() {
    if (_prefs == null) {
      throw Exception('SharedPrefsService not initialized. Call init() first.');
    }
  }
  
  // ==================== TOKEN MANAGEMENT ====================
  static Future<bool> saveAuthToken(String token) async {
    _checkInitialized();
    return await _prefs!.setString('auth_token', token);
  }
  
  static String? getAuthToken() {
    _checkInitialized();
    return _prefs!.getString('auth_token');
  }
  
  static Future<bool> removeAuthToken() async {
    _checkInitialized();
    return await _prefs!.remove('auth_token');
  }
  
  // ==================== USER DATA ====================
  static Future<bool> saveUserData(String key, String value) async {
    _checkInitialized();
    return await _prefs!.setString('user_$key', value);
  }
  
  static String? getUserData(String key) {
    _checkInitialized();
    return _prefs!.getString('user_$key');
  }
  
  static Future<bool> saveUserJson(String userJson) async {
    _checkInitialized();
    return await _prefs!.setString('user_data', userJson);
  }
  
  static String? getUserJson() {
    _checkInitialized();
    return _prefs!.getString('user_data');
  }
  
  // ==================== USER PREFERENCES ====================
  static Future<bool> setDarkMode(bool isDark) async {
    _checkInitialized();
    return await _prefs!.setBool('dark_mode', isDark);
  }
  
  static bool isDarkMode() {
    _checkInitialized();
    return _prefs!.getBool('dark_mode') ?? false;
  }
  
  static Future<bool> setNotificationsEnabled(bool enabled) async {
    _checkInitialized();
    return await _prefs!.setBool('notifications_enabled', enabled);
  }
  
  static bool areNotificationsEnabled() {
    _checkInitialized();
    return _prefs!.getBool('notifications_enabled') ?? true;
  }
  
  static Future<bool> setLanguage(String languageCode) async {
    _checkInitialized();
    return await _prefs!.setString('language', languageCode);
  }
  
  static String getLanguage() {
    _checkInitialized();
    return _prefs!.getString('language') ?? 'en';
  }
  
  // ==================== APP STATE ====================
  static Future<bool> setOnboardingCompleted(bool completed) async {
    _checkInitialized();
    return await _prefs!.setBool('onboarding_completed', completed);
  }
  
  static bool isOnboardingCompleted() {
    _checkInitialized();
    return _prefs!.getBool('onboarding_completed') ?? false;
  }
  
  static Future<bool> setLastOpenedDate(String date) async {
    _checkInitialized();
    return await _prefs!.setString('last_opened', date);
  }
  
  static String? getLastOpenedDate() {
    _checkInitialized();
    return _prefs!.getString('last_opened');
  }
  
  // ==================== LOCATION ====================
  static Future<bool> saveLastLocation(double lat, double lng) async {
    _checkInitialized();
    await _prefs!.setDouble('last_latitude', lat);
    return await _prefs!.setDouble('last_longitude', lng);
  }
  
  static double? getLastLatitude() {
    _checkInitialized();
    return _prefs!.getDouble('last_latitude');
  }
  
  static double? getLastLongitude() {
    _checkInitialized();
    return _prefs!.getDouble('last_longitude');
  }
  
  // ==================== CLEAR ALL DATA ====================
  static Future<bool> clearAll() async {
    _checkInitialized();
    return await _prefs!.clear();
  }
}