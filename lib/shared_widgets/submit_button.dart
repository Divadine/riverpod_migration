import 'package:flutter/material.dart';
import 'package:riverpod_learning/core/theme/color.dart';
import 'package:riverpod_learning/shared_widgets/app_text.dart';

import 'app_icon_widget.dart';

class AppButton extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  final String? icon;
  final String? prefixIcon;

  final Color? textColor;
  final Color? bgColor;

  final BoxBorder? border;
  final BorderRadiusGeometry? radius;

  final double? fontSize;
  final double? height;
  final double? width;
  final double? iconSize;

  final bool isLoading;

  const AppButton({
    super.key,
    required this.title,
    required this.onTap,
    this.icon,
    this.prefixIcon,
    this.textColor,
    this.bgColor,
    this.border,
    this.radius,
    this.fontSize,
    this.height,
    this.width,
    this.iconSize,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        height: height ?? 40,
        width: width ?? double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: bgColor ?? AppColors.red,
          border: border,
          borderRadius: radius ?? BorderRadius.circular(8),
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          )
              : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (prefixIcon != null)
                AppIconWidget(
                  assetPath: prefixIcon!,
                  size: iconSize,
                ),

              if (prefixIcon != null)
                const SizedBox(width: 10),

              Flexible(
                child: AppText(
                  text: title,
                  fontSize: fontSize ?? 18,
                  color: textColor ?? Colors.white,
                  textAlign: TextAlign.center,
                  maxLine: 1,
                  textOverflow: TextOverflow.ellipsis,
                ),
              ),

              if (icon != null)
                const SizedBox(width: 10),

              if (icon != null)
                AppIconWidget(
                  assetPath: icon!,
                  size: iconSize,
                ),
            ],
          ),
        ),
      ),
    );
  }
}