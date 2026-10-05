import 'package:flutter/material.dart';
import 'package:riverpod_learning/core/theme/color.dart';


class CarInfoItem extends StatelessWidget {
  final IconData icon;
  final String text;
  const CarInfoItem({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: AppColors.red),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11, color: AppColors.grey),
          ),
        ),
      ],
    );
  }
}