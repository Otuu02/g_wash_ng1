import 'dart:math';
import 'package:flutter/material.dart';

class JobService extends ChangeNotifier {
  static final JobService _instance = JobService._internal();
  factory JobService() => _instance;
  JobService._internal();

  // Service Providers for different categories
  final List<Map<String, dynamic>> _mockCarWashers = [
    {
      'id': 'CW001',
      'name': 'John A.',
      'rating': 4.8,
      'phone': '+234 802 345 6789',
      'latitude': 6.5244,
      'longitude': 3.3792,
      'isOnline': true,
      'vehicle': 'Motorcycle',
      'category': 'Car Wash',
      'experience': '3 years',
      'completedJobs': 245,
    },
    {
      'id': 'CW002',
      'name': 'Michael O.',
      'rating': 4.9,
      'phone': '+234 803 456 7890',
      'latitude': 6.5344,
      'longitude': 3.3892,
      'isOnline': true,
      'vehicle': 'Car',
      'category': 'Car Wash',
      'experience': '5 years',
      'completedJobs': 389,
    },
    {
      'id': 'CW003',
      'name': 'David E.',
      'rating': 4.7,
      'phone': '+234 804 567 8901',
      'latitude': 6.5144,
      'longitude': 3.3692,
      'isOnline': false,
      'vehicle': 'Motorcycle',
      'category': 'Car Wash',
      'experience': '2 years',
      'completedJobs': 156,
    },
  ];

  // House Cleaning Providers
  final List<Map<String, dynamic>> _mockHouseCleaners = [
    {
      'id': 'HC001',
      'name': 'Blessing O.',
      'rating': 4.9,
      'phone': '+234 802 345 6789',
      'latitude': 6.5244,
      'longitude': 3.3792,
      'isOnline': true,
      'vehicle': 'Motorcycle',
      'category': 'House Cleaning',
      'experience': '4 years',
      'completedJobs': 312,
      'specialization': 'Deep Cleaning',
    },
    {
      'id': 'HC002',
      'name': 'Grace E.',
      'rating': 5.0,
      'phone': '+234 803 456 7890',
      'latitude': 6.5344,
      'longitude': 3.3892,
      'isOnline': true,
      'vehicle': 'Car',
      'category': 'House Cleaning',
      'experience': '6 years',
      'completedJobs': 456,
      'specialization': 'Move In/Out',
    },
    {
      'id': 'HC003',
      'name': 'Peace A.',
      'rating': 4.8,
      'phone': '+234 804 567 8901',
      'latitude': 6.5144,
      'longitude': 3.3692,
      'isOnline': true,
      'vehicle': 'Motorcycle',
      'category': 'House Cleaning',
      'experience': '3 years',
      'completedJobs': 189,
      'specialization': 'Office Cleaning',
    },
  ];

  // Laundry Providers
  final List<Map<String, dynamic>> _mockLaundryProviders = [
    {
      'id': 'LP001',
      'name': 'FreshClean Laundry',
      'rating': 4.8,
      'phone': '+234 802 345 6789',
      'latitude': 6.5244,
      'longitude': 3.3792,
      'isOnline': true,
      'vehicle': 'Van',
      'category': 'Laundry',
      'experience': '5 years',
      'completedJobs': 567,
      'turnaround': '24 hours',
    },
    {
      'id': 'LP002',
      'name': 'QuickPress',
      'rating': 4.7,
      'phone': '+234 803 456 7890',
      'latitude': 6.5344,
      'longitude': 3.3892,
      'isOnline': true,
      'vehicle': 'Motorcycle',
      'category': 'Laundry',
      'experience': '3 years',
      'completedJobs': 234,
      'turnaround': '12 hours',
    },
    {
      'id': 'LP003',
      'name': 'Royal Dry Cleaners',
      'rating': 4.9,
      'phone': '+234 804 567 8901',
      'latitude': 6.5144,
      'longitude': 3.3692,
      'isOnline': true,
      'vehicle': 'Van',
      'category': 'Laundry',
      'experience': '7 years',
      'completedJobs': 789,
      'turnaround': '48 hours',
    },
  ];

  List<Map<String, dynamic>> get _allProviders {
    return [..._mockCarWashers, ..._mockHouseCleaners, ..._mockLaundryProviders];
  }

  // Find nearest provider based on category
  Future<Map<String, dynamic>?> findNearestWasher(
    double userLat, 
    double userLng, {
    String? category,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Filter providers by category
    List<Map<String, dynamic>> providers;
    if (category != null) {
      switch (category) {
        case 'House Cleaning':
          providers = _mockHouseCleaners.where((p) => p['isOnline'] == true).toList();
          break;
        case 'Laundry':
          providers = _mockLaundryProviders.where((p) => p['isOnline'] == true).toList();
          break;
        default:
          providers = _mockCarWashers.where((p) => p['isOnline'] == true).toList();
      }
    } else {
      providers = _allProviders.where((p) => p['isOnline'] == true).toList();
    }
    
    if (providers.isEmpty) return null;
    
    // Sort by distance (simulated)
    providers.sort((a, b) {
      final distanceA = _calculateDistance(userLat, userLng, a['latitude'], a['longitude']);
      final distanceB = _calculateDistance(userLat, userLng, b['latitude'], b['longitude']);
      return distanceA.compareTo(distanceB);
    });
    
    // Calculate ETA based on distance
    final nearest = providers.first;
    final distance = _calculateDistance(userLat, userLng, nearest['latitude'], nearest['longitude']);
    final etaMinutes = _calculateETA(distance, nearest['vehicle']);
    nearest['distance'] = distance;
    nearest['eta'] = etaMinutes;
    
    return nearest;
  }

  // Get all providers by category
  Future<List<Map<String, dynamic>>> getProvidersByCategory(String category) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    switch (category) {
      case 'House Cleaning':
        return _mockHouseCleaners.where((p) => p['isOnline'] == true).toList();
      case 'Laundry':
        return _mockLaundryProviders.where((p) => p['isOnline'] == true).toList();
      default:
        return _mockCarWashers.where((p) => p['isOnline'] == true).toList();
    }
  }

