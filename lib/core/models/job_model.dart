// lib/core/models/job_model.dart
class JobModel {
  final String id;
  final String customerId;
  final String? washerId;
  final String serviceCategory; // 'Car Wash', 'House Cleaning', 'Laundry'
  final String serviceName;
  final int price;
  final String location;
  final String status; // 'searching', 'assigned', 'enRoute', 'completed', 'cancelled'
  final String paymentStatus; // 'pending', 'paid'
  final DateTime createdAt;
  final DateTime? assignedAt;
  final DateTime? completedAt;
  final String? customerName;
  final String? washerName;

  JobModel({
    required this.id,
    required this.customerId,
    this.washerId,
    required this.serviceCategory,
    required this.serviceName,
    required this.price,
    required this.location,
    required this.status,
    required this.paymentStatus,
    required this.createdAt,
    this.assignedAt,
    this.completedAt,
    this.customerName,
    this.washerName,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerId': customerId,
      'washerId': washerId,
      'serviceCategory': serviceCategory,
      'serviceName': serviceName,
      'price': price,
      'location': location,
      'status': status,
      'paymentStatus': paymentStatus,
      'createdAt': createdAt.toIso8601String(),
      'assignedAt': assignedAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'customerName': customerName,
      'washerName': washerName,
    };
  }

  factory JobModel.fromMap(Map<String, dynamic> map, String id) {
    return JobModel(
      id: id,
      customerId: map['customerId'] ?? '',
      washerId: map['washerId'],
      serviceCategory: map['serviceCategory'] ?? 'Car Wash',
      serviceName: map['serviceName'] ?? 'Unknown',
      price: map['price'] ?? 0,
      location: map['location'] ?? '',
      status: map['status'] ?? 'searching',
      paymentStatus: map['paymentStatus'] ?? 'pending',
      createdAt: map['createdAt'] != null 
          ? DateTime.parse(map['createdAt']) 
          : DateTime.now(),
      assignedAt: map['assignedAt'] != null ? DateTime.parse(map['assignedAt']) : null,
      completedAt: map['completedAt'] != null ? DateTime.parse(map['completedAt']) : null,
      customerName: map['customerName'],
      washerName: map['washerName'],
    );
  }
}