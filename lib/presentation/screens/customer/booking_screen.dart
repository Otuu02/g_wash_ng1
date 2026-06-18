import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../services/job_service.dart';
import '../../../services/permission_service.dart';
import 'location_search_screen.dart';
import 'tracking_screen.dart';

class BookingScreen extends StatefulWidget {
  final String? selectedService;
  final int? selectedPrice;
  final String? selectedAddress;
  final String? serviceCategory;

  const BookingScreen({
    super.key,
    this.selectedService,
    this.selectedPrice,
    this.selectedAddress,
    this.serviceCategory,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  String _selectedService = 'Exterior Wash';
  String _selectedCategory = 'Car Wash';
  String _selectedLocation = 'Lekki Phase 1, Lagos';
  DateTime _selectedDate = DateTime.now();
  String _selectedTimeSlot = '10:30 AM';
  String _selectedPayment = 'Paystack';
  bool _isProcessing = false;
  bool _hasLocationPermission = false;
  
  final Map<String, Map<String, dynamic>> _carWashServices = {
    'Exterior Wash': {'price': 3000, 'duration': '30 mins', 'icon': Icons.cleaning_services, 'priceDisplay': '₦3,000', 'description': 'Professional exterior wash including foam, rinse, and dry'},
    'Interior Cleaning': {'price': 5000, 'duration': '45 mins', 'icon': Icons.event_seat, 'priceDisplay': '₦5,000', 'description': 'Complete interior vacuum, dashboard cleaning, and glass polishing'},
    'Full Detailing': {'price': 10000, 'duration': '90 mins', 'icon': Icons.star, 'priceDisplay': '₦10,000', 'description': 'Comprehensive exterior + interior detailing for showroom finish'},
    'Engine Wash': {'price': 7000, 'duration': '60 mins', 'icon': Icons.settings, 'priceDisplay': '₦7,000', 'description': 'Professional engine bay cleaning and degreasing'},
  };
  
  final Map<String, Map<String, dynamic>> _houseCleaningServices = {
    'Standard Cleaning': {'price': 15000, 'duration': '3 hours', 'icon': Icons.cleaning_services, 'priceDisplay': '₦15,000', 'description': 'Basic cleaning for 2-3 bedroom apartments', 'bedrooms': '2-3 beds'},
    'Deep Cleaning': {'price': 25000, 'duration': '5 hours', 'icon': Icons.brush, 'priceDisplay': '₦25,000', 'description': 'Deep cleaning for 3-4 bedroom homes', 'bedrooms': '3-4 beds'},
    'Move In/Out': {'price': 35000, 'duration': '6 hours', 'icon': Icons.move_to_inbox, 'priceDisplay': '₦35,000', 'description': 'Complete cleaning for moving in/out', 'bedrooms': '4-5 beds'},
    'Office Cleaning': {'price': 20000, 'duration': '4 hours', 'icon': Icons.business, 'priceDisplay': '₦20,000', 'description': 'Professional office space cleaning', 'size': 'Small office'},
    'Carpet Cleaning': {'price': 8000, 'duration': '2 hours', 'icon': Icons.carpenter, 'priceDisplay': '₦8,000', 'description': 'Deep carpet steam cleaning', 'rooms': 'Per room'},
    'Window Cleaning': {'price': 5000, 'duration': '1.5 hours', 'icon': Icons.window, 'priceDisplay': '₦5,000', 'description': 'Interior and exterior window cleaning', 'floors': 'Per floor'},
  };
  
  final Map<String, Map<String, dynamic>> _laundryServices = {
    'Wash & Fold': {'price': 2000, 'duration': '24 hours', 'icon': Icons.local_laundry_service, 'priceDisplay': '₦2,000', 'description': 'Wash, dry, and fold service', 'weight': 'Up to 5kg'},
    'Wash & Iron': {'price': 3500, 'duration': '24 hours', 'icon': Icons.iron, 'priceDisplay': '₦3,500', 'description': 'Wash, dry, and professional ironing', 'weight': 'Up to 5kg'},
    'Dry Cleaning': {'price': 5000, 'duration': '48 hours', 'icon': Icons.dry, 'priceDisplay': '₦5,000', 'description': 'Professional dry cleaning', 'items': 'Up to 3 items'},
    'Ironing Only': {'price': 1500, 'duration': '12 hours', 'icon': Icons.iron, 'priceDisplay': '₦1,500', 'description': 'Professional ironing service only', 'weight': 'Up to 3kg'},
    'Bulk Laundry': {'price': 10000, 'duration': '48 hours', 'icon': Icons.local_laundry_service, 'priceDisplay': '₦10,000', 'description': 'Large quantity laundry', 'weight': '15-20kg'},
    'Curtain Cleaning': {'price': 7000, 'duration': '72 hours', 'icon': Icons.curtains, 'priceDisplay': '₦7,000', 'description': 'Professional curtain cleaning', 'items': 'Per set'},
  };

  final List<String> _timeSlots = ['9:00 AM', '10:30 AM', '12:00 PM', '1:30 PM', '3:00 PM', '4:30 PM', '6:00 PM'];
  
  final List<Map<String, dynamic>> _categories = [
    {'name': 'Car Wash', 'icon': Icons.local_car_wash, 'color': const Color(0xFF0CAF60)},
    {'name': 'House Cleaning', 'icon': Icons.home, 'color': Colors.blue},
    {'name': 'Laundry', 'icon': Icons.local_laundry_service, 'color': Colors.purple},
  ];

  Map<String, Map<String, dynamic>> get _currentServices {
    switch (_selectedCategory) {
      case 'House Cleaning':
        return _houseCleaningServices;
      case 'Laundry':
        return _laundryServices;
      default:
        return _carWashServices;
    }
  }

  Map<String, dynamic> get _currentService => _currentServices[_selectedService]!;
  int get _selectedPrice => _currentService['price'];
  String get _selectedPriceDisplay => _currentService['priceDisplay'];
  Color get _currentCategoryColor {
    switch (_selectedCategory) {
      case 'House Cleaning':
        return Colors.blue;
      case 'Laundry':
        return Colors.purple;
      default:
        return AppColors.primary;
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeSelections();
    _checkLocationPermission();
  }

  void _initializeSelections() {
    if (widget.serviceCategory != null) {
      _selectedCategory = widget.serviceCategory!;
    }
    if (widget.selectedService != null && _currentServices.containsKey(widget.selectedService)) {
      _selectedService = widget.selectedService!;
    } else {
      _selectedService = _currentServices.keys.first;
    }
    if (widget.selectedAddress != null && widget.selectedAddress!.isNotEmpty) {
      _selectedLocation = widget.selectedAddress!;
    }
  }

  Future<void> _checkLocationPermission() async {
    final hasPermission = await PermissionService.requestLocationPermission(context);
    setState(() => _hasLocationPermission = hasPermission);
  }

  void _changeLocation() async {
    final newLocation = await Navigator.push(context, MaterialPageRoute(builder: (context) => const LocationSearchScreen()));
    if (newLocation != null && newLocation is String && newLocation.isNotEmpty) {
      setState(() => _selectedLocation = newLocation);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Delivery location set to: $newLocation'), 
        backgroundColor: AppColors.success, 
        duration: const Duration(seconds: 2)
      ));
    }
  }

  void _changeCategory(String category) {
    setState(() {
      _selectedCategory = category;
      _selectedService = _currentServices.keys.first;
    });
  }

  Future<void> _confirmBooking() async {
    if (_selectedLocation.isEmpty || _selectedLocation == 'Lekki Phase 1, Lagos') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a valid delivery location'), backgroundColor: Colors.orange)
      );
      _changeLocation();
      return;
    }

