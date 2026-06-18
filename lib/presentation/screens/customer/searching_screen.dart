// FILE: lib/presentation/screens/customer/searching_screen.dart
// PURPOSE: Shows loading animation while finding nearby washers

import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/helpers.dart';

class SearchingScreen extends StatefulWidget {
  const SearchingScreen({super.key});

  @override
  State<SearchingScreen> createState() => _SearchingScreenState();
}

class _SearchingScreenState extends State<SearchingScreen> {
  @override
  void initState() {
    super.initState();
    _simulateSearch();
  }

  void _simulateSearch() async {
    // Simulate searching for 5 seconds
    await Future.delayed(const Duration(seconds: 5));
    
    if (mounted) {
      // Show demo message
      Helpers.showSnackBar(
        context,
        message: 'Demo: No washers found. In production, this would find a washer.',
        isError: true,
        duration: const Duration(seconds: 3),
      );
      
      // Go back to home after demo
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(context, '/customer/home', (route) => false);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: AppColors.primary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Loading Animation
            SizedBox(
              height: 150,
              width: 150,
              child: CircularProgressIndicator(
                strokeWidth: 4,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
            const SizedBox(height: 30),
            
            // Title
            const Text(
              AppStrings.findingWasher,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            
            // Subtitle
            Text(
              'This may take 1-2 minutes',
              style: TextStyle(color: AppColors.grey600),
            ),
            const SizedBox(height: 40),
            
            // Cancel Button
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel Request',
                style: TextStyle(color: AppColors.error),
              ),
            ),
          ],
        ),
      ),
    );
  }
}