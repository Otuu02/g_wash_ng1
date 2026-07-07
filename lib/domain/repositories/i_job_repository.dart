// FILE: lib/domain/repositories/i_job_repository.dart
// PURPOSE: Abstract interface for job repository

import '../entities/job_entity.dart';

abstract class IJobRepository {
  Future<String> createJob({
    required String customerId,
    required ServiceTypeEntity serviceType,
    required int price,
    required double latitude,
    required double longitude,
    required String address,
  });
  
  Future<void> acceptJob(String jobId, String washerId);
  Future<void> cancelJob(String jobId, String reason);
  Future<void> completeJob(String jobId);
  Future<void> updateWasherLocation(String jobId, double latitude, double longitude);
  Stream<JobEntity?> watchJob(String jobId);
  Future<List<JobEntity>> getCustomerJobs(String customerId);
  Future<List<JobEntity>> getWasherJobs(String washerId);
}