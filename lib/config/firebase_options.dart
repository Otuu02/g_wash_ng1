// FILE: lib/config/firebase_options.dart
// PURPOSE: Firebase configuration for different platforms
// NOTE: This file will be regenerated when you run 'flutterfire configure'

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show kIsWeb, TargetPlatform, defaultTargetPlatform;

class DefaultFirebaseOptions {
  // Private constructor
  DefaultFirebaseOptions._();
  
  // Get the current platform's Firebase options
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        return linux;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }
  
  // Android configuration (Customer App)
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'YOUR_ANDROID_API_KEY',
    appId: '1:YOUR_APP_ID:android:YOUR_ANDROID_APP_ID',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'g-wash-ng',
    authDomain: 'g-wash-ng.firebaseapp.com',
    storageBucket: 'g-wash-ng.appspot.com',
    measurementId: 'G-MEASUREMENT_ID',
  );
  
  // iOS configuration
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_IOS_API_KEY',
    appId: '1:YOUR_APP_ID:ios:YOUR_IOS_APP_ID',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'g-wash-ng',
    authDomain: 'g-wash-ng.firebaseapp.com',
    storageBucket: 'g-wash-ng.appspot.com',
    androidClientId: 'YOUR_ANDROID_CLIENT_ID',
    iosClientId: 'YOUR_IOS_CLIENT_ID',
    iosBundleId: 'com.gwashng.g_wash_ng',
  );
  
  // Web configuration
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'YOUR_WEB_API_KEY',
    appId: '1:YOUR_APP_ID:web:YOUR_WEB_APP_ID',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'g-wash-ng',
    authDomain: 'g-wash-ng.firebaseapp.com',
    storageBucket: 'g-wash-ng.appspot.com',
    measurementId: 'G-MEASUREMENT_ID',
  );
  
  // macOS configuration
  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'YOUR_MACOS_API_KEY',
    appId: '1:YOUR_APP_ID:macos:YOUR_MACOS_APP_ID',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'g-wash-ng',
    authDomain: 'g-wash-ng.firebaseapp.com',
    storageBucket: 'g-wash-ng.appspot.com',
    iosClientId: 'YOUR_IOS_CLIENT_ID',
    iosBundleId: 'com.gwashng.g_wash_ng',
  );
  
  // Windows configuration
  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'YOUR_WINDOWS_API_KEY',
    appId: '1:YOUR_APP_ID:web:YOUR_WEB_APP_ID',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'g-wash-ng',
    authDomain: 'g-wash-ng.firebaseapp.com',
    storageBucket: 'g-wash-ng.appspot.com',
    measurementId: 'G-MEASUREMENT_ID',
  );
  
  // Linux configuration
  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: 'YOUR_LINUX_API_KEY',
    appId: '1:YOUR_APP_ID:web:YOUR_WEB_APP_ID',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'g-wash-ng',
    authDomain: 'g-wash-ng.firebaseapp.com',
    storageBucket: 'g-wash-ng.appspot.com',
    measurementId: 'G-MEASUREMENT_ID',
  );
}