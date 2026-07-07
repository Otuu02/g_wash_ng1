// FILE: lib/presentation/screens/washer/navigation_screen.dart
// PURPOSE: Navigation screen for washers to reach customer location

import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class NavigationScreen extends StatefulWidget {
  final String jobId;
  final String destination;

  const NavigationScreen({
    super.key,
    required this.jobId,
    required this.destination,
  });

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  bool _isArrived = false;

  void _markArrived() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Arrived at Location'),
        content: const Text('Have you arrived at the customer\'s location?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Not yet'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _isArrived = true);
              _showServiceOptions();
            },
            child: const Text('Yes, Arrived'),
          ),
        ],
      ),
    );
  }

  void _showServiceOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Start Service',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('Take a photo of the car before starting?'),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Skip'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _startService();
                    },
                    child: const Text('Take Photo'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _startService() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Service Started'),
        content: const Text('You are now washing the customer\'s car.'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _completeService();
            },
            child: const Text('Complete Service'),
          ),
        ],
      ),
    );
  }

  void _completeService() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Complete Service'),
        content: const Text('Has the service been completed successfully?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Not yet'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showPaymentConfirmation();
            },
            child: const Text('Yes, Complete'),
          ),
        ],
      ),
    );
  }

  void _showPaymentConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Payment Confirmed'),
        content: const Text('Payment has been processed successfully.'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/washer-dashboard');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Job completed successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigation'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          if (!_isArrived)
            IconButton(
              icon: const Icon(Icons.my_location),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening Google Maps...')),
                );
              },
            ),
        ],
      ),
      body: Stack(
        children: [
          // Map Placeholder
          Container(
            color: Colors.grey.shade300,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.map, size: 80, color: Colors.grey.shade500),
                  const SizedBox(height: 16),
                  const Text('Google Maps will appear here'),
                  const SizedBox(height: 8),
                  Text(
                    'Destination: ${widget.destination}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          
          // Bottom Sheet
          DraggableScrollableSheet(
            initialChildSize: 0.3,
            minChildSize: 0.2,
            maxChildSize: 0.5,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Job Info
                        const Text(
                          'Job Information',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow('Job ID', widget.jobId),
                        _buildInfoRow('Destination', widget.destination),
                        _buildInfoRow('Distance', '2.5 km'),
                        _buildInfoRow('ETA', '15 minutes'),
                        
                        const Divider(),
                        
                        // Arrival Button
                        if (!_isArrived)
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _markArrived,
                              child: const Text('I\'ve Arrived'),
                            ),
                          ),
                        
                        if (_isArrived)
                          Column(
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.check_circle, color: Colors.green),
                                  SizedBox(width: 8),
                                  Text('Arrived at location'),
                                ],
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: _startService,
                                  child: const Text('Start Service'),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: TextStyle(color: AppColors.grey600)),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }
}