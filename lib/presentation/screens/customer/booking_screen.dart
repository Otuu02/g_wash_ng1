// lib/presentation/screens/customer/booking_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import 'payment_screen.dart';

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
  String _selectedCategory = 'Car Wash';
  String _selectedService = 'Standard Cleaning';
  int _selectedServicePrice = 15000;
  String _selectedLocation = 'Lekki Phase 1, Lagos';
  DateTime _selectedDate = DateTime.now();
  String _selectedTime = '9:00 AM';
  String _selectedPaymentMethod = 'Wallet';
  int _currentStep = 0;

  final List<String> _categories = ['Car Wash', 'House Cleaning', 'Laundry'];

  // Service Data
  final Map<String, List<Map<String, dynamic>>> _services = {
    'Car Wash': [
      {'name': 'Exterior Wash', 'price': 3000, 'duration': '30 mins', 'description': 'Wash and dry exterior'},
      {'name': 'Interior Cleaning', 'price': 5000, 'duration': '45 mins', 'description': 'Vacuum and wipe interior'},
      {'name': 'Full Detailing', 'price': 10000, 'duration': '90 mins', 'description': 'Complete wash and detailing'},
      {'name': 'Engine Wash', 'price': 7000, 'duration': '60 mins', 'description': 'Engine bay cleaning'},
    ],
    'House Cleaning': [
      {'name': 'Standard Cleaning', 'price': 15000, 'duration': '3 hours', 'description': 'Basic cleaning for 2-3 bedroom apartments'},
      {'name': 'Deep Cleaning', 'price': 25000, 'duration': '5 hours', 'description': 'Deep clean for 3-4 bedroom apartments'},
      {'name': 'Move In/Out', 'price': 35000, 'duration': '6 hours', 'description': 'Full move in/out cleaning'},
      {'name': 'Office Cleaning', 'price': 20000, 'duration': '4 hours', 'description': 'Professional office cleaning'},
    ],
    'Laundry': [
      {'name': 'Wash & Fold', 'price': 2000, 'duration': '24 hours', 'description': 'Wash, dry, and fold service'},
      {'name': 'Wash & Iron', 'price': 3500, 'duration': '24 hours', 'description': 'Wash, dry, and iron service'},
      {'name': 'Dry Cleaning', 'price': 5000, 'duration': '48 hours', 'description': 'Professional dry cleaning'},
      {'name': 'Ironing Only', 'price': 1500, 'duration': '12 hours', 'description': 'Ironing service only'},
    ],
  };

  final List<String> _timeSlots = [
    '9:00 AM', '10:30 AM', '12:00 PM', '1:30 PM', '3:00 PM', '4:30 PM', '6:00 PM'
  ];

  final List<String> _paymentMethods = ['Wallet', 'Card', 'Bank Transfer', 'Pay on Delivery'];

  @override
  void initState() {
    super.initState();
    if (widget.selectedService != null) {
      _selectedService = widget.selectedService!;
    }
    if (widget.selectedPrice != null) {
      _selectedServicePrice = widget.selectedPrice!;
    }
    if (widget.selectedAddress != null) {
      _selectedLocation = widget.selectedAddress!;
    }
    if (widget.serviceCategory != null) {
      _selectedCategory = widget.serviceCategory!;
    }
  }

  List<Map<String, dynamic>> get _currentServices {
    return _services[_selectedCategory] ?? _services['Car Wash']!;
  }

  Map<String, dynamic> get _currentServiceDetails {
    return _currentServices.firstWhere(
      (service) => service['name'] == _selectedService,
      orElse: () => _currentServices[0],
    );
  }

  void _showServicePicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Service',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: _currentServices.length,
                  itemBuilder: (context, index) {
                    final service = _currentServices[index];
                    final isSelected = service['name'] == _selectedService;
                    return ListTile(
                      tileColor: isSelected ? AppColors.primary.withOpacity(0.1) : null,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      title: Text(service['name']),
                      subtitle: Text('${service['priceDisplay']} - ${service['duration']}'),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle, color: AppColors.primary)
                          : null,
                      onTap: () {
                        setState(() {
                          _selectedService = service['name'];
                          _selectedServicePrice = service['price'];
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLocationPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Location'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.location_on, color: AppColors.primary),
              title: const Text('Lekki Phase 1, Lagos'),
              onTap: () {
                setState(() => _selectedLocation = 'Lekki Phase 1, Lagos');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.location_on, color: AppColors.primary),
              title: const Text('Victoria Island, Lagos'),
              onTap: () {
                setState(() => _selectedLocation = 'Victoria Island, Lagos');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.location_on, color: AppColors.primary),
              title: const Text('Ikeja, Lagos'),
              onTap: () {
                setState(() => _selectedLocation = 'Ikeja, Lagos');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.location_on, color: AppColors.primary),
              title: const Text('Surulere, Lagos'),
              onTap: () {
                setState(() => _selectedLocation = 'Surulere, Lagos');
                Navigator.pop(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  void _showPaymentPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Payment Method',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: _paymentMethods.length,
                  itemBuilder: (context, index) {
                    final method = _paymentMethods[index];
                    final isSelected = method == _selectedPaymentMethod;
                    return ListTile(
                      tileColor: isSelected ? AppColors.primary.withOpacity(0.1) : null,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      leading: Icon(
                        method == 'Wallet' ? Icons.wallet :
                        method == 'Card' ? Icons.credit_card :
                        method == 'Bank Transfer' ? Icons.account_balance :
                        Icons.payments,
                        color: AppColors.primary,
                      ),
                      title: Text(method),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle, color: AppColors.primary)
                          : null,
                      onTap: () {
                        setState(() => _selectedPaymentMethod = method);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _proceedToPayment() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(
          serviceName: _selectedService,
          amount: _selectedServicePrice,
          location: _selectedLocation,
          date: _selectedDate,
          time: _selectedTime,
          paymentMethod: _selectedPaymentMethod,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final serviceDetails = _currentServiceDetails;
    final servicePrice = serviceDetails['price'] ?? 0;
    final serviceDuration = serviceDetails['duration'] ?? '30 mins';
    final serviceDescription = serviceDetails['description'] ?? '';

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text(
          'Booking Details',
          style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Category Tabs - All Green
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: _categories.map((category) {
                final isSelected = _selectedCategory == category;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = category;
                        _selectedService = _services[category]![0]['name'];
                        _selectedServicePrice = _services[category]![0]['price'];
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: Text(
                          category,
                          style: TextStyle(
                            color: isSelected ? Colors.white : AppColors.primary,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Service Selected - Green
                  _buildSectionTitle('Service Selected'),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primary.withOpacity(0.1)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _selectedService,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '₦${NumberFormat('#,###').format(servicePrice)} · $serviceDuration',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (serviceDescription.isNotEmpty)
                                Text(
                                  serviceDescription,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: _showServicePicker,
                          child: const Text(
                            'Change',
                            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Delivery Location - Green
                  _buildSectionTitle('Delivery Location'),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primary.withOpacity(0.1)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on, color: AppColors.primary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _selectedLocation,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        TextButton(
                          onPressed: _showLocationPicker,
                          child: const Text(
                            'Change',
                            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Preferred Date & Time - Green
                  _buildSectionTitle('Preferred Date & Time'),

                  // Date Selection
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primary.withOpacity(0.1)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 60,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            itemCount: 7,
                            itemBuilder: (context, index) {
                              final date = DateTime.now().add(Duration(days: index));
                              final isSelected = _selectedDate.day == date.day &&
                                  _selectedDate.month == date.month;
                              final dayName = DateFormat('E').format(date);
                              final dayNumber = date.day.toString();
                              return GestureDetector(
                                onTap: () => setState(() => _selectedDate = date),
                                child: Container(
                                  width: 65,
                                  margin: const EdgeInsets.symmetric(horizontal: 4),
                                  decoration: BoxDecoration(
                                    color: isSelected ? AppColors.primary : AppColors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isSelected ? AppColors.primary : Colors.grey.shade300,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        index == 0 ? 'Today' : index == 1 ? 'Tomorrow' : dayName,
                                        style: TextStyle(
                                          color: isSelected ? Colors.white : Colors.grey,
                                          fontSize: 10,
                                        ),
                                      ),
                                      Text(
                                        dayNumber,
                                        style: TextStyle(
                                          color: isSelected ? Colors.white : Colors.black87,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const Divider(height: 16),
                        // Time Selection
                        SizedBox(
                          height: 50,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            itemCount: _timeSlots.length,
                            itemBuilder: (context, index) {
                              final time = _timeSlots[index];
                              final isSelected = _selectedTime == time;
                              return GestureDetector(
                                onTap: () => setState(() => _selectedTime = time),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  margin: const EdgeInsets.symmetric(horizontal: 4),
                                  decoration: BoxDecoration(
                                    color: isSelected ? AppColors.primary : AppColors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: isSelected ? AppColors.primary : Colors.grey.shade300,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      time,
                                      style: TextStyle(
                                        color: isSelected ? Colors.white : Colors.black87,
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Payment Method - Green
                  _buildSectionTitle('Payment Method'),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primary.withOpacity(0.1)),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _selectedPaymentMethod == 'Wallet' ? Icons.wallet :
                          _selectedPaymentMethod == 'Card' ? Icons.credit_card :
                          _selectedPaymentMethod == 'Bank Transfer' ? Icons.account_balance :
                          Icons.payments,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _selectedPaymentMethod,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        TextButton(
                          onPressed: _showPaymentPicker,
                          child: const Text(
                            'Change',
                            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Continue Button - Green
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _proceedToPayment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Proceed to Payment',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }
}