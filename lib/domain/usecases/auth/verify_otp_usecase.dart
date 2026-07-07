// FILE: lib/domain/usecases/auth/verify_otp_usecase.dart
// PURPOSE: Verify OTP code

import '../../repositories/i_auth_repository.dart';

class VerifyOtpUseCase {
  final IAuthRepository repository;
  
  VerifyOtpUseCase(this.repository);
  
  Future<bool> execute(String verificationId, String otpCode) async {
    if (otpCode.length != 6) {
      throw Exception('OTP must be 6 digits');
    }
    
    if (!RegExp(r'^\d+$').hasMatch(otpCode)) {
      throw Exception('OTP must contain only numbers');
    }
    
    return await repository.verifyOtp(verificationId, otpCode);
  }
}