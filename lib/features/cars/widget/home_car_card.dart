import 'package:flutter/material.dart';
import 'package:riverpod_learning/features/cars/model/car_model.dart';

import 'car_card.dart';
import 'car_card_shell.dart';
import 'car_info_item.dart';
import 'car_rating_chip.dart';

class HomeCarCard extends StatelessWidget {
  final CarModel car;
  final VoidCallback? onTap;

  const HomeCarCard({super.key, required this.car, this.onTap});

  @override
  Widget build(BuildContext context) {

    final width = (MediaQuery.of(context).size.width - 28) / 1.5;

    return CarCardShell(
      width: width,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CarCardHeader(car: car, trailing: CarRatingChip(rating: car.rating)),
          const SizedBox(height: 6),
          Center(
            child: Image.asset( 'assets/images/logo1.png',
              //car.image,
              height: 62,
              fit: BoxFit.contain,
              errorBuilder: (a,b,c) =>
              const Icon(Icons.directions_car, size: 50),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                  child: CarInfoItem(
                      icon: Icons.currency_rupee, text: car.price)),
              //Spacer(),
              const SizedBox(width: 8),
              SizedBox(
                width: 80,
                child: CarInfoItem(
                    icon: Icons.local_gas_station_outlined, text: car.fuel),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(child: CarInfoItem(icon: Icons.speed, text: car.km)),
              //Spacer(),
              const SizedBox(width: 8),
              SizedBox(
                width: 80,
                child: CarInfoItem(
                    icon: Icons.person_outline, text: car.seats),
              ),
            ],
          ),
        ],
      ),
    );
  }
}