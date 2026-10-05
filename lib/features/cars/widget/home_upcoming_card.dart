import 'package:flutter/material.dart';
import 'package:riverpod_learning/features/cars/model/car_model.dart';

import 'car_card.dart';
import 'car_card_shell.dart';
import 'car_info_item.dart';

class HomeUpcomingCard extends StatelessWidget {
  final CarModel car;
  final VoidCallback? onTap;

  const HomeUpcomingCard({super.key, required this.car, this.onTap});

  @override
  Widget build(BuildContext context) {
    final width = (MediaQuery.of(context).size.width - 28) / 1.5;

    return CarCardShell(
      width: width,
      onTap: onTap,
      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CarCardHeader(car: car), // trailing illa
          const SizedBox(height: 6),
          Center(
            child: Image.asset(
              car.image,
              height: 62,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) =>
              const Icon(Icons.directions_car, size: 50),
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