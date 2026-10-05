import 'package:flutter/material.dart';
import 'package:riverpod_learning/core/theme/color.dart';
import 'package:riverpod_learning/features/cars/model/car_model.dart';

import 'car_card.dart';
import 'car_card_shell.dart';
import 'car_info_item.dart';
import 'car_rating_chip.dart';

class CarListCard extends StatelessWidget {
  final CarModel car;
  final VoidCallback? onTap;

  const CarListCard({super.key, required this.car, this.onTap});

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
            trailing: CarRatingChip(rating: car.rating),
            subtitleColor: AppColors.grey,
          ),
          const SizedBox(height: 6),
          Center(
            child: Image.asset('assets/images/logo1.png',
              //car.image,
              height: 120,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) =>
              const Icon(Icons.directions_car, size: 100),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                flex: 7,
                child:
                CarInfoItem(icon: Icons.currency_rupee, text: car.price),
              ),
              Expanded(
                flex: 7,
                child: CarInfoItem(
                    icon: Icons.local_gas_station_outlined, text: car.fuel),
              ),
              Expanded(
                flex: 4,
                child: CarInfoItem(
                    icon: Icons.thumb_up_alt_outlined, text: car.cc ?? ''),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                  flex: 7,
                  child: CarInfoItem(icon: Icons.speed, text: car.km)),
              Expanded(
                flex: 7,
                child:
                CarInfoItem(icon: Icons.person_outline, text: car.seats),
              ),
              Expanded(
                flex: 4,
                child: CarInfoItem(
                    icon: Icons.settings_outlined, text: car.gear ?? ''),
              ),
            ],
          ),
        ],
      ),
    );
  }
}