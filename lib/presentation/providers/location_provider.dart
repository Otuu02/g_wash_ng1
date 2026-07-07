// FILE: lib/presentation/providers/location_provider.dart
// PURPOSE: Riverpod provider for location state management

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

final locationProvider = StateNotifierProvider<LocationNotifier, LocationState>((ref) {
  return LocationNotifier();
});

class LocationNotifier extends StateNotifier<LocationState> {
  LocationNotifier() : super(const LocationState.initial());
  
  Future<void> getCurrentLocation() async {
    state = const LocationState.loading();
    
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        state = const LocationState.error('Location services are disabled');
        return;
      }
      
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          state = const LocationState.error('Location permissions are denied');
          return;
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        state = const LocationState.error('Location permissions are permanently denied');
        return;
      }
      
      final position = await Geolocator.getCurrentPosition();
      state = LocationState.loaded(position);
    } catch (e) {
      state = LocationState.error(e.toString());
    }
  }
  
  Future<void> searchAddress(String query) async {
    state = const LocationState.loading();
    
    try {
      final places = await Geolocator.placemarkFromAddress(query);
      state = LocationState.addressesFound(places);
    } catch (e) {
      state = LocationState.error(e.toString());
    }
  }
}

class LocationState {
  final bool isLoading;
  final Position? currentLocation;
  final List<Placemark>? addresses;
  final String? error;
  
  const LocationState({
    required this.isLoading,
    this.currentLocation,
    this.addresses,
    this.error,
  });
  
  const LocationState.initial() : this(isLoading: false);
  const LocationState.loading() : this(isLoading: true);
  const LocationState.loaded(Position position) : this(
    isLoading: false,
    currentLocation: position,
  );
  const LocationState.addressesFound(List<Placemark> addresses) : this(
    isLoading: false,
    addresses: addresses,
  );
  const LocationState.error(String error) : this(
    isLoading: false,
    error: error,
  );
}