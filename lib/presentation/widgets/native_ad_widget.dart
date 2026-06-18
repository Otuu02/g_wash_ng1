// FILE: lib/presentation/widgets/native_ad_widget.dart
// PURPOSE: Native ad widget (currently disabled for demo)

import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class NativeAdWidget extends StatelessWidget {
  const NativeAdWidget({super.key});
  
  @override
  Widget build(BuildContext context) {
    // Native ads are disabled for now
    return Container(
      height: 100,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Text(
          'Native Advertisement',
          style: TextStyle(color: AppColors.grey500),
        ),
      ),
    );
  }
}