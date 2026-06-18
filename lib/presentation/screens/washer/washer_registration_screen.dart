// FILE: lib/presentation/screens/washer/washer_registration_screen.dart
// PURPOSE: Complete washer registration form

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../services/auth_service.dart';
import 'washer_dashboard.dart';

class WasherRegistrationScreen extends StatefulWidget {
  const WasherRegistrationScreen({super.key});

  @override
  State<WasherRegistrationScreen> createState() => _WasherRegistrationScreenState();
}

class _WasherRegistrationScreenState extends State<WasherRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _accountNameController = TextEditingController();
  
  // Selected values
  String _selectedVehicleType = 'Motorcycle';
  double _workingRadius = 10;
  String _selectedBank = 'Access Bank';
  
  // State
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _agreeToTerms = false;
  
  final List<String> _vehicleTypes = ['Motorcycle', 'Car', 'Van', 'Truck', 'SUV'];
  final List<String> _banks = [
    'Access Bank', 'GTBank', 'First Bank', 'UBA', 'Zenith Bank',
    'Union Bank', 'Fidelity Bank', 'Ecobank', 'Stanbic IBTC', 'Polaris Bank'
  ];

  Future<void> _registerWasher() async {
    // Validate form
    if (!_formKey.currentState!.validate()) {
      _showError('Please fill all required fields');
      return;
    }
    
    // Check terms agreement
    if (!_agreeToTerms) {
      _showError('Please agree to the terms and conditions');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      
      // Step 1: Create account (signup)
      final signupSuccess = await authService.signup(
        _nameController.text.trim(),
        _phoneController.text.trim(),
        _passwordController.text.trim(),
      );

      if (!signupSuccess) {
        _showError('Account creation failed. Phone number may already exist.');
        setState(() => _isLoading = false);
        return;
      }
      
      // Step 2: Save washer specific data
      final userId = authService.getCurrentUserId();
      if (userId == null) {
        _showError('User ID not found. Please try again.');
        setState(() => _isLoading = false);
        return;
      }
      
      await authService.saveWasherData(
        uid: userId,
        vehicleType: _selectedVehicleType,
        workingRadius: _workingRadius.toInt(),
        bankName: _selectedBank,
        accountNumber: _accountNumberController.text.trim(),
        accountName: _accountNameController.text.trim(),
      );
      
      // Step 3: Force a reload of user data to ensure status is saved
      await authService.reloadUserData();
      
      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration submitted! Awaiting admin approval.'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
        
        // Navigate to dashboard (will show pending screen)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WasherDashboard()),
        );
      }
    } catch (e) {
      _showError(e.toString());
      setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Become a Washer',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    const Center(
                      child: Column(
                        children: [
                          Icon(Icons.emoji_transportation, size: 60, color: AppColors.primary),
                          SizedBox(height: 8),
                          Text(
                            'Join Our Washer Network',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Start earning by washing cars',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Personal Information Section
                    const Text(
                      'Personal Information',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                    const SizedBox(height: 16),
                    
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'Enter your name' : null,
                    ),
                    const SizedBox(height: 12),
                    
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        prefixText: '+234 ',
                        prefixIcon: Icon(Icons.phone),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'Enter phone number' : null,
                    ),
                    const SizedBox(height: 12),
                    
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email Address',
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'Enter email' : null,
                    ),
                    const SizedBox(height: 12),
                    
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Enter password';
                        if (value.length < 6) return 'Password must be at least 6 characters';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Confirm Password',
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value != _passwordController.text) return 'Passwords do not match';
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    
                    // Vehicle Information Section
                    const Text(
                      'Vehicle Information',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                    const SizedBox(height: 16),
                    
                    DropdownButtonFormField(
                      value: _selectedVehicleType,
                      decoration: const InputDecoration(
                        labelText: 'Vehicle Type',
                        prefixIcon: Icon(Icons.directions_car),
                        border: OutlineInputBorder(),
                      ),
                      items: _vehicleTypes.map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      )).toList(),
                      onChanged: (value) => setState(() => _selectedVehicleType = value!),
                    ),
                    const SizedBox(height: 16),
                    
                    const Text('Working Radius (km)'),
                    Slider(
                      value: _workingRadius,
                      min: 5,
                      max: 20,
                      divisions: 15,
                      label: '${_workingRadius.toInt()} km',
                      onChanged: (value) => setState(() => _workingRadius = value),
                      activeColor: AppColors.primary,
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBackground,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'You will serve customers within ${_workingRadius.toInt()} km radius',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Bank Information Section
                    const Text(
                      'Bank Information',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                    const SizedBox(height: 16),
                    
                    DropdownButtonFormField(
                      value: _selectedBank,
                      decoration: const InputDecoration(
                        labelText: 'Select Bank',
                        prefixIcon: Icon(Icons.account_balance),
                        border: OutlineInputBorder(),
                      ),
                      items: _banks.map((bank) => DropdownMenuItem(
                        value: bank,
                        child: Text(bank),
                      )).toList(),
                      onChanged: (value) => setState(() => _selectedBank = value!),
                    ),
                    const SizedBox(height: 12),
                    
                    TextFormField(
                      controller: _accountNumberController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Account Number',
                        prefixIcon: Icon(Icons.numbers),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'Enter account number' : null,
                    ),
                    const SizedBox(height: 12),
                    
                    TextFormField(
                      controller: _accountNameController,
                      decoration: const InputDecoration(
                        labelText: 'Account Name',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'Enter account name' : null,
                    ),
                    const SizedBox(height: 24),
                    
                    // Terms and Conditions
                    Row(
                      children: [
                        Checkbox(
                          value: _agreeToTerms,
                          onChanged: (value) => setState(() => _agreeToTerms = value!),
                          activeColor: AppColors.primary,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _showTermsDialog(),
                            child: const Text(
                              'I agree to the Terms of Service and Privacy Policy',
                              style: TextStyle(color: AppColors.primary),
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _registerWasher,
                        child: const Text(
                          'Submit Application',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Info Box
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.blue.shade700),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Your application will be reviewed by admin within 24-48 hours.',
                              style: TextStyle(color: Colors.blue.shade700, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms of Service'),
        content: const SingleChildScrollView(
          child: Text(
            'G Wash NG Washer Terms\n\n'
            '1. You must be at least 18 years old\n'
            '2. You must have a valid driver\'s license\n'
            '3. You agree to a background check\n'
            '4. 15% commission on each job\n'
            '5. You must maintain 4.0+ rating\n'
            '6. Cancellation policy applies\n'
            '7. Payments are processed weekly\n'
            '8. You are an independent contractor\n'
            '9. G Wash NG reserves the right to suspend accounts\n\n'
            'By registering, you agree to all terms.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}