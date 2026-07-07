// FILE: lib/domain/usecases/jobs/track_job_usecase.dart
// PURPOSE: Track job status and washer location

import 'package:stream_transform/stream_transform.dart';
import '../../entities/job_entity.dart';
import '../../repositories/i_job_repository.dart';

class TrackJobUseCase {
  final IJobRepository repository;
  
  TrackJobUseCase(this.repository);
  
  Stream<JobEntity> execute(String jobId) {
    if (jobId.isEmpty) {
      throw Exception('Job ID is required');
    }
    
    return repository.watchJob(jobId).where((job) => job != null).map((job) => job!);
  }
}