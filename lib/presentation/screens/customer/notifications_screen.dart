// FILE: notifications_screen.dart
// PURPOSE: Manage notification preferences

import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/helpers.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _smsNotifications = false;
  bool _promotionalOffers = true;
  bool _orderUpdates = true;
  bool _washerArrival = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          _buildSwitchTile(
            title: 'Push Notifications',
            subtitle: 'Receive notifications on your device',
            value: _pushNotifications,
            onChanged: (value) {
              setState(() => _pushNotifications = value);
              _saveSettings();
            },
          ),
          _buildSwitchTile(
            title: 'Email Notifications',
            subtitle: 'Receive updates via email',
            value: _emailNotifications,
            onChanged: (value) {
              setState(() => _emailNotifications = value);
              _saveSettings();
            },
          ),
          _buildSwitchTile(
            title: 'SMS Notifications',
            subtitle: 'Receive text message alerts',
            value: _smsNotifications,
            onChanged: (value) {
              setState(() => _smsNotifications = value);
              _saveSettings();
            },
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Notification Types',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          _buildSwitchTile(
            title: 'Promotional Offers',
            subtitle: 'Get updates on discounts and offers',
            value: _promotionalOffers,
            onChanged: (value) {
              setState(() => _promotionalOffers = value);
              _saveSettings();
            },
          ),
          _buildSwitchTile(
            title: 'Order Updates',
            subtitle: 'Receive order status updates',
            value: _orderUpdates,
            onChanged: (value) {
              setState(() => _orderUpdates = value);
              _saveSettings();
            },
          ),
          _buildSwitchTile(
            title: 'Washer Arrival',
            subtitle: 'Get notified when washer is arriving',
            value: _washerArrival,
            onChanged: (value) {
              setState(() => _washerArrival = value);
              _saveSettings();
            },
          ),
          const SizedBox(height: 30),
          Center(
            child: TextButton(
              onPressed: () {
                setState(() {
                  _pushNotifications = true;
                  _emailNotifications = true;
                  _smsNotifications = false;
                  _promotionalOffers = true;
                  _orderUpdates = true;
                  _washerArrival = true;
                });
                _saveSettings();
                Helpers.showSnackBar(
                  context,
                  message: 'Settings reset to default',
                  isSuccess: true,
                );
              },
              child: const Text('Reset to Default'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return SwitchListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle, style: TextStyle(color: AppColors.grey600, fontSize: 12)),
      value: value,
      onChanged: onChanged,
      activeColor: AppColors.primary,
    );
  }

  void _saveSettings() {
    // Save to SharedPreferences here
    Helpers.showSnackBar(
      context,
      message: 'Settings saved',
      isSuccess: true,
      duration: const Duration(seconds: 1),
    );
  }
}