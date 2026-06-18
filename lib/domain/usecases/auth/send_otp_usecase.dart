// FILE: lib/domain/usecases/auth/send_otp_usecase.dart
// PURPOSE: Send OTP to user's phone number

import '../../repositories/i_auth_repository.dart';

class SendOtpUseCase {
  final IAuthRepository repository;
  
  SendOtpUseCase(this.repository);
  
  Future<void> execute(String phoneNumber) async {
    if (phoneNumber.isEmpty) {
      throw Exception('Phone number cannot be empty');
    }
    
    // Validate Nigerian phone number
    final cleaned = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleaned.length < 10 || cleaned.length > 13) {
      throw Exception('Invalid Nigerian phone number');
    }
    
    await repository.sendOtp(phoneNumber);
  }
}