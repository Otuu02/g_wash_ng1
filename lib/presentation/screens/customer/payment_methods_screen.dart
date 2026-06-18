// FILE: lib/presentation/screens/customer/payment_methods_screen.dart
// PURPOSE: Manage payment methods - FULLY WORKING

import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/helpers.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  List<Map<String, dynamic>> _paymentMethods = [
    {
      'id': '1',
      'type': 'visa',
      'name': 'VISA',
      'last4': '4242',
      'expiry': '12/25',
      'isDefault': true,
    },
    {
      'id': '2',
      'type': 'mastercard',
      'name': 'Mastercard',
      'last4': '8888',
      'expiry': '08/26',
      'isDefault': false,
    },
  ];

  void _addPaymentMethod() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => AddCardBottomSheet(onAdd: _addCard),
    );
  }

  void _addCard(Map<String, dynamic> card) {
    setState(() {
      _paymentMethods.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'type': card['type'],
        'name': card['name'],
        'last4': card['last4'],
        'expiry': card['expiry'],
        'isDefault': false,
      });
    });
    Helpers.showSnackBar(context, message: 'Card added successfully!', isSuccess: true);
  }

  void _setDefaultPayment(String id) {
    setState(() {
      for (var method in _paymentMethods) {
        method['isDefault'] = method['id'] == id;
      }
    });
    Helpers.showSnackBar(context, message: 'Default payment method updated', isSuccess: true);
  }

  void _removePayment(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Card'),
        content: const Text('Are you sure you want to remove this card?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _paymentMethods.removeWhere((method) => method['id'] == id);
              });
              Navigator.pop(context);
              Helpers.showSnackBar(context, message: 'Card removed', isSuccess: true);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Methods'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addPaymentMethod,
          ),
        ],
      ),
      body: _paymentMethods.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.credit_card_off, size: 80, color: AppColors.grey400),
                  const SizedBox(height: 16),
                  const Text(
                    'No payment methods',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add your first card',
                    style: TextStyle(color: AppColors.grey600),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _addPaymentMethod,
                    child: const Text('Add Card'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _paymentMethods.length,
              itemBuilder: (context, index) {
                final method = _paymentMethods[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: Container(
                      width: 50,
                      height: 35,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.grey300),
                      ),
                      child: Center(
                        child: Text(
                          method['name'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: method['type'] == 'visa' ? Colors.blue : Colors.orange,
                          ),
                        ),
                      ),
                    ),
                    title: Row(
                      children: [
                        Text('•••• ${method['last4']}'),
                        if (method['isDefault']) ...[
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
                    subtitle: Text('Expires ${method['expiry']}'),
                    trailing: PopupMenuButton(
                      icon: const Icon(Icons.more_vert),
                      itemBuilder: (context) => [
                        if (!method['isDefault'])
                          const PopupMenuItem(
                            value: 'default',
                            child: Text('Set as Default'),
                          ),
                        const PopupMenuItem(
                          value: 'remove',
                          child: Text('Remove', style: TextStyle(color: AppColors.error)),
                        ),
                      ],
                      onSelected: (value) {
                        if (value == 'default') {
                          _setDefaultPayment(method['id']);
                        } else if (value == 'remove') {
                          _removePayment(method['id']);
                        }
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}

// Add Card Bottom Sheet
class AddCardBottomSheet extends StatefulWidget {
  final Function(Map<String, dynamic>) onAdd;
  const AddCardBottomSheet({super.key, required this.onAdd});

  @override
  State<AddCardBottomSheet> createState() => _AddCardBottomSheetState();
}

class _AddCardBottomSheetState extends State<AddCardBottomSheet> {
  final TextEditingController _cardNumber = TextEditingController();
  final TextEditingController _expiry = TextEditingController();
  final TextEditingController _cvv = TextEditingController();
  final TextEditingController _cardholderName = TextEditingController();
  String _cardType = 'visa';

  void _submit() {
    if (_cardNumber.text.length < 15) {
      Helpers.showSnackBar(context, message: 'Enter valid card number', isError: true);
      return;
    }
    if (_expiry.text.length < 5) {
      Helpers.showSnackBar(context, message: 'Enter valid expiry date (MM/YY)', isError: true);
      return;
    }
    if (_cvv.text.length < 3) {
      Helpers.showSnackBar(context, message: 'Enter valid CVV', isError: true);
      return;
    }
    if (_cardholderName.text.isEmpty) {
      Helpers.showSnackBar(context, message: 'Enter cardholder name', isError: true);
      return;
    }

    final last4 = _cardNumber.text.substring(_cardNumber.text.length - 4);
    widget.onAdd({
      'type': _cardType,
      'name': _cardType == 'visa' ? 'VISA' : 'Mastercard',
      'last4': last4,
      'expiry': _expiry.text,
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Add Card', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          // Card Type Selector
          Row(
            children: [
              Expanded(
                child: ChoiceChip(
                  label: const Text('VISA'),
                  selected: _cardType == 'visa',
                  onSelected: (selected) => setState(() => _cardType = 'visa'),
                  selectedColor: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ChoiceChip(
                  label: const Text('Mastercard'),
                  selected: _cardType == 'mastercard',
                  onSelected: (selected) => setState(() => _cardType = 'mastercard'),
                  selectedColor: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _cardNumber,
            decoration: const InputDecoration(
              labelText: 'Card Number',
              prefixIcon: Icon(Icons.credit_card),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,  // FIXED: Changed from TextInputTypes.number
            maxLength: 19,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _expiry,
                  decoration: const InputDecoration(
                    labelText: 'Expiry (MM/YY)',
                    prefixIcon: Icon(Icons.date_range),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.datetime,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _cvv,
                  decoration: const InputDecoration(
                    labelText: 'CVV',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  obscureText: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _cardholderName,
            decoration: const InputDecoration(
              labelText: 'Cardholder Name',
              prefixIcon: Icon(Icons.person),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submit,
              child: const Text('Add Card'),
            ),
          ),
        ],
      ),
    );
  }
}