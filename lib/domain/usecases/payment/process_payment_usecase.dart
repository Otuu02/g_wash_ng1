// FILE: lib/domain/usecases/payment/process_payment_usecase.dart
// PURPOSE: Process payment for a job

import '../../repositories/i_payment_repository.dart';

class ProcessPaymentUseCase {
  final IPaymentRepository repository;
  
  ProcessPaymentUseCase(this.repository);
  
  Future<bool> execute({
    required String jobId,
    required int amount,
    required String email,
    required String phoneNumber,
  }) async {
    if (jobId.isEmpty) {
      throw Exception('Job ID is required');
    }
    
    if (amount <= 0) {
      throw Exception('Invalid amount');
    }
    
    if (email.isEmpty && phoneNumber.isEmpty) {
      throw Exception('Email or phone number is required');
    }
    
    return await repository.processPayment(
      jobId: jobId,
      amount: amount,
      email: email,
      phoneNumber: phoneNumber,
    );
  }
}