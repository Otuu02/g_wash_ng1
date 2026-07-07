// FILE: lib/core/utils/validators.dart
// PURPOSE: Input validation functions for forms

class Validators {
  Validators._();
  
  // ==================== PHONE VALIDATION ====================
  static String? phoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    
    final cleaned = value.replaceAll(RegExp(r'[^0-9]'), '');
    String number = cleaned;
    
    if (cleaned.startsWith('0')) {
      number = cleaned.substring(1);
    } else if (cleaned.startsWith('234')) {
      number = cleaned.substring(3);
    }
    
    if (number.length != 10) {
      return 'Enter a valid 10-digit Nigerian phone number';
    }
    
    if (!number.startsWith(RegExp(r'[789][01]'))) {
      return 'Enter a valid MTN, Glo, Airtel, or 9mobile number';
    }
    
    return null;
  }
  
  // ==================== EMAIL VALIDATION ====================
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    
    return null;
  }
  
  // ==================== PASSWORD VALIDATION ====================
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    
    if (value.length > 50) {
      return 'Password must be less than 50 characters';
    }
    
    return null;
  }
  
  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    
    if (value != password) {
      return 'Passwords do not match';
    }
    
    return null;
  }
  
  // ==================== NAME VALIDATION ====================
  static String? name(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    
    if (value.length > 50) {
      return 'Name must be less than 50 characters';
    }
    
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Name can only contain letters and spaces';
    }
    
    return null;
  }
  
  // ==================== ADDRESS VALIDATION ====================
  static String? address(String? value) {
    if (value == null || value.isEmpty) {
      return 'Address is required';
    }
    
    if (value.length < 5) {
      return 'Enter a complete address';
    }
    
    if (value.length > 200) {
      return 'Address is too long';
    }
    
    return null;
  }
  
  // ==================== OTP VALIDATION ====================
  static String? otp(String? value) {
    if (value == null || value.isEmpty) {
      return 'OTP is required';
    }
    
    if (value.length != 6) {
      return 'OTP must be 6 digits';
    }
    
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'OTP must contain only numbers';
    }
    
    return null;
  }
  
  // ==================== AMOUNT VALIDATION ====================
  static String? amount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Amount is required';
    }
    
    final amount = double.tryParse(value);
    if (amount == null) {
      return 'Enter a valid amount';
    }
    
    if (amount <= 0) {
      return 'Amount must be greater than 0';
    }
    
    if (amount > 1000000) {
      return 'Amount exceeds maximum allowed';
    }
    
    return null;
  }
  
  // ==================== RATING VALIDATION ====================
  static String? rating(int? value) {
    if (value == null) {
      return 'Please select a rating';
    }
    
    if (value < 1 || value > 5) {
      return 'Rating must be between 1 and 5';
    }
    
    return null;
  }
  
  // ==================== URL VALIDATION ====================
  static String? url(String? value) {
    if (value == null || value.isEmpty) {
      return null; // URL is optional
    }
    
    final urlRegex = RegExp(
      r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$',
    );
    
    if (!urlRegex.hasMatch(value)) {
      return 'Enter a valid URL';
    }
    
    return null;
  }
  
  // ==================== NOT EMPTY ====================
  static String? notEmpty(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }
  
  // ==================== MIN LENGTH ====================
  static String? minLength(String? value, int min, String fieldName) {
    if (value == null || value.length < min) {
      return '$fieldName must be at least $min characters';
    }
    return null;
  }
  
  // ==================== MAX LENGTH ====================
  static String? maxLength(String? value, int max, String fieldName) {
    if (value != null && value.length > max) {
      return '$fieldName must be less than $max characters';
    }
    return null;
  }
}