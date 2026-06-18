// FILE: order_details_screen.dart
// PURPOSE: Show detailed information about a specific order

import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/helpers.dart';

class OrderDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderDetailsScreen({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          order['status'] == 'Completed'
                              ? Icons.check_circle
                              : Icons.pending,
                          color: order['status'] == 'Completed'
                              ? AppColors.success
                              : AppColors.warning,
                          size: 30,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Order #${order['id']}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                order['status'],
                                style: TextStyle(
                                  color: order['status'] == 'Completed'
                                      ? AppColors.success
                                      : AppColors.warning,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Service Details
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Service Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow('Service Type', order['title']),
                    _buildDetailRow('Amount', order['price']),
                    _buildDetailRow('Date', order['date']),
                    _buildDetailRow('Time', order['time'] ?? '10:30 AM'),
                    _buildDetailRow('Duration', order['duration'] ?? '30 mins'),
                    _buildDetailRow('Payment Method', order['paymentMethod'] ?? 'Card'),
                    _buildDetailRow('Transaction ID', order['transactionId'] ?? 'TXN123456'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Location Details
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Location Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow('Delivery Address', order['address'] ?? 'Lekki, Lagos'),
                    _buildDetailRow('Washer Name', order['washerName'] ?? 'John Doe'),
                    _buildDetailRow('Washer Phone', order['washerPhone'] ?? '+234 801 234 5678'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Rating Section
            if (order['status'] == 'Completed')
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Rate Your Experience',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              Helpers.showSnackBar(
                                context,
                                message: 'Thank you for rating!',
                                isSuccess: true,
                              );
                            },
                            icon: const Icon(Icons.star_border, size: 40),
                          ),
                          IconButton(
                            onPressed: () {
                              Helpers.showSnackBar(
                                context,
                                message: 'Thank you for rating!',
                                isSuccess: true,
                              );
                            },
                            icon: const Icon(Icons.star_border, size: 40),
                          ),
                          IconButton(
                            onPressed: () {
                              Helpers.showSnackBar(
                                context,
                                message: 'Thank you for rating!',
                                isSuccess: true,
                              );
                            },
                            icon: const Icon(Icons.star_border, size: 40),
                          ),
                          IconButton(
                            onPressed: () {
                              Helpers.showSnackBar(
                                context,
                                message: 'Thank you for rating!',
                                isSuccess: true,
                              );
                            },
                            icon: const Icon(Icons.star_border, size: 40),
                          ),
                          IconButton(
                            onPressed: () {
                              Helpers.showSnackBar(
                                context,
                                message: 'Thank you for rating!',
                                isSuccess: true,
                              );
                            },
                            icon: const Icon(Icons.star_border, size: 40),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.grey600,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}