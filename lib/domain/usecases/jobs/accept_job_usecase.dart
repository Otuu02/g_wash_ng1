// FILE: lib/domain/usecases/jobs/accept_job_usecase.dart
// PURPOSE: Washer accepts a job

import '../../repositories/i_job_repository.dart';

class AcceptJobUseCase {
  final IJobRepository repository;
  
  AcceptJobUseCase(this.repository);
  
  Future<void> execute(String jobId, String washerId) async {
    if (jobId.isEmpty) {
      throw Exception('Job ID is required');
    }
    
    if (washerId.isEmpty) {
      throw Exception('Washer ID is required');
    }
    
    await repository.acceptJob(jobId, washerId);
  }
}