// FILE: lib/data/repositories/job_repository.dart
// PURPOSE: Handles all job-related operations (create, accept, track, complete)

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import '../../domain/entities/job_entity.dart';
import '../models/job_model.dart';

class JobRepository {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ==================== JOB CREATION ====================

  /// Create a new job request
  Future<String> createJob({
    required String customerId,
    required String serviceType,
    required int price,
    required double latitude,
    required double longitude,
    required String address,
    required String customerName,
    required String customerPhone,
  }) async {
    try {
      final jobData = {
        'customerId': customerId,
        'customerName': customerName,
        'customerPhone': customerPhone,
        'serviceType': serviceType,
        'price': price,
        'customerLocation': GeoPoint(latitude, longitude),
        'customerAddress': address,
        'status': 'searching',
        'paymentStatus': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };
      
      final docRef = await _firestore.collection('jobs').add(jobData);
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create job: $e');
    }
  }

  /// Get a single job by ID
  Future<JobModel?> getJob(String jobId) async {
    try {
      final doc = await _firestore.collection('jobs').doc(jobId).get();
      if (doc.exists) {
        return JobModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get job: $e');
    }
  }

  /// Stream a single job for real-time updates
  Stream<JobModel?> streamJob(String jobId) {
    return _firestore.collection('jobs').doc(jobId).snapshots().map((doc) {
      if (doc.exists) {
        return JobModel.fromFirestore(doc);
      }
      return null;
    });
  }

  // ==================== JOB ACCEPTANCE ====================

  /// Washer accepts a job
  Future<void> acceptJob(String jobId, String washerId) async {
    try {
      await _firestore.collection('jobs').doc(jobId).update({
        'washerId': washerId,
        'status': 'assigned',
        'assignedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to accept job: $e');
    }
  }

  /// Washer starts en route to customer
  Future<void> startEnRoute(String jobId) async {
    try {
      await _firestore.collection('jobs').doc(jobId).update({
        'status': 'enRoute',
        'enRouteAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to start en route: $e');
    }
  }

  /// Washer arrives at customer location
  Future<void> arriveAtLocation(String jobId) async {
    try {
      await _firestore.collection('jobs').doc(jobId).update({
        'status': 'arrived',
        'arrivedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update arrival: $e');
    }
  }

  /// Washer starts washing
  Future<void> startWashing(String jobId) async {
    try {
      await _firestore.collection('jobs').doc(jobId).update({
        'status': 'washing',
        'startedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to start washing: $e');
    }
  }

  /// Complete the job
  Future<void> completeJob(String jobId) async {
    try {
      await _firestore.collection('jobs').doc(jobId).update({
        'status': 'completed',
        'completedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to complete job: $e');
    }
  }

  // ==================== JOB CANCELLATION ====================

  /// Cancel a job
  Future<void> cancelJob(String jobId, String reason, {bool byCustomer = true}) async {
    try {
      await _firestore.collection('jobs').doc(jobId).update({
        'status': 'cancelled',
        'cancelledBy': byCustomer ? 'customer' : 'washer',
        'cancellationReason': reason,
        'cancelledAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to cancel job: $e');
    }
  }

  // ==================== LOCATION TRACKING ====================

  /// Update washer's current location for a specific job
  Future<void> updateWasherLocation(String jobId, double latitude, double longitude) async {
    try {
      await _firestore.collection('jobs').doc(jobId).update({
        'washerCurrentLocation': GeoPoint(latitude, longitude),
        'lastLocationUpdate': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update location: $e');
    }
  }

  /// Get washer's current location for a job
  Future<GeoPoint?> getWasherLocation(String jobId) async {
    try {
      final doc = await _firestore.collection('jobs').doc(jobId).get();
      if (doc.exists) {
        return doc.data()?['washerCurrentLocation'] as GeoPoint?;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // ==================== JOB QUERIES ====================

  /// Get all jobs for a customer
  Future<List<JobModel>> getCustomerJobs(String customerId) async {
    try {
      final querySnapshot = await _firestore
          .collection('jobs')
          .where('customerId', isEqualTo: customerId)
          .orderBy('createdAt', descending: true)
          .get();
      
      return querySnapshot.docs
          .map((doc) => JobModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get customer jobs: $e');
    }
  }

  /// Get all jobs for a washer
  Future<List<JobModel>> getWasherJobs(String washerId) async {
    try {
      final querySnapshot = await _firestore
          .collection('jobs')
          .where('washerId', isEqualTo: washerId)
          .orderBy('createdAt', descending: true)
          .get();
      
      return querySnapshot.docs
          .map((doc) => JobModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get washer jobs: $e');
    }
  }

  /// Get pending jobs for a washer (jobs that need acceptance)
  Future<List<JobModel>> getPendingJobsForWasher(String washerId) async {
    try {
      // In production, you'd use geoqueries to find nearby jobs
      // For MVP, we'll get jobs in 'searching' status
      final querySnapshot = await _firestore
          .collection('jobs')
          .where('status', isEqualTo: 'searching')
          .limit(20)
          .get();
      
      return querySnapshot.docs
          .map((doc) => JobModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get pending jobs: $e');
    }
  }

  /// Get active jobs for a washer (assigned, enRoute, arrived, washing)
  Future<List<JobModel>> getActiveJobsForWasher(String washerId) async {
    try {
      final querySnapshot = await _firestore
          .collection('jobs')
          .where('washerId', isEqualTo: washerId)
          .where('status', whereIn: ['assigned', 'enRoute', 'arrived', 'washing'])
          .orderBy('assignedAt', descending: true)
          .get();
      
      return querySnapshot.docs
          .map((doc) => JobModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get active jobs: $e');
    }
  }

  // ==================== PAYMENT RELATED ====================

  /// Update payment status for a job
  Future<void> updatePaymentStatus(String jobId, String status, String paymentReference) async {
    try {
      await _firestore.collection('jobs').doc(jobId).update({
        'paymentStatus': status,
        'paymentReference': paymentReference,
        'paidAt': status == 'paid' ? FieldValue.serverTimestamp() : null,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update payment status: $e');
    }
  }

  // ==================== RATING ====================

  /// Add rating for a completed job
  Future<void> addRating({
    required String jobId,
    required String washerId,
    required String customerId,
    required int rating,
    String? comment,
    List<String>? tags,
  }) async {
    try {
      // Add rating
      await _firestore.collection('ratings').add({
        'jobId': jobId,
        'washerId': washerId,
        'customerId': customerId,
        'rating': rating,
        'comment': comment,
        'tags': tags,
        'createdAt': FieldValue.serverTimestamp(),
      });
      
      // Update job with rating
      await _firestore.collection('jobs').doc(jobId).update({
        'rating': rating,
        'ratedAt': FieldValue.serverTimestamp(),
      });
      
      // Update washer's average rating
      final ratingsSnapshot = await _firestore
          .collection('ratings')
          .where('washerId', isEqualTo: washerId)
          .get();
      
      if (ratingsSnapshot.docs.isNotEmpty) {
        double totalRating = 0;
        for (var doc in ratingsSnapshot.docs) {
          totalRating += (doc.data()['rating'] as num).toDouble();
        }
        final averageRating = totalRating / ratingsSnapshot.docs.length;
        
        await _firestore.collection('washers').doc(washerId).update({
          'rating': averageRating,
          'totalRatings': ratingsSnapshot.docs.length,
        });
      }
    } catch (e) {
      throw Exception('Failed to add rating: $e');
    }
  }

  // ==================== DISTANCE CALCULATION ====================

  /// Calculate distance between two coordinates in kilometers
  static double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371;
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);
    final a = (dLat / 2).sin() * (dLat / 2).sin() +
        _toRadians(lat1).cos() * _toRadians(lat2).cos() *
        (dLon / 2).sin() * (dLon / 2).sin();
    final c = 2 * a.sqrt().atan2((1 - a).sqrt());
    return earthRadius * c;
  }

  static double _toRadians(double degrees) {
    return degrees * 3.141592653589793 / 180;
  }

  /// Calculate estimated arrival time based on distance (km) and average speed (km/h)
  static int calculateETA(double distanceKm, {double averageSpeedKmh = 30}) {
    // Average speed in Lagos traffic is about 30 km/h
    final timeInHours = distanceKm / averageSpeedKmh;
    final timeInMinutes = (timeInHours * 60).round();
    return timeInMinutes.clamp(5, 120); // Min 5 min, Max 2 hours
  }

  // ==================== HELPER METHODS ====================

  /// Convert job status to user-friendly string
  static String getStatusString(String status) {
    switch (status) {
      case 'searching':
        return 'Looking for washer...';
      case 'assigned':
        return 'Washer assigned';
      case 'enRoute':
        return 'Washer en route';
      case 'arrived':
        return 'Washer arrived';
      case 'washing':
        return 'Washing in progress';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }

  /// Get color for job status
  static Color getStatusColor(String status) {
    switch (status) {
      case 'searching':
        return Colors.orange;
      case 'assigned':
        return Colors.blue;
      case 'enRoute':
        return Colors.purple;
      case 'arrived':
        return Colors.teal;
      case 'washing':
        return Colors.indigo;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}