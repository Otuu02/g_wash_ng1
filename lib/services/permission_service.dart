import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

class PermissionService {
  // ==================== LOCATION PERMISSIONS ====================
  
  /// Request location permission for finding nearby service providers
  static Future<bool> requestLocationPermission(BuildContext context) async {
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showLocationDialog(
        context, 
        'Location services are disabled. Please enable them to find nearby service providers.',
        onOpenSettings: () async {
          await Geolocator.openLocationSettings();
        },
      );
      return false;
    }

    // Check permission status
    LocationPermission permission = await Geolocator.checkPermission();
    
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showPermissionDialog(
          context,
          'Location Permission Required',
          'Location permission is needed to find nearby washers, cleaners, and laundry services in your area.',
        );
        return false;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      _showSettingsDialog(
        context,
        'Location Permission Permanently Denied',
        'Please enable location permission in app settings to use location-based services.',
      );
      return false;
    }
    
    return true;
  }

  /// Request background location permission for live tracking
  static Future<bool> requestBackgroundLocationPermission(BuildContext context) async {
    final PermissionStatus status = await Permission.locationAlways.request();
    
    if (status == PermissionStatus.granted) {
      return true;
    } else if (status == PermissionStatus.denied) {
      _showPermissionDialog(
        context,
        'Background Location Permission',
        'Background location access is needed for live tracking of your service provider.',
      );
      return false;
    } else if (status == PermissionStatus.permanentlyDenied) {
      _showSettingsDialog(
        context,
        'Background Location Required',
        'Please enable "Allow all the time" location permission in app settings for live tracking.',
      );
      return false;
    }
    
    return false;
  }

  // ==================== CAMERA PERMISSION ====================
  
  /// Request camera permission for taking photos (profile, vehicle, etc.)
  static Future<bool> requestCameraPermission(BuildContext context) async {
    final PermissionStatus status = await Permission.camera.request();
    
    if (status == PermissionStatus.granted) {
      return true;
    } else if (status == PermissionStatus.denied) {
      _showPermissionDialog(
        context,
        'Camera Permission Required',
        'Camera access is needed to take profile photos and upload vehicle images.',
      );
      return false;
    } else if (status == PermissionStatus.permanentlyDenied) {
      _showSettingsDialog(
        context,
        'Camera Permission Required',
        'Please enable camera permission in app settings to use this feature.',
      );
      return false;
    }
    
    return false;
  }

  // ==================== STORAGE PERMISSIONS ====================
  
  /// Request photo library permission for uploading images
  static Future<bool> requestStoragePermission(BuildContext context) async {
    PermissionStatus status;
    
    // For Android 13+ (API 33+), use photos permission
    if (await _isAndroid13OrAbove()) {
      status = await Permission.photos.request();
    } else {
      status = await Permission.storage.request();
    }
    
    if (status == PermissionStatus.granted) {
      return true;
    } else if (status == PermissionStatus.denied) {
      _showPermissionDialog(
        context,
        'Storage Permission Required',
        'Storage access is needed to upload profile photos and vehicle images.',
      );
      return false;
    } else if (status == PermissionStatus.permanentlyDenied) {
      _showSettingsDialog(
        context,
        'Storage Permission Required',
        'Please enable storage permission in app settings to upload images.',
      );
      return false;
    }
    
    return false;
  }

  // ==================== NOTIFICATION PERMISSIONS ====================
  
  /// Request notification permission for push notifications (Android 13+)
  static Future<bool> requestNotificationPermission(BuildContext context) async {
    // Only needed for Android 13+
    if (await _isAndroid13OrAbove()) {
      final PermissionStatus status = await Permission.notification.request();
      
      if (status == PermissionStatus.granted) {
        return true;
      } else if (status == PermissionStatus.denied) {
        // Notifications are optional, don't show dialog
        return false;
      } else if (status == PermissionStatus.permanentlyDenied) {
        // User can still get notifications through Firebase
        return false;
      }
    }
    
    return true; // Notifications are optional
  }

  // ==================== CONTACT PERMISSION ====================
  
  /// Request contact permission for sharing and referrals
  static Future<bool> requestContactPermission(BuildContext context) async {
    final PermissionStatus status = await Permission.contacts.request();
    
    if (status == PermissionStatus.granted) {
      return true;
    } else if (status == PermissionStatus.denied) {
      // Contacts are optional for referrals
      return false;
    } else if (status == PermissionStatus.permanentlyDenied) {
      return false;
    }
    
    return false;
  }

  // ==================== MICROPHONE PERMISSION ====================
  
  /// Request microphone permission for voice notes and calls
  static Future<bool> requestMicrophonePermission(BuildContext context) async {
    final PermissionStatus status = await Permission.microphone.request();
    
    if (status == PermissionStatus.granted) {
      return true;
    } else if (status == PermissionStatus.denied) {
      _showPermissionDialog(
        context,
        'Microphone Permission',
        'Microphone access is needed for voice notes and customer support calls.',
        showCancelButton: true,
      );
      return false;
    } else if (status == PermissionStatus.permanentlyDenied) {
      _showSettingsDialog(
        context,
        'Microphone Permission Required',
        'Please enable microphone permission in app settings for voice features.',
      );
      return false;
    }
    
    return false;
  }

  // ==================== ALL PERMISSIONS AT ONCE ====================
  
  /// Request all required permissions at once
  static Future<Map<String, bool>> requestAllPermissions(BuildContext context) async {
    final results = <String, bool>{};
    
    // Request location
    results['location'] = await requestLocationPermission(context);
    
    // Request camera
    results['camera'] = await requestCameraPermission(context);
    
    // Request storage
    results['storage'] = await requestStoragePermission(context);
    
    // Request notifications (optional)
    results['notifications'] = await requestNotificationPermission(context);
    
    return results;
  }

  /// Request permissions for service providers (washers, cleaners, etc.)
  static Future<Map<String, bool>> requestProviderPermissions(BuildContext context) async {
    final results = <String, bool>{};
    
    // Location is required
    results['location'] = await requestLocationPermission(context);
    
    // Background location for providers
    results['backgroundLocation'] = await requestBackgroundLocationPermission(context);
    
    // Camera for vehicle/service photos
    results['camera'] = await requestCameraPermission(context);
    
    // Storage for uploading documents
    results['storage'] = await requestStoragePermission(context);
    
    // Notifications for job alerts
    results['notifications'] = await requestNotificationPermission(context);
    
    return results;
  }

  // ==================== PERMISSION CHECKERS ====================
  
  /// Check if location permission is granted
  static Future<bool> isLocationPermissionGranted() async {
    final PermissionStatus status = await Permission.location.status;
    return status == PermissionStatus.granted;
  }
  
  /// Check if camera permission is granted
  static Future<bool> isCameraPermissionGranted() async {
    final PermissionStatus status = await Permission.camera.status;
    return status == PermissionStatus.granted;
  }
  
  /// Check if storage permission is granted
  static Future<bool> isStoragePermissionGranted() async {
    if (await _isAndroid13OrAbove()) {
      final PermissionStatus status = await Permission.photos.status;
      return status == PermissionStatus.granted;
    } else {
      final PermissionStatus status = await Permission.storage.status;
      return status == PermissionStatus.granted;
    }
  }
  
  /// Check if location services are enabled
  static Future<bool> areLocationServicesEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  // ==================== HELPER METHODS ====================
  
  /// Check if device is running Android 13 or above
  static Future<bool> _isAndroid13OrAbove() async {
    // This is a simple check - you can also use device_info_plus package
    return true; // For now, assume Android 13+
  }
  
  /// Show permission dialog
  static void _showPermissionDialog(
    BuildContext context,
    String title,
    String message, {
    bool showCancelButton = false,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          if (showCancelButton)
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Not Now'),
            ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Request permission again
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0CAF60),
            ),
            child: const Text('Grant Permission'),
          ),
        ],
      ),
    );
  }
  
  /// Show settings dialog when permission is permanently denied
  static void _showSettingsDialog(
    BuildContext context,
    String title,
    String message,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0CAF60),
            ),
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }
  
  /// Show location dialog
  static void _showLocationDialog(
    BuildContext context,
    String message, {
    VoidCallback? onOpenSettings,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Services Required'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              if (onOpenSettings != null) {
                onOpenSettings();
              } else {
                openAppSettings();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0CAF60),
            ),
            child: const Text('Enable Location'),
          ),
        ],
      ),
    );
  }
}