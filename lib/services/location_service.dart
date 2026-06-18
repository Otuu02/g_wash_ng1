import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

class LocationService extends ChangeNotifier {
  Position? _currentPosition;
  bool _isLoading = false;
  String? _currentAddress;
  
  // Google Maps API Key (Replace with your actual key)
  static const String GOOGLE_MAPS_API_KEY = 'AIzaSyCXzpvcdGJARb7WcDzXtcwzLEUMwt5bRjw';
  
  // API URLs
  static const String GEOCODE_API_URL = 'https://maps.googleapis.com/maps/api/geocode/json';
  static const String PLACES_API_URL = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
  static const String PLACE_DETAILS_URL = 'https://maps.googleapis.com/maps/api/place/details/json';
  static const String DISTANCE_MATRIX_URL = 'https://maps.googleapis.com/maps/api/distancematrix/json';
  static const String DIRECTIONS_API_URL = 'https://maps.googleapis.com/maps/api/directions/json';

  Position? get currentPosition => _currentPosition;
  bool get isLoading => _isLoading;
  String? get currentAddress => _currentAddress;

  // ==================== LOCATION PERMISSIONS & GPS ====================
  
  Future<Position> getCurrentLocation() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied');
      }

      _currentPosition = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10, // Update every 10 meters
        ),
      );
      
      // Get address from coordinates
      await getAddressFromLatLng(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );
      
      _isLoading = false;
      notifyListeners();
      return _currentPosition!;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Start continuous location tracking (for live tracking)
  Stream<Position> getLocationStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Update every 10 meters
      ),
    );
  }

  // ==================== GOOGLE MAPS GEOCODING ====================
  
  // Convert address to coordinates (Geocoding)
  Future<LatLng?> getCoordinatesFromAddress(String address) async {
    try {
      final encodedAddress = Uri.encodeComponent(address);
      final response = await http.get(
        Uri.parse('$GEOCODE_API_URL?address=$encodedAddress&key=$GOOGLE_MAPS_API_KEY'),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'OK' && data['results'].isNotEmpty) {
          final location = data['results'][0]['geometry']['location'];
          return LatLng(location['lat'], location['lng']);
        }
      }
      return null;
    } catch (e) {
      print('Geocoding error: $e');
      return null;
    }
  }
  
  // Convert coordinates to address (Reverse Geocoding)
  Future<String> getAddressFromLatLng(double lat, double lng) async {
    try {
      final response = await http.get(
        Uri.parse('$GEOCODE_API_URL?latlng=$lat,$lng&key=$GOOGLE_MAPS_API_KEY'),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'OK' && data['results'].isNotEmpty) {
          _currentAddress = data['results'][0]['formatted_address'];
          notifyListeners();
          return _currentAddress!;
        }
      }
      return 'Unknown location';
    } catch (e) {
      print('Reverse geocoding error: $e');
      return 'Unable to get address';
    }
  }

  // ==================== PLACES AUTOCOMPLETE (Search ANYWHERE in Nigeria) ====================
  
  // Search places across Nigeria
  Future<List<Map<String, dynamic>>> searchPlaces(String query) async {
    if (query.length < 2) return [];
    
    try {
      final response = await http.get(
        Uri.parse('$PLACES_API_URL?input=$query&key=$GOOGLE_MAPS_API_KEY&components=country:ng'),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'OK' && data['predictions'] != null) {
          return List<Map<String, dynamic>>.from(data['predictions']);
        }
      }
      return [];
    } catch (e) {
      print('Places search error: $e');
      return [];
    }
  }
  
  // Get place details by place_id
  Future<Map<String, dynamic>?> getPlaceDetails(String placeId) async {
    try {
      final response = await http.get(
        Uri.parse('$PLACE_DETAILS_URL?place_id=$placeId&key=$GOOGLE_MAPS_API_KEY'),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'OK') {
          return data['result'];
        }
      }
      return null;
    } catch (e) {
      print('Place details error: $e');
      return null;
    }
  }

  // ==================== DISTANCE & ETA CALCULATIONS ====================
  
  // Get distance and duration between two locations
  Future<Map<String, dynamic>?> getDistanceAndDuration(
    LatLng origin,
    LatLng destination,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$DISTANCE_MATRIX_URL?origins=${origin.latitude},${origin.longitude}&destinations=${destination.latitude},${destination.longitude}&key=$GOOGLE_MAPS_API_KEY'),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'OK' && data['rows'].isNotEmpty) {
          final element = data['rows'][0]['elements'][0];
          if (element['status'] == 'OK') {
            return {
              'distance': element['distance']['text'],
              'distanceValue': element['distance']['value'], // in meters
              'duration': element['duration']['text'],
              'durationValue': element['duration']['value'], // in seconds
            };
          }
        }
      }
      return null;
    } catch (e) {
      print('Distance matrix error: $e');
      return null;
    }
  }
  
  // Get directions between two points (for route drawing)
  Future<Map<String, dynamic>?> getDirections(
    LatLng origin,
    LatLng destination,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$DIRECTIONS_API_URL?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=$GOOGLE_MAPS_API_KEY'),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'OK' && data['routes'].isNotEmpty) {
          return data['routes'][0];
        }
      }
      return null;
    } catch (e) {
      print('Directions error: $e');
      return null;
    }
  }
  
  // Decode polyline points for drawing route
  List<LatLng> decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;
    
    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;
      
      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;
      
      points.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }

  // ==================== NEARBY SEARCH ====================
  
  // Search for nearby service providers
  Future<List<Map<String, dynamic>>> searchNearby(
    double lat,
    double lng,
    String type, // car_wash, cleaning_service, laundry
  ) async {
    try {
      final response = await http.get(
        Uri.parse('https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$lng&radius=5000&type=$type&key=$GOOGLE_MAPS_API_KEY'),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'OK' && data['results'] != null) {
          return List<Map<String, dynamic>>.from(data['results']);
        }
      }
      return [];
    } catch (e) {
      print('Nearby search error: $e');
      return [];
    }
  }

  // ==================== STATIC HELPER METHODS ====================
  
  // Calculate distance between two coordinates (Haversine formula)
  static double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // km
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) * cos(_toRadians(lat2)) *
        sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }
  
  static double _toRadians(double degrees) {
    return degrees * pi / 180;
  }
  
  // Format distance for display
  static String formatDistance(double km) {
    if (km < 1) {
      return '${(km * 1000).round()} m';
    }
    return '${km.toStringAsFixed(1)} km';
  }
  
  // Format duration for display
  static String formatDuration(int seconds) {
    if (seconds < 60) {
      return '${seconds} sec';
    }
    final minutes = seconds ~/ 60;
    if (minutes < 60) {
      return '$minutes min';
    }
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    if (remainingMinutes == 0) {
      return '$hours hr';
    }
    return '$hours hr $remainingMinutes min';
  }
  
  // Find nearest provider from list
  static Map<String, dynamic>? findNearestProvider(
    Position userLocation,
    List<Map<String, dynamic>> providers,
  ) {
    if (providers.isEmpty) return null;
    
    Map<String, dynamic>? nearestProvider;
    double minDistance = double.infinity;

    for (var provider in providers) {
      final distance = calculateDistance(
        userLocation.latitude,
        userLocation.longitude,
        provider['latitude'] ?? provider['geometry']?['location']?['lat'] ?? 0,
        provider['longitude'] ?? provider['geometry']?['location']?['lng'] ?? 0,
      );
      
      if (distance < minDistance) {
        minDistance = distance;
        nearestProvider = {...provider, 'distance': distance, 'distanceFormatted': formatDistance(distance)};
      }
    }
    
    return nearestProvider;
  }

  // ==================== AUTOCOMPLETE SUGGESTIONS ====================
  
  // Get autocomplete suggestions for Nigerian locations
  Future<List<Map<String, dynamic>>> getAutocompleteSuggestions(String input) async {
    if (input.isEmpty) return [];
    
    try {
      final response = await http.get(
        Uri.parse('$PLACES_API_URL?input=$input&key=$GOOGLE_MAPS_API_KEY&components=country:ng'),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'OK' && data['predictions'] != null) {
          return List<Map<String, dynamic>>.from(data['predictions']);
        }
      }
      return [];
    } catch (e) {
      print('Autocomplete error: $e');
      return [];
    }
  }
}