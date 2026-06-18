// FILE: lib/data/datasources/remote/firebase_service.dart
// PURPOSE: Firebase service for authentication and database operations

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/constants/app_constants.dart';

class FirebaseService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // ==================== AUTHENTICATION ====================
  static Future<void> sendOTP(String phoneNumber, Function(String) onCodeSent) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (error) {
        throw Exception(error.message);
      },
      codeSent: (verificationId, resendToken) {
        onCodeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (verificationId) {},
    );
  }
  
  static Future<UserCredential> verifyOTP(String verificationId, String otpCode) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otpCode,
    );
    return await _auth.signInWithCredential(credential);
  }
  
  static Future<void> logout() async {
    await _auth.signOut();
  }
  
  static User? getCurrentUser() {
    return _auth.currentUser;
  }
  
  static Stream<User?> get authStateChanges => _auth.authStateChanges();
  
  // ==================== USER OPERATIONS ====================
  static Future<void> createUser({
    required String uid,
    required String name,
    required String phone,
    required String role,
  }) async {
    await _firestore.collection('users').doc(uid).set({
      'uid': uid,
      'name': name,
      'phone': phone,
      'role': role,
      'createdAt': FieldValue.serverTimestamp(),
      'isBlocked': false,
      'isVerified': true,
    });
  }
  
  static Future<DocumentSnapshot> getUser(String uid) async {
    return await _firestore.collection('users').doc(uid).get();
  }
  
  static Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _firestore.collection('users').doc(uid).update(data);
  }
  
  // ==================== JOB OPERATIONS ====================
  static Future<String> createJob(Map<String, dynamic> jobData) async {
    final docRef = await _firestore.collection('jobs').add({
      ...jobData,
      'createdAt': FieldValue.serverTimestamp(),
      'status': 'searching',
      'paymentStatus': 'pending',
    });
    return docRef.id;
  }
  
  static Stream<DocumentSnapshot> getJobStream(String jobId) {
    return _firestore.collection('jobs').doc(jobId).snapshots();
  }
  
  static Future<QuerySnapshot> getUserJobs(String userId, String role) async {
    return await _firestore
        .collection('jobs')
        .where(role == 'customer' ? 'customerId' : 'washerId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();
  }
  
  static Future<void> updateJob(String jobId, Map<String, dynamic> data) async {
    await _firestore.collection('jobs').doc(jobId).update(data);
  }
  
  // ==================== WASHER OPERATIONS ====================
  static Future<void> updateWasherLocation(String washerId, double lat, double lng) async {
    await _firestore.collection('washers').doc(washerId).update({
      'currentLocation': GeoPoint(lat, lng),
      'lastUpdated': FieldValue.serverTimestamp(),
    });
  }
  
  static Future<QuerySnapshot> getNearbyWashers(double lat, double lng, double radiusKm) async {
    // This is a simplified query. For production, use geohashes
    return await _firestore
        .collection('washers')
        .where('isOnline', isEqualTo: true)
        .where('isApproved', isEqualTo: true)
        .limit(20)
        .get();
  }
  
  // ==================== RATING OPERATIONS ====================
  static Future<void> addRating(Map<String, dynamic> ratingData) async {
    await _firestore.collection('ratings').add({
      ...ratingData,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
  
  static Future<QuerySnapshot> getWasherRatings(String washerId) async {
    return await _firestore
        .collection('ratings')
        .where('washerId', isEqualTo: washerId)
        .orderBy('createdAt', descending: true)
        .get();
  }
}