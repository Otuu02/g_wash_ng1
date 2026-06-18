// FILE: lib/domain/usecases/jobs/create_job_usecase.dart
// PURPOSE: Create a new job request

import '../../entities/job_entity.dart';
import '../../repositories/i_job_repository.dart';

class CreateJobUseCase {
  final IJobRepository repository;
  
  CreateJobUseCase(this.repository);
  
  Future<String> execute({
    required String customerId,
    required ServiceTypeEntity serviceType,
    required int price,
    required double latitude,
    required double longitude,
    required String address,
  }) async {
    if (customerId.isEmpty) {
      throw Exception('Customer ID is required');
    }
    
    if (price <= 0) {
      throw Exception('Invalid price');
    }
    
    return await repository.createJob(
      customerId: customerId,
      serviceType: serviceType,
      price: price,
      latitude: latitude,
      longitude: longitude,
      address: address,
    );
  }
}