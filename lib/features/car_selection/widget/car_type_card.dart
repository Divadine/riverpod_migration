import 'package:flutter/material.dart';
import 'package:riverpod_learning/core/theme/color.dart';
import 'package:riverpod_learning/shared_widgets/app_icon_widget.dart';
import 'package:riverpod_learning/shared_widgets/app_text.dart';
import '../model/car_type_item.dart';

class CarTypeCards extends StatelessWidget {
  final CarTypeItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const CarTypeCards({
    super.key,
    required this.item,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:  const Color(0xFFEAEAEA),
            width: isSelected ? 1.5 : 1.0,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.02),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.cardCar,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: AppIconWidget(
                    assetPath: item.image,
                    size: 48,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            AppText(
              text: item.name,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black,
              textAlign: TextAlign.center,
              maxLine: 1,
              textOverflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
          ],
        ),
      ),
    );
  }
}