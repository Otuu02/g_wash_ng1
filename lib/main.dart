import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as provider;
import 'package:google_maps_flutter/google_maps_flutter.dart';

// Customer Screens
import 'presentation/screens/customer/home_screen.dart';
import 'presentation/screens/customer/booking_screen.dart';
import 'presentation/screens/customer/my_bookings_screen.dart';
import 'presentation/screens/customer/profile_screen.dart';
import 'presentation/screens/customer/location_search_screen.dart';
import 'presentation/screens/customer/saved_addresses_screen.dart';
import 'presentation/screens/customer/payment_methods_screen.dart';
import 'presentation/screens/customer/notifications_screen.dart';
import 'presentation/screens/customer/privacy_security_screen.dart';
import 'presentation/screens/customer/help_support_screen.dart';
import 'presentation/screens/customer/order_details_screen.dart';
import 'presentation/screens/customer/tracking_screen.dart';
import 'presentation/screens/customer/rating_screen.dart';

// Washer Screens
import 'presentation/screens/washer/washer_dashboard.dart';
import 'presentation/screens/washer/washer_registration_screen.dart';
import 'presentation/screens/washer/job_request_screen.dart';
import 'presentation/screens/washer/earnings_screen.dart';
import 'presentation/screens/washer/washer_profile_screen.dart';
import 'presentation/screens/washer/subscription_screen.dart';

// Auth & Welcome
import 'presentation/screens/welcome_screen.dart';
import 'presentation/screens/auth/login_screen.dart';
import 'presentation/screens/auth/otp_screen.dart';

// Services
import 'services/auth_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(
    provider.MultiProvider(
      providers: [
        provider.ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: const ProviderScope(
        child: GWashApp(),
      ),
    ),
  );
}

class GWashApp extends StatelessWidget {
  const GWashApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = provider.Provider.of<AuthService>(context);
    
    return MaterialApp(
      title: 'G Wash NG',
      debugShowCheckedModeBanner: false,
      
      theme: ThemeData(
        primaryColor: const Color(0xFF0CAF60),
        scaffoldBackgroundColor: Colors.white,
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF0CAF60),
          secondary: Color(0xFF0A8E4F),
          surface: Colors.white,
          error: Colors.red,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF0CAF60),
          elevation: 0,
          centerTitle: false,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0CAF60),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        useMaterial3: true,
      ),
      
      home: authService.isLoggedIn ? const HomeScreen() : const WelcomeScreen(),
      
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/booking': (context) => const BookingScreen(),
        '/my-bookings': (context) => const MyBookingsScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/location-search': (context) => const LocationSearchScreen(),
        '/saved-addresses': (context) => const SavedAddressesScreen(),
        '/payment-methods': (context) => const PaymentMethodsScreen(),
        '/notifications': (context) => const NotificationsScreen(),
        '/privacy-security': (context) => const PrivacySecurityScreen(),
        '/help-support': (context) => const HelpSupportScreen(),
        '/washer-registration': (context) => const WasherRegistrationScreen(),
        '/washer-dashboard': (context) => const WasherDashboard(),
        '/washer-jobs': (context) => const JobRequestScreen(),
        '/washer-earnings': (context) => const EarningsScreen(),
        '/washer-profile': (context) => const WasherProfileScreen(),
        '/washer-subscription': (context) => const SubscriptionScreen(),
      },
      
      onGenerateRoute: (settings) {
        if (settings.name == '/order-details') {
          final order = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(builder: (context) => OrderDetailsScreen(order: order));
        }
        
        if (settings.name == '/booking-with-params') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => BookingScreen(
              selectedService: args['service'],
              selectedPrice: args['price'],
              selectedAddress: args['address'],
            ),
          );
        }
        
        // FIXED: Tracking with params - includes all required parameters
        if (settings.name == '/tracking') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => TrackingScreen(
              jobId: args['jobId'],
              washerName: args['washerName'] ?? 'Professional Washer',
              pickupAddress: args['pickupAddress'] ?? 'Your Location',
              pickupLocation: args['pickupLocation'] ?? const LatLng(6.5244, 3.3792),
            ),
          );
        }
        
        if (settings.name == '/rating') {
          final args = settings.arguments as Map<String, String>;
          return MaterialPageRoute(
            builder: (context) => RatingScreen(
              jobId: args['jobId']!,
              washerId: args['washerId']!,
            ),
          );
        }
        
        if (settings.name == '/otp') {
          final args = settings.arguments as Map<String, String>;
          return MaterialPageRoute(
            builder: (context) => OTPScreen(
              phoneNumber: args['phoneNumber']!,
              verificationId: args['verificationId']!,
            ),
          );
        }
        
        return null;
      },
    );
  }
}

// ==================== RIVERPOD PROVIDERS ====================

final selectedServiceProvider = StateProvider<String>((ref) => 'Basic Wash');
final selectedLocationProvider = StateProvider<String>((ref) => 'Lekki Phase 1, Lagos');

final servicesProvider = Provider<Map<String, Map<String, dynamic>>>((ref) {
  return {
    'Exterior Wash': {'price': 3000, 'priceDisplay': '₦3,000', 'icon': Icons.cleaning_services, 'duration': '30 mins'},
    'Interior Cleaning': {'price': 5000, 'priceDisplay': '₦5,000', 'icon': Icons.event_seat, 'duration': '45 mins'},
    'Full Detailing': {'price': 10000, 'priceDisplay': '₦10,000', 'icon': Icons.star, 'duration': '90 mins'},
  };
});