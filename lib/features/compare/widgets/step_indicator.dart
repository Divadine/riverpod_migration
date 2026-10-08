import 'package:flutter/material.dart';
import 'package:riverpod_learning/core/theme/color.dart';

/// 1 Brand ---- 2 Model ---- 3 Variant
class StepIndicator extends StatelessWidget {
  const StepIndicator({super.key, required this.currentStep});

  final int currentStep; // 0..2

  static const _labels = ['Brand', 'Model', 'Variant'];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
      child: Column(
        children: [
          Row(
            children: [
              for (var i = 0; i < 3; i++) ...[
                _Circle(number: i + 1, active: i <= currentStep),
                if (i < 2)
                  Expanded(
                    child: Container(
                      height: 1.5,
                      color: i < currentStep
                          ? AppColors.primary
                          : const Color(0xFFD5D5D5),
                    ),
                  ),
              ],
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (var i = 0; i < 3; i++)
                Text(
                  _labels[i],
                  style: TextStyle(
                    fontSize: 12,
                    color: i <= currentStep ? AppColors.primary : AppColors.grey2,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Circle extends StatelessWidget {
  const _Circle({required this.number, required this.active});

  final int number;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active ? AppColors.primary : AppColors.stepGrey,
      ),
      child: Text('$number',
          style: const TextStyle(
              color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }
}