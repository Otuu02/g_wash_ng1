import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../services/location_service.dart';
import '../customer/rating_screen.dart';

class TrackingScreen extends StatefulWidget {
  final String jobId;
  final String washerName;
  final String pickupAddress;
  final LatLng pickupLocation;
  final String serviceName;
  final int price;

  const TrackingScreen({
    super.key,
    required this.jobId,
    required this.washerName,
    required this.pickupAddress,
    required this.pickupLocation,
    this.serviceName = 'Car Wash',
    this.price = 0,
  });

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  bool _isLoading = true;
  bool _isServiceCompleted = false;
  int _currentStep = 1; // 0=Confirmed, 1=En Route, 2=Arrived, 3=Completed
  String _jobStatus = 'assigned';
  String? _washerId;
  String _currentLocation = 'En route to your location';
  int _etaMinutes = 15;
  double _distanceKm = 1.5;
  bool _isProcessing = false;

  GoogleMapController? _mapController;
  late LatLng _clientLocation;
  late LatLng _providerLocation;
  StreamSubscription? _jobSubscription;
  StreamSubscription? _washerSubscription;

  @override
  void initState() {
    super.initState();
    _clientLocation = widget.pickupLocation;
    _providerLocation = LatLng(
      widget.pickupLocation.latitude + 0.008,
      widget.pickupLocation.longitude + 0.008,
    );
    _listenToJobUpdates();
  }

