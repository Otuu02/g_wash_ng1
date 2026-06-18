// FILE: lib/core/routes/route_generator.dart
// PURPOSE: Generates routes for the app with proper navigation

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/screens/splash_screen.dart';
import '../../presentation/screens/onboarding_screen.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/otp_screen.dart';
import '../../presentation/screens/auth/role_selection_screen.dart';
import '../../presentation/screens/customer/home_screen.dart';
import '../../presentation/screens/customer/map_screen.dart';
import '../../presentation/screens/customer/searching_screen.dart';
import '../../presentation/screens/customer/assigned_screen.dart';
import '../../presentation/screens/customer/payment_screen.dart';
import '../../presentation/screens/customer/rating_screen.dart';
import '../../presentation/screens/customer/order_history_screen.dart';
import '../../presentation/screens/customer/profile_screen.dart';
import '../../presentation/screens/washer/washer_dashboard.dart';
import '../../presentation/screens/washer/registration_screen.dart';
import '../../presentation/screens/washer/subscription_screen.dart';
import '../../presentation/screens/washer/job_request_screen.dart';
import '../../presentation/screens/washer/navigation_screen.dart';
import '../../presentation/screens/washer/earnings_screen.dart';
import 'app_routes.dart';

class RouteGenerator {
  RouteGenerator._();
  
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: false,
    routes: [
      // ==================== AUTH ROUTES ====================
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.otp,
        name: 'otp',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return OTPScreen(
            verificationId: extra?['verificationId'] ?? '',
            phoneNumber: extra?['phoneNumber'] ?? '',
          );
        },
      ),
      GoRoute(
        path: AppRoutes.roleSelection,
        name: 'roleSelection',
        builder: (context, state) => const RoleSelectionScreen(),
      ),
      
      // ==================== CUSTOMER ROUTES ====================
      GoRoute(
        path: AppRoutes.customerHome,
        name: 'customerHome',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.customerMap,
        name: 'customerMap',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return MapScreen(
            serviceType: extra['serviceType'],
            price: extra['price'],
            address: extra['address'],
          );
        },
      ),
      GoRoute(
        path: AppRoutes.customerSearching,
        name: 'customerSearching',
        builder: (context, state) {
          final jobId = state.extra as String;
          return SearchingScreen(jobId: jobId);
        },
      ),
      GoRoute(
        path: AppRoutes.customerAssigned,
        name: 'customerAssigned',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return AssignedScreen(
            jobId: extra['jobId'],
            washerId: extra['washerId'],
          );
        },
      ),
      GoRoute(
        path: AppRoutes.customerPayment,
        name: 'customerPayment',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return PaymentScreen(
            jobId: extra['jobId'],
            amount: extra['amount'],
            washerId: extra['washerId'],
          );
        },
      ),
      GoRoute(
        path: AppRoutes.customerRating,
        name: 'customerRating',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return RatingScreen(
            jobId: extra['jobId'],
            washerId: extra['washerId'],
          );
        },
      ),
      GoRoute(
        path: AppRoutes.customerOrderHistory,
        name: 'customerOrderHistory',
        builder: (context, state) => const OrderHistoryScreen(),
      ),
      GoRoute(
        path: AppRoutes.customerProfile,
        name: 'customerProfile',
        builder: (context, state) => const ProfileScreen(),
      ),
      
      // ==================== WASHER ROUTES ====================
      GoRoute(
        path: AppRoutes.washerRegistration,
        name: 'washerRegistration',
        builder: (context, state) => const WasherRegistrationScreen(),
      ),
      GoRoute(
        path: AppRoutes.washerDashboard,
        name: 'washerDashboard',
        builder: (context, state) => const WasherDashboard(),
      ),
      GoRoute(
        path: AppRoutes.washerSubscription,
        name: 'washerSubscription',
        builder: (context, state) => const SubscriptionScreen(),
      ),
      GoRoute(
        path: AppRoutes.washerJobRequest,
        name: 'washerJobRequest',
        builder: (context, state) {
          final jobId = state.extra as String;
          return JobRequestScreen(jobId: jobId);
        },
      ),
      GoRoute(
        path: AppRoutes.washerNavigation,
        name: 'washerNavigation',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return NavigationScreen(
            jobId: extra['jobId'],
            destination: extra['destination'],
          );
        },
      ),
      GoRoute(
        path: AppRoutes.washerEarnings,
        name: 'washerEarnings',
        builder: (context, state) => const EarningsScreen(),
      ),
      
      // ==================== REDIRECTS ====================
      GoRoute(
        path: '/home',
        redirect: (context, state) => AppRoutes.customerHome,
      ),
    ],
  );
}