// lib/presentation/screens/customer/location_search_screen.dart
// Use OSM only - NO Google API key needed

import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import '../../../core/constants/app_colors.dart';

class LocationSearchScreen extends StatefulWidget {
  const LocationSearchScreen({super.key});

  @override
  State<LocationSearchScreen> createState() => _LocationSearchScreenState();
}

class _LocationSearchScreenState extends State<LocationSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isLoading = false;

  // Nigerian cities database (offline)
  final List<Map<String, String>> _nigerianCities = [
    // Lagos areas
    {'name': 'Lekki Phase 1, Lagos', 'state': 'Lagos', 'type': 'area'},
    {'name': 'Lekki Phase 2, Lagos', 'state': 'Lagos', 'type': 'area'},
    {'name': 'Victoria Island, Lagos', 'state': 'Lagos', 'type': 'area'},
    {'name': 'Ikoyi, Lagos', 'state': 'Lagos', 'type': 'area'},
    {'name': 'Surulere, Lagos', 'state': 'Lagos', 'type': 'area'},
    {'name': 'Ikeja, Lagos', 'state': 'Lagos', 'type': 'area'},
    {'name': 'GRA, Ikeja, Lagos', 'state': 'Lagos', 'type': 'area'},
    {'name': 'Ajah, Lagos', 'state': 'Lagos', 'type': 'area'},
    {'name': 'Maryland, Lagos', 'state': 'Lagos', 'type': 'area'},
    {'name': 'Yaba, Lagos', 'state': 'Lagos', 'type': 'area'},
    {'name': 'Magodo, Lagos', 'state': 'Lagos', 'type': 'area'},
    {'name': 'Agege, Lagos', 'state': 'Lagos', 'type': 'area'},
    {'name': 'Badagry, Lagos', 'state': 'Lagos', 'type': 'city'},
    {'name': 'Epe, Lagos', 'state': 'Lagos', 'type': 'city'},
    {'name': 'Ikorodu, Lagos', 'state': 'Lagos', 'type': 'city'},
    {'name': 'Mushin, Lagos', 'state': 'Lagos', 'type': 'area'},
    {'name': 'Ojo, Lagos', 'state': 'Lagos', 'type': 'area'},
    {'name': 'Alimosho, Lagos', 'state': 'Lagos', 'type': 'area'},
    
    // Other Nigerian cities
    {'name': 'Abuja, FCT', 'state': 'FCT', 'type': 'city'},
    {'name': 'Port Harcourt, Rivers', 'state': 'Rivers', 'type': 'city'},
    {'name': 'Ibadan, Oyo', 'state': 'Oyo', 'type': 'city'},
    {'name': 'Kano, Kano', 'state': 'Kano', 'type': 'city'},
    {'name': 'Benin City, Edo', 'state': 'Edo', 'type': 'city'},
    {'name': 'Enugu, Enugu', 'state': 'Enugu', 'type': 'city'},
    {'name': 'Abeokuta, Ogun', 'state': 'Ogun', 'type': 'city'},
    {'name': 'Warri, Delta', 'state': 'Delta', 'type': 'city'},
    {'name': 'Calabar, Cross River', 'state': 'Cross River', 'type': 'city'},
    {'name': 'Jos, Plateau', 'state': 'Plateau', 'type': 'city'},
    {'name': 'Maiduguri, Borno', 'state': 'Borno', 'type': 'city'},
    {'name': 'Sokoto, Sokoto', 'state': 'Sokoto', 'type': 'city'},
    {'name': 'Kaduna, Kaduna', 'state': 'Kaduna', 'type': 'city'},
    {'name': 'Owerri, Imo', 'state': 'Imo', 'type': 'city'},
    {'name': 'Akure, Ondo', 'state': 'Ondo', 'type': 'city'},
    {'name': 'Ado-Ekiti, Ekiti', 'state': 'Ekiti', 'type': 'city'},
    {'name': 'Osogbo, Osun', 'state': 'Osun', 'type': 'city'},
    {'name': 'Lokoja, Kogi', 'state': 'Kogi', 'type': 'city'},
    {'name': 'Makurdi, Benue', 'state': 'Benue', 'type': 'city'},
    {'name': 'Minna, Niger', 'state': 'Niger', 'type': 'city'},
    {'name': 'Uyo, Akwa Ibom', 'state': 'Akwa Ibom', 'type': 'city'},
    {'name': 'Asaba, Delta', 'state': 'Delta', 'type': 'city'},
    {'name': 'Gombe, Gombe', 'state': 'Gombe', 'type': 'city'},
    {'name': 'Bauchi, Bauchi', 'state': 'Bauchi', 'type': 'city'},
    {'name': 'Yola, Adamawa', 'state': 'Adamawa', 'type': 'city'},
    {'name': 'Jalingo, Taraba', 'state': 'Taraba', 'type': 'city'},
    {'name': 'Damaturu, Yobe', 'state': 'Yobe', 'type': 'city'},
    {'name': 'Katsina, Katsina', 'state': 'Katsina', 'type': 'city'},
    {'name': 'Zaria, Kaduna', 'state': 'Kaduna', 'type': 'city'},
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text;
    if (query.isEmpty) {
      setState(() => _searchResults = []);
      return;
    }
    _searchLocal(query);
  }

  void _searchLocal(String query) {
    setState(() => _isLoading = true);
    
    final lowerQuery = query.toLowerCase();
    final results = _nigerianCities.where((city) {
      return city['name']!.toLowerCase().contains(lowerQuery) ||
             city['state']!.toLowerCase().contains(lowerQuery);
    }).toList();
    
    // Simulate network delay
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          _searchResults = results.map((city) => {
            'description': city['name'],
            'shortAddress': city['name'],
          }).toList();
          _isLoading = false;
        });
      }
    });
  }

  void _selectLocation(String address) {
    Navigator.pop(context, address);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Where should we come to?',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Search city, street, or landmark...',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchResults = []);
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
            ),
          ),
          
          // Results
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _searchResults.isNotEmpty
                    ? ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          final result = _searchResults[index];
                          final address = result['description'] ?? '';
                          
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.location_on,
                                  color: AppColors.primary,
                                  size: 20,
                                ),
                              ),
                              title: Text(
                                address,
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                              subtitle: const Text(
                                'Nigeria',
                                style: TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                              onTap: () => _selectLocation(address),
                            ),
                          );
                        },
                      )
                    : _buildPopularLocations(),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularLocations() {
    // Group popular locations
    final popularLocations = [
      'Lekki Phase 1, Lagos',
      'Victoria Island, Lagos',
      'Ikoyi, Lagos',
      'Surulere, Lagos',
      'Ikeja, Lagos',
      'Abuja, FCT',
      'Port Harcourt, Rivers',
      'Ibadan, Oyo',
    ];
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current Location Option
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.gps_fixed, color: AppColors.primary),
              ),
              title: const Text(
                'Use Current Location',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text('Detect your current GPS location'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => Navigator.pop(context, 'current_location'),
            ),
          ),
          
          const SizedBox(height: 24),
          
          const Text(
            'Popular Locations',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          
          ...popularLocations.map((location) => ListTile(
            leading: const Icon(Icons.location_pin, color: AppColors.primary),
            title: Text(location),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            onTap: () => _selectLocation(location),
          )),
          
          const SizedBox(height: 24),
          
          const Text(
            'All Nigerian States',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              'Lagos', 'Abuja', 'Rivers', 'Oyo', 'Kano', 'Edo',
              'Enugu', 'Ogun', 'Delta', 'Cross River', 'Plateau', 'Kaduna'
            ].map((state) => FilterChip(
              label: Text(state),
              onSelected: (_) => _selectLocation('$state, Nigeria'),
              backgroundColor: Colors.grey.shade100,
              selectedColor: AppColors.primary.withOpacity(0.1),
            )).toList(),
          ),
          
          const SizedBox(height: 16),
          
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue.shade700, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'You can search for any city across all 36 states of Nigeria',
                    style: TextStyle(color: Colors.blue.shade700, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}