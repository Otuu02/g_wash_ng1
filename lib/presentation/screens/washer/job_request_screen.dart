// FILE: lib/presentation/screens/washer/job_request_screen.dart
// PURPOSE: Display and manage incoming job requests

import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import 'navigation_screen.dart';

class JobRequestScreen extends StatefulWidget {
  const JobRequestScreen({super.key});

  @override
  State<JobRequestScreen> createState() => _JobRequestScreenState();
}

class _JobRequestScreenState extends State<JobRequestScreen> {
  final List<Map<String, dynamic>> _pendingJobs = [
    {
      'id': 'JOB-001',
      'service': 'Full Detailing',
      'price': 10000,
      'customerName': 'David O.',
      'customerPhone': '+234 802 345 6789',
      'address': '12, Lekki Phase 1, Lagos',
      'distance': 2.5,
      'time': '10:30 AM',
      'date': 'Today',
      'duration': '90 mins',
    },
    {
      'id': 'JOB-002',
      'service': 'Exterior Wash',
      'price': 3000,
      'customerName': 'Sarah A.',
      'customerPhone': '+234 803 456 7890',
      'address': '45, Victoria Island, Lagos',
      'distance': 4.2,
      'time': '2:00 PM',
      'date': 'Today',
      'duration': '30 mins',
    },
  ];

  final List<Map<String, dynamic>> _acceptedJobs = [
    {
      'id': 'JOB-003',
      'service': 'Interior Cleaning',
      'price': 5000,
      'customerName': 'John M.',
      'customerPhone': '+234 804 567 8901',
      'address': '78, Ikoyi, Lagos',
      'status': 'En Route',
      'eta': '15 min',
    },
  ];

  int _selectedTab = 0;

  void _acceptJob(Map<String, dynamic> job) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Accept Job'),
        content: Text('Accept ${job['service']} for ₦${job['price']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Decline'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NavigationScreen(
                    jobId: job['id'],
                    destination: job['address'],
                  ),
                ),
              );
            },
            child: const Text('Accept'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Requests'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        bottom: TabBar(
          // FIXED: Removed 'const' keyword to allow dynamic text
          tabs: [
            Tab(text: 'Pending (${_pendingJobs.length})'),
            Tab(text: 'Active (${_acceptedJobs.length})'),
          ],
          onTap: (index) => setState(() => _selectedTab = index),
          indicatorColor: Colors.white,
        ),
      ),
      body: _selectedTab == 0
          ? _pendingJobs.isEmpty
              ? _buildEmptyState('No pending jobs', 'Check back later for new requests')
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _pendingJobs.length,
                  itemBuilder: (context, index) => _buildJobCard(_pendingJobs[index]),
                )
          : _acceptedJobs.isEmpty
              ? _buildEmptyState('No active jobs', 'Your accepted jobs will appear here')
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _acceptedJobs.length,
                  itemBuilder: (context, index) => _buildActiveJobCard(_acceptedJobs[index]),
                ),
    );
  }

  Widget _buildJobCard(Map<String, dynamic> job) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBackground,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    job['service'],
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ),
                Text(
                  '₦${job['price']}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.person, size: 16, color: AppColors.grey600),
                const SizedBox(width: 8),
                Text(job['customerName']),
                const SizedBox(width: 16),
                const Icon(Icons.phone, size: 16, color: AppColors.grey600),
                const SizedBox(width: 8),
                Text(job['customerPhone']),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: AppColors.grey600),
                const SizedBox(width: 8),
                Expanded(child: Text(job['address'], style: const TextStyle(fontSize: 14))),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.timer, size: 16, color: AppColors.grey600),
                const SizedBox(width: 8),
                Text('${job['date']} at ${job['time']} • ${job['duration']}'),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${job['distance']} km away',
                    style: TextStyle(color: Colors.blue, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.error),
                      foregroundColor: AppColors.error,
                    ),
                    child: const Text('Decline'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _acceptJob(job),
                    child: const Text('Accept'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveJobCard(Map<String, dynamic> job) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    job['service'],
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.green),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.timer, size: 14, color: Colors.orange),
                      const SizedBox(width: 4),
                      Text(
                        'ETA: ${job['eta']}',
                        style: TextStyle(color: Colors.orange, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.person, size: 16, color: AppColors.grey600),
                const SizedBox(width: 8),
                Text(job['customerName']),
                const SizedBox(width: 16),
                const Icon(Icons.phone, size: 16, color: AppColors.grey600),
                const SizedBox(width: 8),
                Text(job['customerPhone']),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: AppColors.grey600),
                const SizedBox(width: 8),
                Expanded(child: Text(job['address'], style: const TextStyle(fontSize: 14))),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NavigationScreen(
                        jobId: job['id'],
                        destination: job['address'],
                      ),
                    ),
                  );
                },
                child: const Text('Navigate'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String title, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox, size: 80, color: AppColors.grey400),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(color: AppColors.grey600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}