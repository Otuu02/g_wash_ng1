// FILE: lib/presentation/screens/washer/washer_profile_screen.dart
// PURPOSE: Washer profile management with Firebase integration
// UPDATED: Shows real data from Firestore including services

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../services/auth_service.dart';
import '../welcome_screen.dart';

class WasherProfileScreen extends StatefulWidget {
  const WasherProfileScreen({super.key});

  @override
  State<WasherProfileScreen> createState() => _WasherProfileScreenState();
}

class _WasherProfileScreenState extends State<WasherProfileScreen> {
  bool _isLoading = true;
  Map<String, dynamic> _washerData = {};
  String _washerId = '';

  // Service names mapping
  final Map<String, String> _serviceNames = {
    'car_wash': 'Car Washer',
    'cleaning': 'Cleaner',
    'laundry': 'Laundry',
  };

  final Map<String, IconData> _serviceIcons = {
    'car_wash': Icons.local_car_wash,
    'cleaning': Icons.cleaning_services,
    'laundry': Icons.local_laundry_service,
  };

  final Map<String, Color> _serviceColors = {
    'car_wash': const Color(0xFF0CAF60),
    'cleaning': Colors.blue,
    'laundry': const Color(0xFF9C27B0),
  };

  @override
  void initState() {
    super.initState();
    _loadWasherData();
  }

