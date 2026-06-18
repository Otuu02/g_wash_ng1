// FILE: lib/domain/entities/job_entity.dart
// PURPOSE: Business entity for Job (immutable)

import 'package:freezed_annotation/freezed_annotation.dart';

part 'job_entity.freezed.dart';
part 'job_entity.g.dart';

enum JobStatusEntity {
  searching,
  assigned,
  enRoute,
  washing,
  completed,
  cancelled,
  failed,
}

enum ServiceTypeEntity {
  basic,
  interior,
  full,
}

enum PaymentStatusEntity {
  pending,
  paid,
  failed,
}

@freezed
class JobEntity with _$JobEntity {
  const factory JobEntity({
    required String id,
    required String customerId,
    String? washerId,
    required JobStatusEntity status,
    required ServiceTypeEntity serviceType,
    required int price,
    required double customerLatitude,
    required double customerLongitude,
    required String customerAddress,
    double? washerLatitude,
    double? washerLongitude,
    required DateTime createdAt,
    DateTime? assignedAt,
    DateTime? startedAt,
    DateTime? completedAt,
    required PaymentStatusEntity paymentStatus,
    String? paymentReference,
    double? distance,
    String? cancellationReason,
    int? rating,
    String? customerName,
    String? customerPhone,
  }) = _JobEntity;
  
  factory JobEntity.fromJson(Map<String, dynamic> json) => _$JobEntityFromJson(json);
}