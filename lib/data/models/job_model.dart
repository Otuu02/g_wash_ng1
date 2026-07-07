// FILE: lib/data/models/job_model.dart
// PURPOSE: Job/Order data model

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'job_model.g.dart';

enum JobStatus {
  searching,
  assigned,
  enRoute,
  washing,
  completed,
  cancelled,
  failed,
}

enum ServiceType {
  basic,
  interior,
  full,
}

enum PaymentStatus {
  pending,
  paid,
  failed,
  refunded,
}

@JsonSerializable()
class JobModel {
  final String? id;
  final String customerId;
  final String? washerId;
  final JobStatus status;
  final ServiceType serviceType;
  final int price;
  final GeoPoint customerLocation;
  final String customerAddress;
  final GeoPoint? washerCurrentLocation;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime createdAt;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? assignedAt;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? startedAt;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? completedAt;
  final PaymentStatus paymentStatus;
  final String? paymentReference;
  final double? distance;
  final List<String>? offeredToWashers;
  final String? cancellationReason;
  final int? rating;
  final String? customerName;
  final String? customerPhone;
  
  JobModel({
    this.id,
    required this.customerId,
    this.washerId,
    required this.status,
    required this.serviceType,
    required this.price,
    required this.customerLocation,
    required this.customerAddress,
    this.washerCurrentLocation,
    required this.createdAt,
    this.assignedAt,
    this.startedAt,
    this.completedAt,
    required this.paymentStatus,
    this.paymentReference,
    this.distance,
    this.offeredToWashers,
    this.cancellationReason,
    this.rating,
    this.customerName,
    this.customerPhone,
  });
  
  factory JobModel.fromJson(Map<String, dynamic> json) => _$JobModelFromJson(json);
  Map<String, dynamic> toJson() => _$JobModelToJson(this);
  
  factory JobModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return JobModel.fromJson({
      ...data,
      'id': doc.id,
    });
  }
  
  static DateTime _timestampFromJson(Timestamp timestamp) => timestamp.toDate();
  static Timestamp _timestampToJson(DateTime date) => Timestamp.fromDate(date);
  
  String getServiceTypeString() {
    switch (serviceType) {
      case ServiceType.basic:
        return 'Basic Wash';
      case ServiceType.interior:
        return 'Interior Cleaning';
      case ServiceType.full:
        return 'Full Detailing';
    }
  }
  
  String getStatusString() {
    switch (status) {
      case JobStatus.searching:
        return 'Searching for washer...';
      case JobStatus.assigned:
        return 'Washer assigned';
      case JobStatus.enRoute:
        return 'Washer en route';
      case JobStatus.washing:
        return 'Washing in progress';
      case JobStatus.completed:
        return 'Completed';
      case JobStatus.cancelled:
        return 'Cancelled';
      case JobStatus.failed:
        return 'Failed';
    }
  }
}