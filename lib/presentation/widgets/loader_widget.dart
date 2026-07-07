// FILE: lib/presentation/widgets/loader_widget.dart
// PURPOSE: Reusable loading indicator widget

import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class LoaderWidget extends StatelessWidget {
  final String? message;
  final Color? color;
  
  const LoaderWidget({super.key, this.message, this.color});
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(color ?? AppColors.primary),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: TextStyle(
                color: color ?? AppColors.primary,
                fontSize: 14,
              ),
            ),
          ],
        ],
      ),
    );
  }
}