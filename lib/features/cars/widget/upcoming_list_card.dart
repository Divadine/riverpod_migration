import 'package:flutter/material.dart';
import 'package:riverpod_learning/core/theme/color.dart';
import 'package:riverpod_learning/features/cars/model/car_model.dart';

import 'car_bookmark_button.dart';
import 'car_card.dart';
import 'car_card_shell.dart';
import 'car_info_item.dart';

class UpcomingListCard extends StatelessWidget {
  final CarModel car;
  final VoidCallback? onTap;

  const UpcomingListCard({super.key, required this.car, this.onTap});

  @override
  Widget build(BuildContext context) {
    return CarCardShell(
      width: double.infinity,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CarCardHeader(
            car: car,
            trailing: CarBookmarkButton(carId: car.id),
            subtitleColor: AppColors.grey,
          ),
          const SizedBox(height: 6),
          Center(
            child: Image.asset(
              car.image,
              height: 130,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) =>
              const Icon(Icons.directions_car, size: 100),
            ),
          ),
          const SizedBox(height: 8),
          CarInfoItem(
            icon: Icons.calendar_month_outlined,
            text: car.launchDate ?? '',
          ),
        ],
      ),
    );
  }
}