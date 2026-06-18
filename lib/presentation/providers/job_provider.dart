// FILE: lib/presentation/providers/job_provider.dart
// PURPOSE: Riverpod provider for job state management

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/job_repository.dart';
import '../../domain/entities/job_entity.dart';

final jobRepositoryProvider = Provider<JobRepository>((ref) {
  return JobRepository();
});

final jobProvider = StateNotifierProvider<JobNotifier, JobState>((ref) {
  return JobNotifier(ref.read(jobRepositoryProvider));
});

class JobNotifier extends StateNotifier<JobState> {
  final JobRepository _repository;
  
  JobNotifier(this._repository) : super(const JobState.initial());
  
  Future<String> createJob({
    required String customerId,
    required ServiceTypeEntity serviceType,
    required int price,
    required double latitude,
    required double longitude,
    required String address,
  }) async {
    state = const JobState.loading();
    
    try {
      final jobId = await _repository.createJob(
        customerId: customerId,
        serviceType: serviceType,
        price: price,
        latitude: latitude,
        longitude: longitude,
        address: address,
      );
      state = JobState.created(jobId);
      return jobId;
    } catch (e) {
      state = JobState.error(e.toString());
      rethrow;
    }
  }
  
  Stream<JobEntity?> watchJob(String jobId) {
    return _repository.watchJob(jobId);
  }
  
  Future<void> acceptJob(String jobId, String washerId) async {
    state = const JobState.loading();
    
    try {
      await _repository.acceptJob(jobId, washerId);
      state = const JobState.accepted();
    } catch (e) {
      state = JobState.error(e.toString());
    }
  }
  
  Future<void> completeJob(String jobId) async {
    try {
      await _repository.completeJob(jobId);
    } catch (e) {
      state = JobState.error(e.toString());
    }
  }
  
  Future<void> cancelJob(String jobId, String reason) async {
    try {
      await _repository.cancelJob(jobId, reason);
    } catch (e) {
      state = JobState.error(e.toString());
    }
  }
}

class JobState {
  final bool isLoading;
  final String? createdJobId;
  final String? error;
  
  const JobState({
    required this.isLoading,
    this.createdJobId,
    this.error,
  });
  
  const JobState.initial() : this(isLoading: false);
  const JobState.loading() : this(isLoading: true);
  const JobState.created(String jobId) : this(
    isLoading: false,
    createdJobId: jobId,
  );
  const JobState.accepted() : this(isLoading: false);
  const JobState.error(String error) : this(
    isLoading: false,
    error: error,
  );
}