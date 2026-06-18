// FILE: lib/services/auth_service.dart
// PURPOSE: Handle user authentication with persistent storage
// UPDATED: Added support for House Cleaning and Laundry Services

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthService extends ChangeNotifier {
  bool _isLoggedIn = false;
  String? _userName;
  String? _userPhone;
  String? _userId;
  String? _userRole; // customer, washer, cleaner, laundry_provider
  String? _serviceCategory; // Car Wash, House Cleaning, Laundry
  
  // Store registered users
  Map<String, Map<String, String>> _registeredUsers = {};

  AuthService() {
    _loadSavedUser();
  }

  bool get isLoggedIn => _isLoggedIn;
  String? get userName => _userName;
  String? get userPhone => _userPhone;
  String? get userId => _userId;
  String? get userRole => _userRole;
  String? get serviceCategory => _serviceCategory;
  
  bool get isCustomer => _userRole == 'customer' || _userRole == null;
  bool get isWasher => _userRole == 'washer';
  bool get isCleaner => _userRole == 'cleaner';
  bool get isLaundryProvider => _userRole == 'laundry_provider';
  bool get isServiceProvider => isWasher || isCleaner || isLaundryProvider;

  Future<void> _loadSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    _userName = prefs.getString('userName');
    _userPhone = prefs.getString('userPhone');
    _userId = prefs.getString('userId');
    _userRole = prefs.getString('userRole');
    _serviceCategory = prefs.getString('serviceCategory');
    
    // Load registered users from storage
    final usersJson = prefs.getString('registeredUsers');
    if (usersJson != null) {
      final Map<String, dynamic> users = jsonDecode(usersJson);
      _registeredUsers = users.map((key, value) => 
        MapEntry(key, Map<String, String>.from(value))
      );
    }
    
    notifyListeners();
  }

  Future<void> _saveUserState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', _isLoggedIn);
    if (_userName != null) await prefs.setString('userName', _userName!);
    if (_userPhone != null) await prefs.setString('userPhone', _userPhone!);
    if (_userId != null) await prefs.setString('userId', _userId!);
    if (_userRole != null) await prefs.setString('userRole', _userRole!);
    if (_serviceCategory != null) await prefs.setString('serviceCategory', _serviceCategory!);
    
    // Save registered users as JSON
    final usersJson = jsonEncode(_registeredUsers);
    await prefs.setString('registeredUsers', usersJson);
  }

  // ==================== AUTHENTICATION ====================
  
  Future<bool> signup(String name, String phoneNumber, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    
    final cleaned = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
    final formattedPhone = cleaned.length == 10 ? '+234$cleaned' : phoneNumber;
    
    if (name.isEmpty || cleaned.length < 10 || password.isEmpty) {
      return false;
    }
    
    // Check if user already exists
    if (_registeredUsers.containsKey(formattedPhone)) {
      return false;
    }
    
    // Generate a simple user ID
    final userId = DateTime.now().millisecondsSinceEpoch.toString();
    
    // Store the new user
    _registeredUsers[formattedPhone] = {
      'name': name,
      'password': password,
      'phone': formattedPhone,
      'userId': userId,
      'role': 'customer', // Default role
    };
    
    _isLoggedIn = true;
    _userName = name;
    _userPhone = formattedPhone;
    _userId = userId;
    _userRole = 'customer';
    _serviceCategory = null;
    await _saveUserState();
    notifyListeners();
    return true;
  }

  Future<bool> login(String phoneNumber, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    
    final cleaned = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
    final formattedPhone = cleaned.length == 10 ? '+234$cleaned' : phoneNumber;
    
    // Check if user exists in registered users
    if (_registeredUsers.containsKey(formattedPhone)) {
      if (_registeredUsers[formattedPhone]!['password'] == password) {
        _isLoggedIn = true;
        _userName = _registeredUsers[formattedPhone]!['name'];
        _userPhone = formattedPhone;
        _userId = _registeredUsers[formattedPhone]!['userId'];
        _userRole = _registeredUsers[formattedPhone]!['role'] ?? 'customer';
        _serviceCategory = _registeredUsers[formattedPhone]!['serviceCategory'];
        await _saveUserState();
        notifyListeners();
        return true;
      }
    }
    
    // Demo login for testing (any phone + 123456)
    if (password == '123456' && cleaned.length >= 10) {
      _isLoggedIn = true;
      _userName = 'Demo User';
      _userPhone = formattedPhone;
      _userId = DateTime.now().millisecondsSinceEpoch.toString();
      _userRole = 'customer';
      _serviceCategory = null;
      await _saveUserState();
      notifyListeners();
      return true;
    }
    
    return false;
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _userName = null;
    _userPhone = null;
    _userId = null;
    _userRole = null;
    _serviceCategory = null;
    await _saveUserState();
    notifyListeners();
  }

  // ==================== GETTER METHODS ====================
  
  String? getCurrentUserId() {
    return _userId;
  }
  
  String? getCurrentUserPhone() {
    return _userPhone;
  }
  
  String? getCurrentUserRole() {
    return _userRole;
  }

  // ==================== RELOAD USER DATA ====================
  
  Future<void> reloadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    _userName = prefs.getString('userName');
    _userPhone = prefs.getString('userPhone');
    _userId = prefs.getString('userId');
    _userRole = prefs.getString('userRole');
    _serviceCategory = prefs.getString('serviceCategory');
    notifyListeners();
  }

  // ==================== SERVICE PROVIDER METHODS ====================
  
  // Register as Car Wash provider
  Future<void> saveWasherData({
    required String uid,
    required String vehicleType,
    required int workingRadius,
    required String bankName,
    required String accountNumber,
    required String accountName,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userRole', 'washer');
    await prefs.setString('serviceCategory', 'Car Wash');
    await prefs.setString('vehicle_type', vehicleType);
    await prefs.setInt('working_radius', workingRadius);
    await prefs.setString('provider_status', 'pending');
    await prefs.setString('bank_name', bankName);
    await prefs.setString('account_number', accountNumber);
    await prefs.setString('account_name', accountName);
    
    // Update registered users
    if (_userId != null && _registeredUsers.containsKey(_userPhone)) {
      _registeredUsers[_userPhone!]?['role'] = 'washer';
      _registeredUsers[_userPhone!]?['serviceCategory'] = 'Car Wash';
      _registeredUsers[_userPhone!]?['vehicleType'] = vehicleType;
      await _saveUserState();
    }
    
    _userRole = 'washer';
    _serviceCategory = 'Car Wash';
    notifyListeners();
  }
  
  // Register as House Cleaning provider
  Future<void> saveCleanerData({
    required String uid,
    required String specialization,
    required int workingRadius,
    required String bankName,
    required String accountNumber,
    required String accountName,
    required List<String> cleaningTools,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userRole', 'cleaner');
    await prefs.setString('serviceCategory', 'House Cleaning');
    await prefs.setString('specialization', specialization);
    await prefs.setInt('working_radius', workingRadius);
    await prefs.setString('provider_status', 'pending');
    await prefs.setString('bank_name', bankName);
    await prefs.setString('account_number', accountNumber);
    await prefs.setString('account_name', accountName);
    await prefs.setStringList('cleaning_tools', cleaningTools);
    
    // Update registered users
    if (_userId != null && _registeredUsers.containsKey(_userPhone)) {
      _registeredUsers[_userPhone!]?['role'] = 'cleaner';
      _registeredUsers[_userPhone!]?['serviceCategory'] = 'House Cleaning';
      _registeredUsers[_userPhone!]?['specialization'] = specialization;
      await _saveUserState();
    }
    
    _userRole = 'cleaner';
    _serviceCategory = 'House Cleaning';
    notifyListeners();
  }
  
  // Register as Laundry provider
  Future<void> saveLaundryProviderData({
    required String uid,
    required String businessName,
    required int workingRadius,
    required String bankName,
    required String accountNumber,
    required String accountName,
    required String turnaroundTime,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userRole', 'laundry_provider');
    await prefs.setString('serviceCategory', 'Laundry');
    await prefs.setString('business_name', businessName);
    await prefs.setInt('working_radius', workingRadius);
    await prefs.setString('provider_status', 'pending');
    await prefs.setString('bank_name', bankName);
    await prefs.setString('account_number', accountNumber);
    await prefs.setString('account_name', accountName);
    await prefs.setString('turnaround_time', turnaroundTime);
    
    // Update registered users
    if (_userId != null && _registeredUsers.containsKey(_userPhone)) {
      _registeredUsers[_userPhone!]?['role'] = 'laundry_provider';
      _registeredUsers[_userPhone!]?['serviceCategory'] = 'Laundry';
      _registeredUsers[_userPhone!]?['businessName'] = businessName;
      await _saveUserState();
    }
    
    _userRole = 'laundry_provider';
    _serviceCategory = 'Laundry';
    notifyListeners();
  }

  // Get provider status
  Future<bool> isProviderApproved() async {
    final prefs = await SharedPreferences.getInstance();
    final status = prefs.getString('provider_status');
    return status == 'approved';
  }
  
  Future<String> getProviderStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('provider_status') ?? 'pending';
  }
  
  // Get provider data based on role
  Future<Map<String, dynamic>> getProviderData() async {
    final prefs = await SharedPreferences.getInstance();
    final role = _userRole ?? prefs.getString('userRole');
    
    Map<String, dynamic> data = {
      'status': prefs.getString('provider_status') ?? 'pending',
      'workingRadius': prefs.getInt('working_radius') ?? 10,
      'bankName': prefs.getString('bank_name') ?? '',
      'accountNumber': prefs.getString('account_number') ?? '',
      'accountName': prefs.getString('account_name') ?? '',
      'role': role,
      'serviceCategory': _serviceCategory ?? prefs.getString('serviceCategory'),
    };
    
    // Add role-specific data
    if (role == 'washer') {
      data['vehicleType'] = prefs.getString('vehicle_type') ?? '';
    } else if (role == 'cleaner') {
      data['specialization'] = prefs.getString('specialization') ?? '';
      data['cleaningTools'] = prefs.getStringList('cleaning_tools') ?? [];
    } else if (role == 'laundry_provider') {
      data['businessName'] = prefs.getString('business_name') ?? '';
      data['turnaroundTime'] = prefs.getString('turnaround_time') ?? '24 hours';
    }
    
    return data;
  }
  
  // For testing - allow admin to approve provider
  Future<void> setProviderApproved(bool approved) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('provider_status', approved ? 'approved' : 'pending');
    notifyListeners();
  }
  
  // Get service category display name
  String getServiceCategoryDisplay() {
    switch (_serviceCategory) {
      case 'House Cleaning':
        return 'House Cleaner';
      case 'Laundry':
        return 'Laundry Service';
      case 'Car Wash':
        return 'Car Washer';
      default:
        return 'Service Provider';
    }
  }
  
  // Get icon for service category
  IconData getServiceCategoryIcon() {
    switch (_serviceCategory) {
      case 'House Cleaning':
        return Icons.cleaning_services;
      case 'Laundry':
        return Icons.local_laundry_service;
      case 'Car Wash':
        return Icons.local_car_wash;
      default:
        return Icons.work;
    }
  }
  
  // Get color for service category
  Color getServiceCategoryColor() {
    switch (_serviceCategory) {
      case 'House Cleaning':
        return Colors.blue;
      case 'Laundry':
        return Colors.purple;
      case 'Car Wash':
        return const Color(0xFF0CAF60);
      default:
        return const Color(0xFF0CAF60);
    }
  }

  // Update user profile
  Future<void> updateUserProfile({
    String? name,
    String? phone,
    String? email,
  }) async {
    if (_userId == null) return;
    
    final prefs = await SharedPreferences.getInstance();
    if (name != null) {
      _userName = name;
      await prefs.setString('userName', name);
    }
    if (phone != null) {
      _userPhone = phone;
      await prefs.setString('userPhone', phone);
    }
    if (email != null) {
      await prefs.setString('userEmail', email);
    }
    
    // Update registered users
    if (_registeredUsers.containsKey(_userPhone)) {
      if (name != null) _registeredUsers[_userPhone!]?['name'] = name;
      await _saveUserState();
    }
    
    notifyListeners();
  }
  
  // Get user email
  Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userEmail');
  }

  // ==================== WASHER SPECIFIC METHODS (ADDED FOR COMPATIBILITY) ====================
  
  /// Get washer data (for backward compatibility with washer_dashboard)
  Future<Map<String, dynamic>> getWasherData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'vehicleType': prefs.getString('vehicle_type') ?? '',
      'workingRadius': prefs.getInt('working_radius') ?? 10,
      'bankName': prefs.getString('bank_name') ?? '',
      'accountNumber': prefs.getString('account_number') ?? '',
      'accountName': prefs.getString('account_name') ?? '',
      'status': prefs.getString('washer_status') ?? 'pending',
    };
  }

  /// Get washer status (for backward compatibility with washer_dashboard)
  Future<String> getWasherStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('washer_status') ?? 'pending';
  }

  /// Set washer approved status
  Future<void> setWasherApproved(bool approved) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('washer_status', approved ? 'approved' : 'pending');
    notifyListeners();
  }
}