// FILE: order_history_screen.dart
// PURPOSE: Shows past orders with clickable details

import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import 'order_details_screen.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  // Sample order data - in production, this would come from API/database
  final List<Map<String, dynamic>> _orders = const [
    {
      'id': 'ORD-001',
      'title': 'Basic Wash',
      'price': '₦3,000',
      'date': '2026-04-30',
      'time': '10:30 AM',
      'duration': '30 mins',
      'status': 'Completed',
      'address': '12, Lekki Phase 1, Lagos',
      'washerName': 'Michael O.',
      'washerPhone': '+234 802 345 6789',
      'paymentMethod': 'Card',
      'transactionId': 'TXN123456789',
    },
    {
      'id': 'ORD-002',
      'title': 'Interior Cleaning',
      'price': '₦5,000',
      'date': '2026-04-29',
      'time': '2:15 PM',
      'duration': '45 mins',
      'status': 'Completed',
      'address': '34, Victoria Island, Lagos',
      'washerName': 'David E.',
      'washerPhone': '+234 803 456 7890',
      'paymentMethod': 'Transfer',
      'transactionId': 'TXN987654321',
    },
    {
      'id': 'ORD-003',
      'title': 'Full Detailing',
      'price': '₦10,000',
      'date': '2026-04-28',
      'time': '9:00 AM',
      'duration': '90 mins',
      'status': 'Completed',
      'address': '56, Ikoyi, Lagos',
      'washerName': 'James O.',
      'washerPhone': '+234 804 567 8901',
      'paymentMethod': 'Card',
      'transactionId': 'TXN456789123',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _orders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 80, color: AppColors.grey400),
                  const SizedBox(height: 16),
                  const Text(
                    'No orders yet',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your order history will appear here',
                    style: TextStyle(color: AppColors.grey600),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _orders.length,
              itemBuilder: (context, index) {
                final order = _orders[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderDetailsScreen(order: order),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.green.shade50,
                                child: Icon(
                                  order['title'] == 'Basic Wash'
                                      ? Icons.cleaning_services
                                      : order['title'] == 'Interior Cleaning'
                                          ? Icons.event_seat
                                          : Icons.star,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      order['title'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${order['date']} • ${order['time']}',
                                      style: TextStyle(
                                        color: AppColors.grey600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    order['price'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: order['status'] == 'Completed'
                                          ? Colors.green.withOpacity(0.1)
                                          : Colors.orange.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      order['status'],
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: order['status'] == 'Completed'
                                            ? Colors.green
                                            : Colors.orange,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.location_on,
                                  size: 14, color: AppColors.grey500),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  order['address'],
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.grey600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.access_time,
                                  size: 14, color: AppColors.grey500),
                              const SizedBox(width: 4),
                              Text(
                                order['duration'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.grey600,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Icon(Icons.payment,
                                  size: 14, color: AppColors.grey500),
                              const SizedBox(width: 4),
                              Text(
                                order['paymentMethod'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.grey600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => OrderDetailsScreen(order: order),
                                    ),
                                  );
                                },
                                child: const Text('View Details'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}