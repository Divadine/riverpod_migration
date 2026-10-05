import 'package:flutter/material.dart';
import 'package:riverpod_learning/core/theme/color.dart';

class CarCardShell extends StatelessWidget {
  final Widget child;
  final double? width;
  final VoidCallback? onTap;

  const CarCardShell({
    super.key,
    required this.child,
    this.width,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0F000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}