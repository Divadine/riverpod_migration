import 'package:flutter/material.dart';
import 'package:riverpod_learning/core/theme/color.dart';
import 'package:riverpod_learning/features/compare/models/car_model.dart';

import 'common_widgets.dart';

/// "Popular Compare" / "Recent Compare" card: two cars + dashed divider + VS.
/// Height comes from the parent list; the car image scales with the card.
class ComparePairCard extends StatelessWidget {
  const ComparePairCard(
      {super.key, required this.pair, required this.width, this.onTap});

  final ComparePair pair;
  final double width;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border2, width: 1.0),
        ),
        child: LayoutBuilder(builder: (context, box) {
          final h = box.maxHeight;
          // text block (title + subtitle + price) is ~78px tall incl. padding
          const textBlock = 78.0;
          final imageArea = (h - textBlock).clamp(40.0, 400.0);
          final carHeight = (width * 0.26).clamp(56.0, 100.0);
          // centre of the image area, minus half the 40px halo
          final vsTop = textBlock + imageArea / 2 - 20;

          return Stack(
            children: [
              Row(
                children: [
                  Expanded(
                      child: _Half(
                          car: pair.first,
                          carHeight: carHeight.toDouble(),
                          isRight: false)),
                  const DashedVerticalLine(),
                  Expanded(
                      child: _Half(
                          car: pair.second,
                          carHeight: carHeight.toDouble(),
                          isRight: true)),
                ],
              ),
              // white halo so the divider stops just before the dashed ring
              Positioned(
                top: vsTop,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
                    child: const VsBadge.outlined(),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _Half extends StatelessWidget {
  const _Half(
      {required this.car, required this.carHeight, required this.isRight});

  final SelectedCar car;
  final double carHeight;
  final bool isRight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(isRight ? 20 : 16, 12, isRight ? 8 : 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(car.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontSize: 14,
                  height: 1.25,
                  fontWeight: FontWeight.w500,
                  color: AppColors.text)),
          const SizedBox(height: 5),
          Text(car.subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontSize: 12, height: 1.25, color: AppColors.grey2)),
          const SizedBox(height: 5),
          PriceRow(
            price: car.price,
            fontSize: 12,
            symbolSize: 15,
            symbolWeight: FontWeight.w400,
            gap: 8,
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: CarImage(
                  path: car.image,
                  height: carHeight,
                  shadowColor: const Color(0xFFD9D9D9),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}