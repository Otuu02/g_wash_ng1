// FILE: lib/core/di/injection.dart
// PURPOSE: Dependency injection setup for the app

import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../data/datasources/remote/api_service.dart';
import '../../data/datasources/local/shared_prefs_service.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/job_repository.dart';
import '../../data/repositories/payment_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../../domain/usecases/auth/send_otp_usecase.dart';
import '../../domain/usecases/auth/verify_otp_usecase.dart';
import '../../domain/usecases/jobs/create_job_usecase.dart';
import '../../domain/usecases/jobs/accept_job_usecase.dart';
import '../../domain/usecases/jobs/track_job_usecase.dart';
import '../../domain/usecases/payment/process_payment_usecase.dart';

final GetIt getIt = GetIt.instance;

class Injection {
  Injection._();
  
  static Future<void> setup() async {
    // ==================== EXTERNAL DEPENDENCIES ====================
    // Shared Preferences
    final sharedPreferences = await SharedPreferences.getInstance();
    getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
    
    // HTTP Client
    getIt.registerLazySingleton<http.Client>(() => http.Client());
    
    // ==================== SERVICES ====================
    // Local Storage
    getIt.registerLazySingleton<SharedPrefsService>(
      () => SharedPrefsService(getIt<SharedPreferences>()),
    );
    
    // API Service
    getIt.registerLazySingleton<ApiService>(
      () => ApiService(getIt<http.Client>()),
    );
    
    // ==================== REPOSITORIES ====================
    getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepository(),
    );
    
    getIt.registerLazySingleton<JobRepository>(
      () => JobRepository(),
    );
    
    getIt.registerLazySingleton<PaymentRepository>(
      () => PaymentRepository(),
    );
    
    getIt.registerLazySingleton<UserRepository>(
      () => UserRepository(),
    );
    
    // ==================== USE CASES ====================
    // Auth Use Cases
    getIt.registerLazySingleton<SendOtpUseCase>(
      () => SendOtpUseCase(getIt<AuthRepository>()),
    );
    
    getIt.registerLazySingleton<VerifyOtpUseCase>(
      () => VerifyOtpUseCase(getIt<AuthRepository>()),
    );
    
    // Job Use Cases
    getIt.registerLazySingleton<CreateJobUseCase>(
      () => CreateJobUseCase(getIt<JobRepository>()),
    );
    
    getIt.registerLazySingleton<AcceptJobUseCase>(
      () => AcceptJobUseCase(getIt<JobRepository>()),
    );
    
    getIt.registerLazySingleton<TrackJobUseCase>(
      () => TrackJobUseCase(getIt<JobRepository>()),
    );
    
    // Payment Use Cases
    getIt.registerLazySingleton<ProcessPaymentUseCase>(
      () => ProcessPaymentUseCase(getIt<PaymentRepository>()),
    );
  }
}

// Helper getters for common use cases
SendOtpUseCase get sendOtpUseCase => getIt<SendOtpUseCase>();
VerifyOtpUseCase get verifyOtpUseCase => getIt<VerifyOtpUseCase>();
CreateJobUseCase get createJobUseCase => getIt<CreateJobUseCase>();
AcceptJobUseCase get acceptJobUseCase => getIt<AcceptJobUseCase>();
TrackJobUseCase get trackJobUseCase => getIt<TrackJobUseCase>();
ProcessPaymentUseCase get processPaymentUseCase => getIt<ProcessPaymentUseCase>();