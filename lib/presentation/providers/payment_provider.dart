// FILE: lib/presentation/providers/payment_provider.dart
// PURPOSE: Riverpod provider for payment state management

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/payment_repository.dart';

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  return PaymentRepository();
});

final paymentProvider = StateNotifierProvider<PaymentNotifier, PaymentState>((ref) {
  return PaymentNotifier(ref.read(paymentRepositoryProvider));
});

class PaymentNotifier extends StateNotifier<PaymentState> {
  final PaymentRepository _repository;
  
  PaymentNotifier(this._repository) : super(const PaymentState.initial());
  
  Future<bool> processPayment({
    required String jobId,
    required int amount,
    required String email,
    required String phoneNumber,
  }) async {
    state = const PaymentState.processing();
    
    try {
      final result = await _repository.processPayment(
        jobId: jobId,
        amount: amount,
        email: email,
        phoneNumber: phoneNumber,
      );
      
      if (result) {
        state = const PaymentState.success();
      } else {
        state = const PaymentState.error('Payment failed');
      }
      
      return result;
    } catch (e) {
      state = PaymentState.error(e.toString());
      return false;
    }
  }
  
  Future<bool> verifyPayment(String reference) async {
    try {
      return await _repository.verifyPayment(reference);
    } catch (e) {
      state = PaymentState.error(e.toString());
      return false;
    }
  }
  
  void reset() {
    state = const PaymentState.initial();
  }
}

class PaymentState {
  final bool isProcessing;
  final bool isSuccess;
  final String? error;
  
  const PaymentState({
    required this.isProcessing,
    this.isSuccess = false,
    this.error,
  });
  
  const PaymentState.initial() : this(isProcessing: false);
  const PaymentState.processing() : this(isProcessing: true);
  const PaymentState.success() : this(
    isProcessing: false,
    isSuccess: true,
  );
  const PaymentState.error(String error) : this(
    isProcessing: false,
    error: error,
  );
}