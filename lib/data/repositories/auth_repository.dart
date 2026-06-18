// FILE: lib/data/repositories/auth_repository.dart
// PURPOSE: Handles all authentication-related operations (login, signup, logout, OTP)

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/user_entity.dart';
import '../models/user_model.dart';

class AuthRepository {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ==================== OTP AUTHENTICATION ====================

  /// Send OTP to the provided phone number
  /// Returns verificationId that will be used to verify the OTP
  Future<String> sendOTP(String phoneNumber, Function(String) onCodeSent) async {
    try {
      Completer<String> completer = Completer<String>();
      
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-resolve for verified devices
          await _auth.signInWithCredential(credential);
          completer.complete('auto_verified');
        },
        verificationFailed: (FirebaseAuthException e) {
          completer.completeError(e.message ?? 'Verification failed');
        },
        codeSent: (String verificationId, int? resendToken) {
          onCodeSent(verificationId);
          completer.complete(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Timeout handled
        },
      );
      
      return await completer.future;
    } catch (e) {
      throw Exception('Failed to send OTP: $e');
    }
  }

  /// Verify the OTP code and sign in the user
  Future<UserCredential> verifyOTP(String verificationId, String otpCode) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otpCode,
      );
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      throw Exception('Invalid OTP code: $e');
    }
  }

  // ==================== USER MANAGEMENT ====================

  /// Save user data to Firestore after successful authentication
  Future<void> saveUserData({
    required String uid,
    required String name,
    required String phone,
    required String role, // 'customer' or 'washer'
    String? email,
    String? profileImage,
  }) async {
    try {
      final userModel = UserModel(
        uid: uid,
        name: name,
        phone: phone,
        email: email,
        role: role,
        profileImage: profileImage,
        createdAt: DateTime.now(),
        isBlocked: false,
      );
      
      await _firestore.collection('users').doc(uid).set(userModel.toJson());
      
      // Also save to SharedPreferences for quick access
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_uid', uid);
      await prefs.setString('user_name', name);
      await prefs.setString('user_phone', phone);
      await prefs.setString('user_role', role);
    } catch (e) {
      throw Exception('Failed to save user data: $e');
    }
  }

  /// Get current user data from Firestore
  Future<UserModel?> getCurrentUserData() async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) return null;
      
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        return UserModel.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user data: $e');
    }
  }

  /// Update user profile
  Future<void> updateUserProfile({
    String? name,
    String? email,
    String? profileImage,
  }) async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) throw Exception('User not logged in');
      
      final Map<String, dynamic> updates = {};
      if (name != null) updates['name'] = name;
      if (email != null) updates['email'] = email;
      if (profileImage != null) updates['profileImage'] = profileImage;
      updates['updatedAt'] = FieldValue.serverTimestamp();
      
      await _firestore.collection('users').doc(user.uid).update(updates);
      
      // Update SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      if (name != null) await prefs.setString('user_name', name);
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  // ==================== SESSION MANAGEMENT ====================

  /// Check if user is currently logged in
  bool isLoggedIn() {
    return _auth.currentUser != null;
  }

  /// Get current user ID
  String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }

  /// Get current user phone number
  String? getCurrentUserPhone() {
    return _auth.currentUser?.phoneNumber;
  }

  /// Stream of authentication state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ==================== LOGOUT ====================

  /// Sign out the current user
  Future<void> logout() async {
    try {
      await _auth.signOut();
      
      // Clear SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_uid');
      await prefs.remove('user_name');
      await prefs.remove('user_phone');
      await prefs.remove('user_role');
    } catch (e) {
      throw Exception('Failed to logout: $e');
    }
  }

  // ==================== WASHER SPECIFIC ====================

  /// Save washer registration data
  Future<void> saveWasherData({
    required String uid,
    required String vehicleType,
    required int workingRadius,
    required String bankName,
    required String accountNumber,
    required String accountName,
    String? idImageUrl,
  }) async {
    try {
      final washerData = {
        'userId': uid,
        'isOnline': false,
        'isApproved': false,
        'currentLocation': null,
        'workingRadiusKm': workingRadius,
        'totalEarnings': 0,
        'totalJobs': 0,
        'rating': 0.0,
        'totalRatings': 0,
        'vehicleType': vehicleType,
        'bankAccount': {
          'bankName': bankName,
          'accountNumber': accountNumber,
          'accountName': accountName,
        },
        'idImageUrl': idImageUrl,
        'createdAt': FieldValue.serverTimestamp(),
      };
      
      await _firestore.collection('washers').doc(uid).set(washerData);
      
      // Update user role
      await _firestore.collection('users').doc(uid).update({
        'role': 'washer',
        'isWasher': true,
      });
    } catch (e) {
      throw Exception('Failed to save washer data: $e');
    }
  }

  /// Check if user is a washer
  Future<bool> isWasher(String uid) async {
    try {
      final doc = await _firestore.collection('washers').doc(uid).get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }

  /// Get washer data
  Future<Map<String, dynamic>?> getWasherData(String uid) async {
    try {
      final doc = await _firestore.collection('washers').doc(uid).get();
      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // ==================== HELPER METHODS ====================

  /// Format phone number to Nigerian format
  static String formatPhoneNumber(String phone) {
    String cleaned = phone.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleaned.startsWith('0')) {
      cleaned = cleaned.substring(1);
    }
    if (cleaned.length == 10) {
      return '+234$cleaned';
    }
    return phone;
  }

  /// Validate Nigerian phone number
  static bool isValidNigerianPhone(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'[^0-9]'), '');
    return cleaned.length >= 10 && cleaned.length <= 13;
  }
}