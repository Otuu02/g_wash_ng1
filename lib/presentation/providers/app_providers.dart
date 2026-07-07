// FILE: lib/providers/app_providers.dart
// PURPOSE: Riverpod providers for the app

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ==================== SERVICE SELECTION PROVIDER ====================
final selectedServiceProvider = StateProvider<String>((ref) => 'Basic Wash');

// ==================== LOCATION PROVIDER ====================
final selectedLocationProvider = StateProvider<String>((ref) => 'Lekki, Lagos');

// ==================== SERVICES DATA PROVIDER ====================
final servicesProvider = Provider<Map<String, Map<String, dynamic>>>((ref) {
  return {
    'Basic Wash': {
      'price': 3000,
      'icon': Icons.cleaning_services,
      'duration': '30 mins',
    },
    'Interior': {
      'price': 5000,
      'icon': Icons.event_seat,
      'duration': '45 mins',
    },
    'Full Detail': {
      'price': 10000,
      'icon': Icons.star,
      'duration': '90 mins',
    },
  };
});

// ==================== SNACKBAR PROVIDER ====================
final snackBarProvider = Provider<void>((ref) {
  // This is just a placeholder, actual snackbar is handled in UI
  return null;
});

// ==================== NAVIGATION PROVIDER ====================
final navigationProvider = Provider((ref) {
  return NavigationService();
});

class NavigationService {
  void push(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
  
  void pushReplacement(BuildContext context, Widget page) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
  
  void pop(BuildContext context) {
    Navigator.pop(context);
  }
  
  void popToRoot(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }
}

// ==================== LOCATION OPTIONS PROVIDER ====================
final locationOptionsProvider = Provider<List<String>>((ref) {
  return [
    'Lekki, Lagos',
    'Victoria Island, Lagos',
    'Ikoyi, Lagos',
    'Surulere, Lagos',
    'GRA, Ikeja',
    'Magodo, Lagos',
    'Ajah, Lagos',
  ];
});