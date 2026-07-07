// FILE: lib/data/mappers/job_mapper.dart
// PURPOSE: Maps between JobModel and JobEntity

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/job_entity.dart';
import '../models/job_model.dart';

class JobMapper {
  // Convert Entity to Model (for API/save)
  static JobModel toModel(JobEntity entity) {
    return JobModel(
      id: entity.id,
      customerId: entity.customerId,
      washerId: entity.washerId,
      status: _mapStatusToModel(entity.status),
      serviceType: _mapServiceTypeToModel(entity.serviceType),
      price: entity.price,
      customerLocation: GeoPoint(
        entity.customerLatitude,
        entity.customerLongitude,
      ),
      customerAddress: entity.customerAddress,
      washerCurrentLocation: entity.washerLatitude != null && entity.washerLongitude != null
          ? GeoPoint(entity.washerLatitude!, entity.washerLongitude!)
          : null,
      createdAt: entity.createdAt,
      assignedAt: entity.assignedAt,
      startedAt: entity.startedAt,
      completedAt: entity.completedAt,
      paymentStatus: _mapPaymentStatusToModel(entity.paymentStatus),
      paymentReference: entity.paymentReference,
      distance: entity.distance,
      cancellationReason: entity.cancellationReason,
      rating: entity.rating,
      customerName: entity.customerName,
      customerPhone: entity.customerPhone,
    );
  }
  
  // Convert Model to Entity (for UI/business logic)
  static JobEntity toEntity(JobModel model) {
    return JobEntity(
      id: model.id!,
      customerId: model.customerId,
      washerId: model.washerId,
      status: _mapStatusToEntity(model.status),
      serviceType: _mapServiceTypeToEntity(model.serviceType),
      price: model.price,
      customerLatitude: model.customerLocation.latitude,
      customerLongitude: model.customerLocation.longitude,
      customerAddress: model.customerAddress,
      washerLatitude: model.washerCurrentLocation?.latitude,
      washerLongitude: model.washerCurrentLocation?.longitude,
      createdAt: model.createdAt,
      assignedAt: model.assignedAt,
      startedAt: model.startedAt,
      completedAt: model.completedAt,
      paymentStatus: _mapPaymentStatusToEntity(model.paymentStatus),
      paymentReference: model.paymentReference,
      distance: model.distance,
      cancellationReason: model.cancellationReason,
      rating: model.rating,
      customerName: model.customerName,
      customerPhone: model.customerPhone,
    );
  }
  
  // Status mappings
  static JobStatus _mapStatusToModel(JobStatusEntity entity) {
    switch (entity) {
      case JobStatusEntity.searching:
        return JobStatus.searching;
      case JobStatusEntity.assigned:
        return JobStatus.assigned;
      case JobStatusEntity.enRoute:
        return JobStatus.enRoute;
      case JobStatusEntity.washing:
        return JobStatus.washing;
      case JobStatusEntity.completed:
        return JobStatus.completed;
      case JobStatusEntity.cancelled:
        return JobStatus.cancelled;
      case JobStatusEntity.failed:
        return JobStatus.failed;
    }
  }
  
  static JobStatusEntity _mapStatusToEntity(JobStatus model) {
    switch (model) {
      case JobStatus.searching:
        return JobStatusEntity.searching;
      case JobStatus.assigned:
        return JobStatusEntity.assigned;
      case JobStatus.enRoute:
        return JobStatusEntity.enRoute;
      case JobStatus.washing:
        return JobStatusEntity.washing;
      case JobStatus.completed:
        return JobStatusEntity.completed;
      case JobStatus.cancelled:
        return JobStatusEntity.cancelled;
      case JobStatus.failed:
        return JobStatusEntity.failed;
    }
  }
  
  // Service Type mappings
  static ServiceType _mapServiceTypeToModel(ServiceTypeEntity entity) {
    switch (entity) {
      case ServiceTypeEntity.basic:
        return ServiceType.basic;
      case ServiceTypeEntity.interior:
        return ServiceType.interior;
      case ServiceTypeEntity.full:
        return ServiceType.full;
    }
  }
  
  static ServiceTypeEntity _mapServiceTypeToEntity(ServiceType model) {
    switch (model) {
      case ServiceType.basic:
        return ServiceTypeEntity.basic;
      case ServiceType.interior:
        return ServiceTypeEntity.interior;
      case ServiceType.full:
        return ServiceTypeEntity.full;
    }
  }
  
  // Payment Status mappings
  static PaymentStatus _mapPaymentStatusToModel(PaymentStatusEntity entity) {
    switch (entity) {
      case PaymentStatusEntity.pending:
        return PaymentStatus.pending;
      case PaymentStatusEntity.paid:
        return PaymentStatus.paid;
      case PaymentStatusEntity.failed:
        return PaymentStatus.failed;
    }
  }
  
  static PaymentStatusEntity _mapPaymentStatusToEntity(PaymentStatus model) {
    switch (model) {
      case PaymentStatus.pending:
        return PaymentStatusEntity.pending;
      case PaymentStatus.paid:
        return PaymentStatusEntity.paid;
      case PaymentStatus.failed:
        return PaymentStatusEntity.failed;
    }
  }
}