  // Create job with category support
  Future<Map<String, dynamic>> createJob({
    required String customerId,
    required String serviceType,
    required int price,
    required String address,
    required double latitude,
    required double longitude,
    String? category,
    Map<String, dynamic>? additionalInfo,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    
    return {
      'id': 'JOB-${DateTime.now().millisecondsSinceEpoch}',
      'customerId': customerId,
      'serviceType': serviceType,
      'category': category ?? 'Car Wash',
      'price': price,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'additionalInfo': additionalInfo ?? {},
      'status': 'pending',
      'createdAt': DateTime.now().toIso8601String(),
    };
  }

  // Assign provider with category support
  Future<Map<String, dynamic>> assignWasher(String jobId, String providerId) async {
    await Future.delayed(const Duration(seconds: 1));
    
    final provider = _allProviders.firstWhere(
      (p) => p['id'] == providerId,
      orElse: () => _mockCarWashers.first,
    );
    
    // Calculate estimated arrival time based on distance
    final etaMinutes = provider['eta'] ?? _getETAForCategory(provider['category']);
    
    return {
      'jobId': jobId,
      'washerId': providerId,
      'washerName': provider['name'],
      'washerPhone': provider['phone'],
      'washerRating': provider['rating'],
      'washerVehicle': provider['vehicle'],
      'estimatedArrival': etaMinutes,
      'status': 'assigned',
      'category': provider['category'],
      'assignedAt': DateTime.now().toIso8601String(),
    };
  }

  // Complete job
  Future<Map<String, dynamic>> completeJob(String jobId) async {
    await Future.delayed(const Duration(seconds: 1));
    return {
      'success': true,
      'jobId': jobId,
      'status': 'completed',
      'completedAt': DateTime.now().toIso8601String(),
    };
  }

  // Cancel job
  Future<Map<String, dynamic>> cancelJob(String jobId) async {
    await Future.delayed(const Duration(seconds: 1));
    return {
      'success': true,
      'jobId': jobId,
      'status': 'cancelled',
      'cancelledAt': DateTime.now().toIso8601String(),
    };
  }

  // Get job details
  Future<Map<String, dynamic>> getJobDetails(String jobId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return {
      'id': jobId,
      'status': 'in_progress',
      'createdAt': DateTime.now().subtract(const Duration(minutes: 15)).toIso8601String(),
      'estimatedCompletion': DateTime.now().add(const Duration(minutes: 30)).toIso8601String(),
    };
  }

  // Get user's job history
  Future<List<Map<String, dynamic>>> getUserJobs(String userId) async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      {
        'id': 'JOB-001',
        'serviceType': 'Exterior Wash',
        'category': 'Car Wash',
        'price': 3000,
        'status': 'completed',
        'date': DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
        'providerName': 'John A.',
        'rating': 5,
      },
      {
        'id': 'JOB-002',
        'serviceType': 'Standard Cleaning',
        'category': 'House Cleaning',
        'price': 15000,
        'status': 'completed',
        'date': DateTime.now().subtract(const Duration(days: 5)).toIso8601String(),
        'providerName': 'Blessing O.',
        'rating': 4,
      },
      {
        'id': 'JOB-003',
        'serviceType': 'Wash & Fold',
        'category': 'Laundry',
        'price': 2000,
        'status': 'in_progress',
        'date': DateTime.now().toIso8601String(),
        'providerName': 'FreshClean Laundry',
        'rating': null,
      },
    ];
  }

  // Helper: Calculate distance between two coordinates (in km) - FIXED
  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371;
    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) * cos(_toRadians(lat2)) *
        sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _toRadians(double degrees) {
    return degrees * pi / 180;
  }

  // Helper: Calculate ETA based on distance and vehicle type
  String _calculateETA(double distanceKm, String vehicleType) {
    int minutes;
    if (vehicleType == 'Motorcycle') {
      minutes = (distanceKm * 2).round();
    } else if (vehicleType == 'Van') {
      minutes = (distanceKm * 3).round();
    } else {
      minutes = (distanceKm * 2.5).round();
    }
    minutes = minutes.clamp(5, 45);
    return '$minutes min';
  }

  // Helper: Get default ETA for category
  String _getETAForCategory(String? category) {
    switch (category) {
      case 'House Cleaning':
        return '30-45 min';
      case 'Laundry':
        return '20-30 min';
      default:
        return '15-20 min';
    }
  }

  // Update provider online status
  Future<void> updateProviderStatus(String providerId, bool isOnline) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final allProviders = [..._mockCarWashers, ..._mockHouseCleaners, ..._mockLaundryProviders];
    final provider = allProviders.firstWhere((p) => p['id'] == providerId);
    provider['isOnline'] = isOnline;
    notifyListeners();
  }

  // Get provider details
  Future<Map<String, dynamic>> getProviderDetails(String providerId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _allProviders.firstWhere(
      (p) => p['id'] == providerId,
      orElse: () => _mockCarWashers.first,
    );
  }
}