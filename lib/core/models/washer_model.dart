// lib/core/models/washer_model.dart
class WasherModel {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String city;
  final String state;
  final bool isOnline;
  final bool approved;
  final double rating;
  final int totalJobs;
  final int totalEarnings;
  final double workingRadius;
  final DateTime? subscriptionValidUntil;
  final DateTime createdAt;

  WasherModel({
    required this.id,
    required this.name,
    required this.phone,
    this.email = '',
    required this.city,
    required this.state,
    this.isOnline = false,
    this.approved = false,
    this.rating = 0.0,
    this.totalJobs = 0,
    this.totalEarnings = 0,
    this.workingRadius = 10.0,
    this.subscriptionValidUntil,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'city': city,
      'state': state,
      'isOnline': isOnline,
      'approved': approved,
      'rating': rating,
      'totalJobs': totalJobs,
      'totalEarnings': totalEarnings,
      'workingRadius': workingRadius,
      'subscriptionValidUntil': subscriptionValidUntil?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory WasherModel.fromMap(Map<String, dynamic> map, String id) {
    return WasherModel(
      id: id,
      name: map['name'] ?? 'Unknown',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      isOnline: map['isOnline'] ?? false,
      approved: map['approved'] ?? false,
      rating: map['rating']?.toDouble() ?? 0.0,
      totalJobs: map['totalJobs'] ?? 0,
      totalEarnings: map['totalEarnings'] ?? 0,
      workingRadius: map['workingRadius']?.toDouble() ?? 10.0,
      subscriptionValidUntil: map['subscriptionValidUntil'] != null 
          ? DateTime.parse(map['subscriptionValidUntil']) 
          : null,
      createdAt: map['createdAt'] != null 
          ? DateTime.parse(map['createdAt']) 
          : DateTime.now(),
    );
  }
}