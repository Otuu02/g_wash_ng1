// FILE: lib/presentation/providers/auth_provider.dart
// PURPOSE: Riverpod provider for authentication state management

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(authRepositoryProvider));
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;
  
  AuthNotifier(this._repository) : super(const AuthState.initial());
  
  Future<void> sendOTP(String phoneNumber) async {
    state = const AuthState.loading();
    
    try {
      await _repository.sendOTP(phoneNumber, (verificationId) {
        state = AuthState.otpSent(verificationId);
      });
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }
  
  Future<void> verifyOTP(String verificationId, String otpCode) async {
    state = const AuthState.loading();
    
    try {
      final user = await _repository.verifyOTP(verificationId, otpCode);
      state = AuthState.authenticated(user);
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }
  
  Future<void> logout() async {
    await _repository.logout();
    state = const AuthState.unauthenticated();
  }
  
  void clearError() {
    if (state.error != null) {
      state = AuthState.initial();
    }
  }
}

class AuthState {
  final bool isLoading;
  final String? verificationId;
  final User? user;
  final String? error;
  
  const AuthState({
    required this.isLoading,
    this.verificationId,
    this.user,
    this.error,
  });
  
  const AuthState.initial() : this(isLoading: false);
  const AuthState.loading() : this(isLoading: true);
  const AuthState.otpSent(String verificationId) : this(
    isLoading: false,
    verificationId: verificationId,
  );
  const AuthState.authenticated(User user) : this(
    isLoading: false,
    user: user,
  );
  const AuthState.unauthenticated() : this(isLoading: false);
  const AuthState.error(String error) : this(
    isLoading: false,
    error: error,
  );
}