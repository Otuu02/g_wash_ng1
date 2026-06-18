// FILE: lib/presentation/widgets/price_card.dart
// PURPOSE: Displays price information in a card

import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/formatters.dart';

class PriceCard extends StatelessWidget {
  final int price;
  final String? title;
  final String? subtitle;
  final bool showOriginalPrice;
  final int? originalPrice;
  
  const PriceCard({
    super.key,
    required this.price,
    this.title,
    this.subtitle,
    this.showOriginalPrice = false,
    this.originalPrice,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.grey600,
              ),
            ),
            const SizedBox(height: 4),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: const TextStyle(fontSize: 14),
                ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (showOriginalPrice && originalPrice != null)
                    Text(
                      Formatters.formatCurrency(originalPrice!),
                      style: const TextStyle(
                        fontSize: 14,
                        decoration: TextDecoration.lineThrough,
                        color: AppColors.grey500,
                      ),
                    ),
                  Text(
                    Formatters.formatCurrency(price),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}