  Future<void> _loadWasherData() async {
    setState(() => _isLoading = true);

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final userId = authService.getCurrentUserId();

      if (userId == null) {
        setState(() => _isLoading = false);
        return;
      }

      final query = await FirebaseFirestore.instance
          .collection('washers')
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        final doc = query.docs.first;
        _washerId = doc.id;
        setState(() {
          _washerData = doc.data();
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print('❌ Error loading washer data: $e');
      setState(() => _isLoading = false);
    }
  }

  String _getServiceDisplayName(String serviceId) {
    return _serviceNames[serviceId] ?? serviceId;
  }

  void _showInfoDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Close',
              style: TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Extract data from Firestore
    final name = _washerData['name'] ?? authService.userName ?? 'Washer Name';
    final phone = _washerData['phone'] ?? authService.userPhone ?? '+234 801 234 5678';
    final email = _washerData['email'] ?? 'Not provided';
    final city = _washerData['city'] ?? 'Not set';
    final state = _washerData['state'] ?? 'Not set';
    final rating = _washerData['rating'] ?? 0.0;
    final totalJobs = _washerData['totalJobs'] ?? 0;
    final totalEarnings = _washerData['totalEarnings'] ?? 0;
    final isOnline = _washerData['isOnline'] ?? false;
    final isApproved = _washerData['approved'] ?? false;
    final vehicleType = _washerData['vehicleType'] ?? 'Not set';
    final workingRadius = _washerData['workingRadius'] ?? 10;
    final bankName = _washerData['bankName'] ?? 'Not set';
    final accountNumber = _washerData['accountNumber'] ?? 'Not set';
    final accountName = _washerData['accountName'] ?? 'Not set';
    final specialization = _washerData['specialization'] ?? 'Not set';
    final turnaroundTime = _washerData['turnaroundTime'] ?? 'Not set';
    
    // Get selected services
    final selectedServices = List<String>.from(_washerData['selectedServices'] ?? []);
    final serviceDisplayNames = selectedServices.map((id) => _serviceNames[id] ?? id).join(', ');

    // Format date
    String createdAt = 'Not available';
    if (_washerData['createdAt'] != null) {
      try {
        final date = (_washerData['createdAt'] as Timestamp).toDate();
        createdAt = DateFormat('MMM dd, yyyy').format(date);
      } catch (e) {
        createdAt = 'Not available';
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.primary),
            onPressed: _loadWasherData,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadWasherData,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile Header
              Container(
                padding: const EdgeInsets.all(24),
                color: AppColors.primaryBackground,
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          name.isNotEmpty ? name[0].toUpperCase() : 'W',
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      name,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      phone,
                      style: TextStyle(color: AppColors.grey600),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: isApproved ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isApproved ? Icons.verified : Icons.pending,
                                size: 14,
                                color: isApproved ? Colors.green : Colors.orange,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                isApproved ? 'Verified' : 'Pending Approval',
                                style: TextStyle(
                                  color: isApproved ? Colors.green : Colors.orange,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: isOnline ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isOnline ? Icons.wifi : Icons.wifi_off,
                                size: 14,
                                color: isOnline ? Colors.green : Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                isOnline ? 'Online' : 'Offline',
                                style: TextStyle(
                                  color: isOnline ? Colors.green : Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, size: 14, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            rating > 0 ? '${rating.toStringAsFixed(1)} ★' : 'No ratings yet',
                            style: const TextStyle(
                              color: Colors.amber,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Service chips
                    if (selectedServices.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 4,
                        children: selectedServices.map((serviceId) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _serviceColors[serviceId]?.withOpacity(0.1) ?? AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _serviceColors[serviceId] ?? AppColors.primary,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _serviceIcons[serviceId] ?? Icons.work,
                                  size: 12,
                                  color: _serviceColors[serviceId] ?? AppColors.primary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _serviceNames[serviceId] ?? serviceId,
                                  style: TextStyle(
                                    color: _serviceColors[serviceId] ?? AppColors.primary,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),

              // Location Info
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, color: AppColors.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Location',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Text(
                            city != 'Not set' ? '$city, $state' : 'Location not set',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Stats
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(totalJobs.toString(), 'Jobs'),
                    Container(width: 1, height: 40, color: AppColors.grey300),
                    _buildStatItem('₦${NumberFormat('#,###').format(totalEarnings)}', 'Earnings'),
                    Container(width: 1, height: 40, color: AppColors.grey300),
                    _buildStatItem('${totalJobs > 0 ? ((totalJobs - 0) / totalJobs * 100).toStringAsFixed(0) : 0}%', 'Completion'),
                  ],
                ),
              ),

              // ============================================================
              // REAL DATA MENU ITEMS
              // ============================================================

              // Personal Information - Shows real data
              _buildMenuItem(
                icon: Icons.person_outline,
                title: 'Personal Information',
                subtitle: '$name · $email',
                onTap: () {
                  _showInfoDialog(
                    'Personal Information',
                    'Name: $name\nPhone: $phone\nEmail: $email\nLocation: $city, $state\nJoined: $createdAt',
                  );
                },
              ),

              // Services - Shows selected services
              _buildMenuItem(
                icon: Icons.verified,
                title: 'Services',
                subtitle: serviceDisplayNames.isNotEmpty ? serviceDisplayNames : 'No services selected',
                onTap: () {
                  _showInfoDialog(
                    'Your Services',
                    serviceDisplayNames.isNotEmpty 
                        ? 'Services: $serviceDisplayNames'
                        : 'No services selected yet.\nPlease update your profile.',
                  );
                },
              ),

              // Vehicle Details - Shows real data
              _buildMenuItem(
                icon: Icons.directions_car,
                title: 'Vehicle Details',
                subtitle: 'Vehicle: $vehicleType',
                onTap: () {
                  _showInfoDialog(
                    'Vehicle Details',
                    'Vehicle Type: $vehicleType\nWorking Radius: $workingRadius km',
                  );
                },
              ),

              // Bank Account - Shows real data
              _buildMenuItem(
                icon: Icons.credit_card,
                title: 'Bank Account',
                subtitle: bankName != 'Not set' ? '$bankName · $accountName' : 'No bank account set',
                onTap: () {
                  _showInfoDialog(
                    'Bank Account',
                    'Bank: $bankName\nAccount Name: $accountName\nAccount Number: $accountNumber',
                  );
                },
              ),

              // Specialization (if cleaner)
              if (_washerData['specialization'] != null) 
                _buildMenuItem(
                  icon: Icons.brush,
                  title: 'Specialization',
                  subtitle: 'Cleaning: $specialization',
                  onTap: () {
                    _showInfoDialog(
                      'Cleaning Specialization',
                      'Specialization: $specialization\nTools: ${(_washerData['cleaningTools'] as List?)?.join(', ') ?? 'Not specified'}',
                    );
                  },
                ),

              // Turnaround Time (if laundry)
              if (_washerData['turnaroundTime'] != null)
                _buildMenuItem(
                  icon: Icons.timer,
                  title: 'Turnaround Time',
                  subtitle: 'Laundry: $turnaroundTime',
                  onTap: () {
                    _showInfoDialog(
                      'Laundry Turnaround',
                      'Turnaround Time: $turnaroundTime',
                    );
                  },
                ),

              // Working Radius - Shows real data
              _buildMenuItem(
                icon: Icons.speed,
                title: 'Working Radius',
                subtitle: 'Current radius: $workingRadius km',
                onTap: () {
                  _showInfoDialog(
                    'Working Radius',
                    'You serve customers within $workingRadius km radius.',
                  );
                },
              ),

              const Divider(),

              // Job History
              _buildMenuItem(
                icon: Icons.history,
                title: 'Job History',
                subtitle: 'View all completed jobs',
                onTap: () {
                  // Navigate to job history
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Job history coming soon')),
                  );
                },
              ),

              // Help & Support
              _buildMenuItem(
                icon: Icons.help_outline,
                title: 'Help & Support',
                subtitle: 'Get help or contact support',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Help & Support coming soon')),
                  );
                },
              ),

              const Divider(),

              // Logout
              _buildMenuItem(
                icon: Icons.logout,
                title: 'Logout',
                subtitle: 'Sign out of your account',
                isDestructive: true,
                onTap: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      title: const Text(
                        'Logout',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      content: const Text('Are you sure you want to logout?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: AppColors.primary),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context, true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Logout'),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true && context.mounted) {
                    await authService.logout();
                    if (context.mounted) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                        (route) => false,
                      );
                    }
                  }
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: AppColors.grey600, fontSize: 12)),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(icon, color: isDestructive ? Colors.red : AppColors.primary),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? Colors.red : Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: AppColors.grey600,
          fontSize: 12,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, size: 20, color: AppColors.grey400),
      onTap: onTap,
    );
  }
}