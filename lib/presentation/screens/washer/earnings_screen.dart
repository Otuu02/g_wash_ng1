// FILE: lib/presentation/screens/washer/earnings_screen.dart
// PURPOSE: Display washer earnings and withdrawal options

import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class EarningsScreen extends StatefulWidget {
  const EarningsScreen({super.key});

  @override
  State<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends State<EarningsScreen> {
  int _selectedPeriod = 0; // 0: Today, 1: Week, 2: Month
  bool _isLoading = false;

  final Map<String, dynamic> _earningsData = {
    'today': {'earnings': 12500, 'jobs': 3},
    'week': {'earnings': 45200, 'jobs': 12},
    'month': {'earnings': 187500, 'jobs': 47},
    'total': 245000,
  };

  final List<Map<String, dynamic>> _recentTransactions = [
    {'date': 'May 5, 2024', 'amount': 3000, 'jobId': 'JOB-001', 'customer': 'David O.'},
    {'date': 'May 4, 2024', 'amount': 5000, 'jobId': 'JOB-002', 'customer': 'Sarah A.'},
    {'date': 'May 3, 2024', 'amount': 10000, 'jobId': 'JOB-003', 'customer': 'John M.'},
    {'date': 'May 2, 2024', 'amount': 7000, 'jobId': 'JOB-004', 'customer': 'Mary B.'},
  ];

  void _withdraw() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Withdraw Earnings',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('Available Balance: ₦245,000'),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Amount',
                prefixText: '₦',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            const Text('Withdraw to:'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.grey300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.account_balance),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('UBA'),
                        Text('******7890', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() => _isLoading = true);
                  Future.delayed(const Duration(seconds: 2), () {
                    setState(() => _isLoading = false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Withdrawal request submitted!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  });
                },
                child: const Text('Request Withdrawal'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final periodData = _selectedPeriod == 0 ? _earningsData['today'] :
                       _selectedPeriod == 1 ? _earningsData['week'] :
                       _earningsData['month'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Earnings'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Total Balance Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Text(
                    'Total Earnings',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '₦${_earningsData['total']}',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: _withdraw,
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primary,
                      ),
                      child: const Text('Withdraw'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Period Selector
            Row(
              children: [
                Expanded(
                  child: _buildPeriodButton('Today', 0),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildPeriodButton('This Week', 1),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildPeriodButton('This Month', 2),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Period Stats
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Earnings',
                    '₦${periodData['earnings']}',
                    Icons.money,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Jobs Completed',
                    '${periodData['jobs']}',
                    Icons.work,
                    Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Recent Transactions
            const Text(
              'Recent Transactions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _recentTransactions.length,
              itemBuilder: (context, index) {
                final transaction = _recentTransactions[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primaryBackground,
                      child: const Icon(Icons.payment, size: 20, color: AppColors.primary),
                    ),
                    title: Text('Job #${transaction['jobId']}'),
                    subtitle: Text(transaction['customer']),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '+₦${transaction['amount']}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        Text(
                          transaction['date'],
                          style: const TextStyle(fontSize: 10, color: AppColors.grey500),
                        ),
                      ],
                    ),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Transaction details for Job ${transaction['jobId']}')),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodButton(String label, int index) {
    final isSelected = _selectedPeriod == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedPeriod = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.grey300,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.grey700,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(height: 4),
          Text(title, style: TextStyle(color: AppColors.grey600, fontSize: 12)),
        ],
      ),
    );
  }
}