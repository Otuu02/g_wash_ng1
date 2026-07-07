// FILE: lib/core/constants/app_colors.dart
// PURPOSE: Defines all colors used in the app for consistent branding

import 'package:flutter/material.dart';

class AppColors {
  AppColors._();
  
  // ==================== PRIMARY COLORS ====================
  /// Nigerian Green - Main brand color
  static const Color primary = Color(0xFF0CAF60);
  static const Color primaryDark = Color(0xFF0A8E4F);
  static const Color primaryLight = Color(0xFF4CDB8C);
  static const Color primaryBackground = Color(0xFFE8F5E9);
  static const Color primaryGradientStart = Color(0xFF0CAF60);
  static const Color primaryGradientEnd = Color(0xFF0A8E4F);
  
  // ==================== SECONDARY COLORS ====================
  /// Orange - For warnings and attention-grabbing elements
  static const Color secondary = Color(0xFFFFA000);
  static const Color secondaryDark = Color(0xFFE57E00);
  static const Color secondaryLight = Color(0xFFFFC107);
  
  /// Deep Blue - For accents
  static const Color accent = Color(0xFF1A237E);
  static const Color accentDark = Color(0xFF0D174A);
  
  // ==================== NEUTRAL COLORS ====================
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);
  
  // ==================== SEMANTIC COLORS ====================
  static const Color success = Color(0xFF4CAF50);
  static const Color successDark = Color(0xFF388E3C);
  static const Color successLight = Color(0xFF81C784);
  
  static const Color error = Color(0xFFE53935);
  static const Color errorDark = Color(0xFFC62828);
  static const Color errorLight = Color(0xFFEF5350);
  
  static const Color warning = Color(0xFFFFC107);
  static const Color warningDark = Color(0xFFFF8F00);
  static const Color warningLight = Color(0xFFFFD54F);
  
  static const Color info = Color(0xFF2196F3);
  static const Color infoDark = Color(0xFF1976D2);
  static const Color infoLight = Color(0xFF64B5F6);
  
  // ==================== GRADIENTS ====================
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDark],
  );
  
  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [success, successDark],
  );
  
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.transparent, Colors.black26],
  );
  
  // ==================== SHADOWS ====================
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];
  
  static List<BoxShadow> get buttonShadow => [
    BoxShadow(
      color: primary.withOpacity(0.4),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];
  
  static List<BoxShadow> get smallShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];
}