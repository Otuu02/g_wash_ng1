// FILE: lib/presentation/widgets/ad_banner_widget.dart
// PURPOSE: AdMob banner ad widget (currently disabled for demo)

import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class AdBannerWidget extends StatelessWidget {
  const AdBannerWidget({super.key});
  
  @override
  Widget build(BuildContext context) {
    // Ads are disabled for now - will be enabled when AdMob is configured
    return Container(
      height: 50,
      color: AppColors.grey100,
      child: const Center(
        child: Text(
          'Advertisement Space',
          style: TextStyle(color: AppColors.grey500),
        ),
      ),
    );
  }
}