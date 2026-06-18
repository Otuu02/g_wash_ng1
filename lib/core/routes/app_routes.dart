// FILE: lib/core/routes/app_routes.dart
// PURPOSE: Defines all route names and navigation configuration

class AppRoutes {
  AppRoutes._();
  
  // ==================== AUTH ROUTES ====================
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String otp = '/otp';
  static const String roleSelection = '/role-selection';
  
  // ==================== CUSTOMER ROUTES ====================
  static const String customerHome = '/customer/home';
  static const String customerMap = '/customer/map';
  static const String customerSearching = '/customer/searching';
  static const String customerAssigned = '/customer/assigned';
  static const String customerPayment = '/customer/payment';
  static const String customerRating = '/customer/rating';
  static const String customerOrderHistory = '/customer/order-history';
  static const String customerProfile = '/customer/profile';
  static const String customerSavedAddresses = '/customer/saved-addresses';
  static const String customerPaymentMethods = '/customer/payment-methods';
  
  // ==================== WASHER ROUTES ====================
  static const String washerRegistration = '/washer/register';
  static const String washerDashboard = '/washer/dashboard';
  static const String washerSubscription = '/washer/subscription';
  static const String washerJobRequest = '/washer/job-request';
  static const String washerNavigation = '/washer/navigation';
  static const String washerEarnings = '/washer/earnings';
  static const String washerProfile = '/washer/profile';
  
  // ==================== ADMIN ROUTES ====================
  static const String adminDashboard = '/admin/dashboard';
  static const String adminUsers = '/admin/users';
  static const String adminWashers = '/admin/washers';
  static const String adminJobs = '/admin/jobs';
  static const String adminTransactions = '/admin/transactions';
  static const String adminSettings = '/admin/settings';
  
  // ==================== COMMON ROUTES ====================
  static const String settings = '/settings';
  static const String notifications = '/notifications';
  static const String help = '/help';
  static const String about = '/about';
  static const String privacyPolicy = '/privacy-policy';
  static const String termsOfService = '/terms-of-service';
}