// FILE: lib/core/utils/formatters.dart
// PURPOSE: Formatting functions for consistent data display

import 'package:intl/intl.dart';

class Formatters {
  Formatters._();
  
  // ==================== DATE FORMATTERS ====================
  static String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }
  
  static String formatDateLong(DateTime date) {
    return DateFormat('EEEE, dd MMMM yyyy').format(date);
  }
  
  static String formatDateTime(DateTime date) {
    return DateFormat('dd MMM yyyy, hh:mm a').format(date);
  }
  
  static String formatTime(DateTime date) {
    return DateFormat('hh:mm a').format(date);
  }
  
  static String formatRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 30) {
      return formatDate(date);
    } else if (difference.inDays > 7) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks week${weeks == 1 ? '' : 's'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }
  
  // ==================== CURRENCY FORMATTERS ====================
  static String formatCurrency(int amount) {
    final formatter = NumberFormat.currency(
      symbol: '₦',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }
  
  static String formatCurrencyDouble(double amount) {
    final formatter = NumberFormat.currency(
      symbol: '₦',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }
  
  static String formatCurrencyWithDecimal(double amount) {
    final formatter = NumberFormat.currency(
      symbol: '₦',
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }
  
  // ==================== PHONE FORMATTERS ====================
  static String formatPhoneNumber(String phone) {
    // Remove all non-digits
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    
    if (digits.length == 11 && digits.startsWith('0')) {
      // Local format: 08012345678 -> 080 123 4567 8
      return '${digits.substring(0, 3)} ${digits.substring(3, 6)} ${digits.substring(6, 10)} ${digits.substring(10)}';
    } else if (digits.length == 13 && digits.startsWith('234')) {
      // International format: 2348012345678 -> +234 801 234 5678
      final local = digits.substring(3);
      return '+234 ${local.substring(0, 3)} ${local.substring(3, 6)} ${local.substring(6)}';
    } else if (digits.length == 10) {
      // Without prefix: 8012345678 -> 080 123 4567 8
      return '0${digits.substring(0, 2)} ${digits.substring(2, 5)} ${digits.substring(5, 8)} ${digits.substring(8)}';
    }
    
    return phone;
  }
  
  static String formatPhoneNumberSimple(String phone) {
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    
    if (digits.length == 11 && digits.startsWith('0')) {
      return '+234${digits.substring(1)}';
    } else if (digits.length == 10) {
      return '+234$digits';
    }
    
    return phone;
  }
  
  // ==================== NUMBER FORMATTERS ====================
  static String formatNumber(int number) {
    return NumberFormat('#,###').format(number);
  }
  
  static String formatDouble(double number, {int decimalPlaces = 2}) {
    return NumberFormat('#,###.${'0' * decimalPlaces}').format(number);
  }
  
  static String formatCompactNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
  
  // ==================== DURATION FORMATTERS ====================
  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    
    if (hours > 0) {
      return '$hours hr ${minutes > 0 ? '$minutes min' : ''}';
    } else if (minutes > 0) {
      return '$minutes min';
    } else {
      return 'Less than a minute';
    }
  }
  
  static String formatDurationMinutes(int minutes) {
    if (minutes >= 60) {
      final hours = minutes ~/ 60;
      final remainingMinutes = minutes % 60;
      return '$hours hr ${remainingMinutes > 0 ? '$remainingMinutes min' : ''}';
    }
    return '$minutes min';
  }
  
  // ==================== DISTANCE FORMATTERS ====================
  static String formatDistance(double kilometers) {
    if (kilometers < 1) {
      final meters = (kilometers * 1000).round();
      return '${meters}m';
    }
    return '${kilometers.toStringAsFixed(1)}km';
  }
  
  // ==================== PERCENTAGE FORMATTERS ====================
  static String formatPercentage(double value) {
    return '${(value * 100).toStringAsFixed(0)}%';
  }
  
  static String formatPercentageWithDecimal(double value, {int decimals = 1}) {
    return '${(value * 100).toStringAsFixed(decimals)}%';
  }
  
  // ==================== TRUNCATION ====================
  static String truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength - 3)}...';
  }
  
  // ==================== CAPITALIZATION ====================
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return '${text[0].toUpperCase()}${text.substring(1).toLowerCase()}';
  }
  
  static String capitalizeWords(String text) {
    return text.split(' ').map((word) => capitalize(word)).join(' ');
  }
  
  static String sentenceCase(String text) {
    if (text.isEmpty) return text;
    return '${text[0].toUpperCase()}${text.substring(1).toLowerCase()}';
  }
}