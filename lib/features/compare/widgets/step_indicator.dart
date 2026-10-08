import 'package:flutter/material.dart';
import 'package:riverpod_learning/core/theme/color.dart';
import 'package:riverpod_learning/shared_widgets/app_text.dart';

class StepIndicator extends StatelessWidget {
  const StepIndicator({super.key, required this.currentStep});

  final int currentStep;
  static const _labels = ['Brand', 'Model', 'Variant'];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              for (var i = 0; i < 3; i++) ...[
                _Circle(number: i + 1, active: i <= currentStep),

                if (i < 2)
                  Expanded(
                    child: Container(
                      height: 1.5,
                      color: i < currentStep ? AppColors.primary  : AppColors.stepGrey,


                    ),
                  ),
              ],
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              for (var i = 0; i < 3; i++) ...[
                SizedBox(
                  width: 30,
                  height: 16,
                  child: Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        width: 80,
                        child: AppText(
                            text: _labels[i],
                          textAlign: TextAlign.center,
                          color: i <= currentStep ? AppColors.primary : AppColors.stepGrey,fontWeight:FontWeight.w400,fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                if (i < 2) const Spacer(),
              ],
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
    final color = active ? AppColors.primary : const Color(0xFF808080);

    return Container(
      width: 30,
      height: 30,
      padding: const EdgeInsets.all(2.5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
      ),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
        child: Text(
          '$number',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}