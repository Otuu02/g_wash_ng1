// FILE: lib/data/datasources/remote/api_service.dart
// PURPOSE: HTTP API service for external API calls (Paystack, etc.)

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/constants/app_constants.dart';
import '../../../config/app_config.dart';

class ApiService {
  final http.Client _client;
  
  ApiService(this._client);
  
  // ==================== PAYSTACK PAYMENTS ====================
  Future<Map<String, dynamic>> initializePayment({
    required String email,
    required int amount,
    required String reference,
  }) async {
    final response = await _client.post(
      Uri.parse('https://api.paystack.co/transaction/initialize'),
      headers: {
        'Authorization': 'Bearer ${AppConfig.paystackSecretKey}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'amount': amount,
        'reference': reference,
        'callback_url': '${AppConfig.apiBaseUrl}/payment/callback',
      }),
    );
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to initialize payment: ${response.body}');
    }
  }
  
  Future<Map<String, dynamic>> verifyPayment(String reference) async {
    final response = await _client.get(
      Uri.parse('https://api.paystack.co/transaction/verify/$reference'),
      headers: {
        'Authorization': 'Bearer ${AppConfig.paystackSecretKey}',
      },
    );
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to verify payment: ${response.body}');
    }
  }
  
  // ==================== GEOCODING ====================
  Future<Map<String, dynamic>> geocodeAddress(String address) async {
    final response = await _client.get(
      Uri.parse('https://maps.googleapis.com/maps/api/geocode/json'),
      queryParams: {
        'address': address,
        'key': AppConfig.googleMapsApiKey,
      },
    );
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to geocode address: ${response.body}');
    }
  }
  
  // ==================== DISTANCE MATRIX ====================
  Future<Map<String, dynamic>> getDistanceMatrix({
    required String origins,
    required String destinations,
  }) async {
    final response = await _client.get(
      Uri.parse('https://maps.googleapis.com/maps/api/distancematrix/json'),
      queryParams: {
        'origins': origins,
        'destinations': destinations,
        'key': AppConfig.googleMapsApiKey,
      },
    );
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get distance matrix: ${response.body}');
    }
  }
  
  // ==================== SEND NOTIFICATION ====================
  Future<Map<String, dynamic>> sendPushNotification({
    required String token,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    final response = await _client.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: {
        'Authorization': 'key=${AppConfig.fcmServerKey}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'to': token,
        'notification': {
          'title': title,
          'body': body,
        },
        'data': data ?? {},
      }),
    );
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to send notification: ${response.body}');
    }
  }
}