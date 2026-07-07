// FILE: lib/domain/repositories/i_auth_repository.dart
// PURPOSE: Abstract interface for authentication repository

abstract class IAuthRepository {
  Future<void> sendOtp(String phoneNumber);
  Future<bool> verifyOtp(String verificationId, String otpCode);
  Future<void> logout();
  Stream<bool> get authStateChanges;
  String? get currentUserId;
  String? get currentUserPhone;
}