  @override
  void dispose() {
    _jobSubscription?.cancel();
    _washerSubscription?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  void _listenToJobUpdates() {
    _jobSubscription = FirebaseFirestore.instance
        .collection('jobs')
        .doc(widget.jobId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data()!;
        final status = data['status'] ?? 'assigned';
        _washerId = data['washerId'] ?? data['assignedWasherId'];
        
        if (_washerId != null && _washerId!.isNotEmpty && _washerSubscription == null) {
          _listenToWasherLocation(_washerId!);
        }
        
        setState(() {
          _jobStatus = status;
          _isLoading = false;
          
          switch (status) {
            case 'assigned':
              _currentStep = 1;
              _currentLocation = 'Washer assigned & on the way';
              break;
            case 'accepted':
              _currentStep = 1;
              _currentLocation = 'Washer accepted your request';
              break;
            case 'enRoute':
              _currentStep = 1;
              _currentLocation = 'Washer is en route to your location';
              break;
            case 'arrived':
              _currentStep = 2;
              _currentLocation = 'Washer has arrived at your location';
              _etaMinutes = 0;
              break;
            case 'completed':
              _currentStep = 3;
              _currentLocation = 'Service completed successfully!';
              _isServiceCompleted = true;
              break;
            case 'cancelled':
              _currentLocation = 'This job has been cancelled';
              break;
          }
        });
      }
    });
  }

  void _listenToWasherLocation(String washerId) {
    _washerSubscription = LocationService().getWasherLocationStream(washerId).listen((doc) {
      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        final lat = (data['currentLat'] ?? data['latitude'] ?? (_clientLocation.latitude + 0.005)) as double;
        final lng = (data['currentLng'] ?? data['longitude'] ?? (_clientLocation.longitude + 0.005)) as double;
        final newProviderLoc = LatLng(lat, lng);
        
        final dist = _calculateDistance(_clientLocation.latitude, _clientLocation.longitude, lat, lng);
        final eta = (dist * 4).round().clamp(1, 45);

        setState(() {
          _providerLocation = newProviderLoc;
          _distanceKm = dist;
          if (_currentStep < 2) {
            _etaMinutes = eta;
          }
        });
      }
    });
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) *
            (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  Future<void> _cancelJob() async {
    setState(() => _isProcessing = true);

    try {
      await FirebaseFirestore.instance
          .collection('jobs')
          .doc(widget.jobId)
          .update({
        'status': 'cancelled',
        'cancelledAt': FieldValue.serverTimestamp(),
        'cancelledBy': 'customer',
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Job cancelled successfully'),
            backgroundColor: AppColors.primary,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      print('❌ Error cancelling job: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error cancelling job: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  Future<void> _confirmCompletion() async {
    setState(() => _isProcessing = true);

    try {
      // Update job status to completed
      await FirebaseFirestore.instance
          .collection('jobs')
          .doc(widget.jobId)
          .update({
        'status': 'completed',
        'completedAt': FieldValue.serverTimestamp(),
        'paymentStatus': 'paid',
      });

      setState(() {
        _isServiceCompleted = true;
        _currentStep = 3;
        _isProcessing = false;
      });

      // Show payment dialog
      _showPaymentDialog();
      
    } catch (e) {
      print('❌ Error completing job: $e');
      setState(() => _isProcessing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error completing job: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _showPaymentDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Payment',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Service completed successfully!'),
            const SizedBox(height: 8),
            Text(
              'Service: ${widget.serviceName}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary.withOpacity(0.1)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Amount',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    '₦${NumberFormat('#,###').format(widget.price)}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: AppColors.primary)),
          ),
          ElevatedButton(
            onPressed: _processPayment,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Pay Now'),
          ),
        ],
      ),
    );
  }

  Future<void> _processPayment() async {
    Navigator.pop(context); // Close payment dialog
    
    try {
      // Process payment (integrate with Paystack or Flutterwave)
      // For now, simulate payment
      await Future.delayed(const Duration(seconds: 2));

      // Update payment status
      await FirebaseFirestore.instance
          .collection('jobs')
          .doc(widget.jobId)
          .update({
        'paymentStatus': 'paid',
        'paidAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        _showSuccessDialog();
      }
    } catch (e) {
      print('❌ Payment failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment failed: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Payment Successful! 🎉',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, color: AppColors.primary, size: 60),
            SizedBox(height: 16),
            Text('Your service has been completed successfully.'),
            Text(
              'Thank you for using G Wash NG!',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              // Navigate to rating screen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => RatingScreen(
                    jobId: widget.jobId,
                    washerId: _washerId ?? 'unknown',
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Rate Service'),
          ),
        ],
      ),
    );
  }

  void _callWasher() {
    // In production, use url_launcher to call
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Calling washer... (Feature coming soon)'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final isCancelled = _jobStatus == 'cancelled';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Your Washer'),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.black,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Map View
          Expanded(
            flex: 2,
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _clientLocation,
                    zoom: 14.5,
                  ),
                  markers: {
                    Marker(
                      markerId: const MarkerId('client'),
                      position: _clientLocation,
                      infoWindow: InfoWindow(title: 'Client Location', snippet: widget.pickupAddress),
                      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                    ),
                    Marker(
                      markerId: const MarkerId('provider'),
                      position: _providerLocation,
                      infoWindow: InfoWindow(title: 'Washer: ${widget.washerName}', snippet: '${_distanceKm.toStringAsFixed(1)} km away'),
                      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
                    ),
                  },
                  polylines: {
                    Polyline(
                      polylineId: const PolylineId('route'),
                      points: [_providerLocation, _clientLocation],
                      color: AppColors.primary,
                      width: 4,
                    ),
                  },
                  onMapCreated: (controller) => _mapController = controller,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                ),
                Positioned(
                  top: 12,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${_distanceKm.toStringAsFixed(1)} km away',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'ETA: $_etaMinutes mins',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Bottom Panel
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: isCancelled
                  ? _buildCancelledView()
                  : Column(
                      children: [
                        // Progress Steps
                        Row(
                          children: [
                            _buildProgressStep(0, 'Confirmed', _currentStep >= 0),
                            Expanded(child: _buildProgressLine(_currentStep >= 1)),
                            _buildProgressStep(1, 'En Route', _currentStep >= 1),
                            Expanded(child: _buildProgressLine(_currentStep >= 2)),
                            _buildProgressStep(2, 'Arrived', _currentStep >= 2),
                            Expanded(child: _buildProgressLine(_currentStep >= 3)),
                            _buildProgressStep(3, 'Completed', _currentStep >= 3),
                          ],
                        ),
                        const SizedBox(height: 24),
                        
                        // Washer Info
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.grey50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const CircleAvatar(
                                radius: 25,
                                backgroundColor: AppColors.primary,
                                child: Icon(Icons.person, color: Colors.white, size: 28),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.washerName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Row(
                                      children: [
                                        Icon(Icons.star, size: 14, color: Colors.amber),
                                        Icon(Icons.star, size: 14, color: Colors.amber),
                                        Icon(Icons.star, size: 14, color: Colors.amber),
                                        Icon(Icons.star, size: 14, color: Colors.amber),
                                        Icon(Icons.star_half, size: 14, color: Colors.amber),
                                        SizedBox(width: 4),
                                        Text('4.8 (156 reviews)', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: _currentStep >= 3 ? Colors.green.withOpacity(0.1) : AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  _currentStep >= 3 ? '✅ Done' : 'ETA: ${_etaMinutes} mins',
                                  style: TextStyle(
                                    color: _currentStep >= 3 ? Colors.green : AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Current Status
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.grey200),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _currentStep >= 3 ? Icons.check_circle : Icons.directions_car,
                                color: _currentStep >= 3 ? Colors.green : AppColors.primary,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Current Status',
                                      style: TextStyle(fontSize: 12, color: Colors.grey),
                                    ),
                                    Text(
                                      _currentLocation,
                                      style: const TextStyle(fontWeight: FontWeight.w500),
                                    ),
                                    if (_currentStep < 3)
                                      Text(
                                        'Estimated arrival in $_etaMinutes minutes',
                                        style: TextStyle(fontSize: 12, color: AppColors.grey600),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const Spacer(),
                        
                        // Action Buttons
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: _currentStep >= 3 || _isProcessing ? null : _callWasher,
                                icon: const Icon(Icons.phone, color: AppColors.primary),
                                label: const Text('Call Washer'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.primary,
                                  side: const BorderSide(color: AppColors.primary),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _currentStep >= 3
                                  ? ElevatedButton(
                                      onPressed: _isProcessing ? null : _confirmCompletion,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: _isProcessing
                                          ? const SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                              ),
                                            )
                                          : const Text('Confirm Complete'),
                                    )
                                  : ElevatedButton(
                                      onPressed: _isProcessing ? null : _cancelJob,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: _isProcessing
                                          ? const SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                              ),
                                            )
                                          : const Text('Cancel Request'),
                                    ),
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCancelledView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.cancel, size: 60, color: Colors.red),
          const SizedBox(height: 16),
          const Text(
            'Job Cancelled',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'This job has been cancelled',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressStep(int index, String label, bool isActive) {
    final icons = [Icons.check_circle, Icons.directions_car, Icons.location_on, Icons.done];
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? AppColors.primary : AppColors.grey300,
          ),
          child: Center(
            child: Icon(
              icons[index],
              size: 18,
              color: isActive ? Colors.white : AppColors.grey500,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isActive ? AppColors.primary : Colors.grey,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressLine(bool isActive) {
    return Container(
      height: 2,
      color: isActive ? AppColors.primary : AppColors.grey300,
    );
  }
}