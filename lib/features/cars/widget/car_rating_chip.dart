import 'package:flutter/material.dart';
import 'package:riverpod_learning/core/theme/color.dart';


class CarRatingChip extends StatelessWidget {
  final double rating;
  const CarRatingChip({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.redSoft,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            rating.toStringAsFixed(0),
            style: TextStyle(fontSize: 12, color: AppColors.red),
          ),
          const SizedBox(width: 3),
          const Icon(Icons.star, size: 14, color: AppColors.red),
        ],
      ),
    );
  }
}