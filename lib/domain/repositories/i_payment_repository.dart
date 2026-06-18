// FILE: lib/domain/repositories/i_payment_repository.dart
// PURPOSE: Abstract interface for payment repository

abstract class IPaymentRepository {
  Future<bool> processPayment({
    required String jobId,
    required int amount,
    required String email,
    required String phoneNumber,
  });
  
  Future<bool> verifyPayment(String reference);
  Future<void> refundPayment(String transactionId);
}