    if (!_hasLocationPermission) {
      final granted = await PermissionService.requestLocationPermission(context);
      if (!granted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permission is required to find nearby service providers'), backgroundColor: Colors.red)
        );
        return;
      }
      setState(() => _hasLocationPermission = true);
    }

    setState(() => _isProcessing = true);

    try {
      final currentPosition = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 10)
      );
      
      final jobService = JobService();
      final job = await jobService.createJob(
        customerId: 'CUST-001',
        serviceType: _selectedService,
        price: _selectedPrice,
        address: _selectedLocation,
        latitude: currentPosition.latitude,
        longitude: currentPosition.longitude,
        category: _selectedCategory,
      );
      
      final nearestProvider = await jobService.findNearestWasher(
        currentPosition.latitude, 
        currentPosition.longitude,
        category: _selectedCategory,
      );
      
      if (nearestProvider == null) throw Exception('No service providers available in your area for $_selectedCategory. Please try again later.');
      
      final assignment = await jobService.assignWasher(job['id'], nearestProvider['id']);
      
      if (mounted) {
        setState(() => _isProcessing = false);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TrackingScreen(
              jobId: job['id'],
              washerName: nearestProvider['name'],
              pickupAddress: _selectedLocation,
              pickupLocation: LatLng(currentPosition.latitude, currentPosition.longitude),
            ),
          ),
        );
      }
    } catch (e) {
      setState(() => _isProcessing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red, duration: const Duration(seconds: 3))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Details', style: TextStyle(fontWeight: FontWeight.bold)), 
        backgroundColor: _currentCategoryColor, 
        foregroundColor: Colors.white, 
        elevation: 0, 
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), 
          onPressed: () => Navigator.pop(context)
        ),
      ),
      body: _isProcessing
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: _currentCategoryColor),
                  const SizedBox(height: 20),
                  Text('Finding nearest ${_selectedCategory.toLowerCase()} provider...'),
                  const SizedBox(height: 8),
                  Text('This may take a moment', style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: _categories.map((category) {
                        final isSelected = _selectedCategory == category['name'];
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => _changeCategory(category['name']),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: isSelected ? category['color'] : Colors.transparent,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(category['icon'], size: 18, color: isSelected ? Colors.white : category['color']),
                                  const SizedBox(width: 6),
                                  Text(category['name'], style: TextStyle(color: isSelected ? Colors.white : category['color'], fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, fontSize: 13)),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Service Selected', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Card(
                    elevation: 2, 
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: _currentCategoryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: Icon(_currentService['icon'], color: _currentCategoryColor, size: 24)),
                      title: Text(_selectedService, style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('$_selectedPriceDisplay • ${_currentService['duration']}'),
                          Text(_currentService['description'], style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                          if (_currentService.containsKey('weight')) Text('Weight: ${_currentService['weight']}', style: TextStyle(fontSize: 10, color: Colors.grey)),
                          if (_currentService.containsKey('bedrooms')) Text('Bedrooms: ${_currentService['bedrooms']}', style: TextStyle(fontSize: 10, color: Colors.grey)),
                        ],
                      ),
                      trailing: TextButton(onPressed: _showServiceDialog, child: const Text('Change')),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Delivery Location', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: InkWell(
                      onTap: _changeLocation,
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: _currentCategoryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.location_on, color: AppColors.primary, size: 24)),
                            const SizedBox(width: 12),
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Selected Location', style: TextStyle(fontSize: 12, color: Colors.grey)), Text(_selectedLocation, style: const TextStyle(fontWeight: FontWeight.w500), maxLines: 2, overflow: TextOverflow.ellipsis)])),
                            const Icon(Icons.edit, size: 20, color: AppColors.primary),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Preferred Date & Time', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [_buildDateOption(0), _buildDateOption(1), _buildDateOption(2), _buildDateOption(3), _buildDateOption(4)]),
                          const SizedBox(height: 20),
                          const Divider(),
                          const SizedBox(height: 16),
                          const Text('Select Time', style: TextStyle(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 12),
                          Wrap(spacing: 12, runSpacing: 12, children: _timeSlots.map((slot) {
                            final isSelected = _selectedTimeSlot == slot;
                            return FilterChip(label: Text(slot), selected: isSelected, onSelected: (selected) => setState(() => _selectedTimeSlot = slot), selectedColor: _currentCategoryColor, checkmarkColor: Colors.white, backgroundColor: Colors.grey.shade100, labelStyle: TextStyle(color: isSelected ? Colors.white : AppColors.grey800));
                          }).toList()),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Payment Method', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      children: [
                        RadioListTile(title: const Text('Paystack', style: TextStyle(fontWeight: FontWeight.w500)), subtitle: const Text('Card, Bank Transfer, USSD'), value: 'Paystack', groupValue: _selectedPayment, onChanged: (value) => setState(() => _selectedPayment = value!), activeColor: _currentCategoryColor, secondary: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.payment, color: AppColors.primary))),
                        RadioListTile(title: const Text('Wallet', style: TextStyle(fontWeight: FontWeight.w500)), subtitle: const Text('Balance: ₦5,000'), value: 'Wallet', groupValue: _selectedPayment, onChanged: (value) => setState(() => _selectedPayment = value!), activeColor: _currentCategoryColor, secondary: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.wallet, color: AppColors.primary))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: _currentCategoryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: _currentCategoryColor.withOpacity(0.2))), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Estimated Total', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), Column(crossAxisAlignment: CrossAxisAlignment.end, children: [Text('$_selectedPriceDisplay', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _currentCategoryColor)), const Text('Includes VAT', style: TextStyle(fontSize: 10, color: AppColors.grey500))])])),
                  const SizedBox(height: 30),
                  SizedBox(width: double.infinity, height: 55, child: ElevatedButton(onPressed: _confirmBooking, style: ElevatedButton.styleFrom(backgroundColor: _currentCategoryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: Text('Confirm $_selectedCategory Booking', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)))),
                  if (_selectedLocation == 'Lekki Phase 1, Lagos') Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8)), child: Row(children: [Icon(Icons.info_outline, color: Colors.blue.shade700), const SizedBox(width: 8), Expanded(child: Text('Tap on the location card to search for your exact address across Nigeria', style: TextStyle(color: Colors.blue.shade700, fontSize: 12)))])),
                ],
              ),
            ),
    );
  }

  Widget _buildDateOption(int daysFromNow) {
    final date = DateTime.now().add(Duration(days: daysFromNow));
    final isSelected = _selectedDate.year == date.year && _selectedDate.month == date.month && _selectedDate.day == date.day;
    String dayLabel = daysFromNow == 0 ? 'Today' : daysFromNow == 1 ? 'Tomorrow' : date.day.toString();
    final monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return GestureDetector(
      onTap: () => setState(() => _selectedDate = date),
      child: Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), decoration: BoxDecoration(color: isSelected ? _currentCategoryColor : Colors.transparent, borderRadius: BorderRadius.circular(30), border: Border.all(color: isSelected ? _currentCategoryColor : AppColors.grey300)), child: Column(children: [Text(dayLabel, style: TextStyle(color: isSelected ? Colors.white : AppColors.grey800, fontWeight: FontWeight.w600)), const SizedBox(height: 2), Text('${monthNames[date.month - 1]} ${date.day}', style: TextStyle(color: isSelected ? Colors.white70 : AppColors.grey500, fontSize: 10))])),
    );
  }

  void _showServiceDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Select Service', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ..._currentServices.keys.map((service) => ListTile(
              leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: _currentCategoryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: Icon(_currentServices[service]!['icon'], color: _currentCategoryColor, size: 24)),
              title: Text(service, style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('${_currentServices[service]!['priceDisplay']} • ${_currentServices[service]!['duration']}'), Text(_currentServices[service]!['description'], style: TextStyle(fontSize: 11, color: Colors.grey.shade600))]),
              trailing: _selectedService == service ? Icon(Icons.check_circle, color: _currentCategoryColor) : null,
              onTap: () { setState(() => _selectedService = service); Navigator.pop(context); },
            )),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}