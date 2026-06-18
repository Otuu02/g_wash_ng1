// FILE: saved_addresses_screen.dart
// PURPOSE: Manage user's saved delivery addresses

import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/helpers.dart';

class SavedAddressesScreen extends StatefulWidget {
  const SavedAddressesScreen({super.key});

  @override
  State<SavedAddressesScreen> createState() => _SavedAddressesScreenState();
}

class _SavedAddressesScreenState extends State<SavedAddressesScreen> {
  List<Map<String, dynamic>> _addresses = [
    {
      'id': '1',
      'label': 'Home',
      'address': '12, Lekki Phase 1, Lagos',
      'isDefault': true,
    },
    {
      'id': '2',
      'label': 'Office',
      'address': '34, Victoria Island, Lagos',
      'isDefault': false,
    },
  ];

  void _addNewAddress() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 20,
          left: 20,
          right: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Add New Address',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Label (Home, Office, etc.)',
                prefixIcon: Icon(Icons.label),
              ),
              onChanged: (value) {},
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Full Address',
                prefixIcon: Icon(Icons.location_on),
              ),
              onChanged: (value) {},
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Helpers.showSnackBar(
                    context,
                    message: 'Address added successfully!',
                    isSuccess: true,
                  );
                },
                child: const Text('Save Address'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _setDefaultAddress(String id) {
    setState(() {
      for (var address in _addresses) {
        address['isDefault'] = address['id'] == id;
      }
    });
    Helpers.showSnackBar(
      context,
      message: 'Default address updated',
      isSuccess: true,
    );
  }

  void _deleteAddress(String id) {
    // Direct dialog instead of using helper
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Address'),
        content: const Text('Are you sure you want to delete this address?'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _addresses.removeWhere((address) => address['id'] == id);
              });
              Helpers.showSnackBar(
                context,
                message: 'Address deleted',
                isSuccess: true,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Addresses'),
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addNewAddress,
          ),
        ],
      ),
      body: _addresses.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_off, size: 80, color: AppColors.grey400),
                  const SizedBox(height: 16),
                  const Text(
                    'No saved addresses',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add your first address',
                    style: TextStyle(color: AppColors.grey600),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _addNewAddress,
                    child: const Text('Add Address'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _addresses.length,
              itemBuilder: (context, index) {
                final address = _addresses[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: address['isDefault']
                          ? AppColors.primary
                          : AppColors.grey300,
                      child: Icon(
                        address['label'] == 'Home' ? Icons.home : Icons.work,
                        color: address['isDefault'] ? Colors.white : AppColors.grey600,
                      ),
                    ),
                    title: Row(
                      children: [
                        Text(
                          address['label'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        if (address['isDefault']) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primaryBackground,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Default',
                              style: TextStyle(fontSize: 10, color: AppColors.primary),
                            ),
                          ),
                        ],
                      ],
                    ),
                    subtitle: Text(address['address']),
                    trailing: PopupMenuButton(
                      icon: const Icon(Icons.more_vert),
                      itemBuilder: (context) => [
                        if (!address['isDefault'])
                          const PopupMenuItem(
                            value: 'default',
                            child: Text('Set as Default'),
                          ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text('Delete', style: TextStyle(color: AppColors.error)),
                        ),
                      ],
                      onSelected: (value) {
                        if (value == 'default') {
                          _setDefaultAddress(address['id']);
                        } else if (value == 'delete') {
                          _deleteAddress(address['id']);
                        }
                      },
                    ),
                    onTap: () {
                      // Edit address functionality can be added here
                    },
                  ),
                );
              },
            ),
    );
  }
}