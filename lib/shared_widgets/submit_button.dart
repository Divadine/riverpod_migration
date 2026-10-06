import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_learning/core/theme/color.dart';
import 'package:riverpod_learning/shared_widgets/app_text.dart';

import 'app_icon_widget.dart';

class SubmitButton extends StatelessWidget{

  final String title;
  final VoidCallback onPressed;
  final Color? bgColor;
  final double? height;
  final double? width;
  final double? borderRadius;
  final bool isLoading;

  const SubmitButton({super.key, required this.title, required this.onPressed, this.bgColor,  this.height, this.width,  this.borderRadius, required this.isLoading});

  @override
  Widget build(BuildContext context) {

    final color = bgColor ?? AppColors.red;
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SizedBox(
        height: height ?? 45,
        width:width ?? double.infinity,
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            disabledBackgroundColor: isLoading ? color : color.withOpacity(0.6),
            foregroundColor: Colors.white,
            disabledForegroundColor: Colors.black,
            shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(8))
          ),
            child: isLoading ? SizedBox(height: 20, width: 20,child: CircularProgressIndicator(color: Colors.white,)) : AppText(text: title,fontSize: 14,color: Colors.white,),
        ),
      ),
    );
  }
}


class AppButton extends StatelessWidget {
  final String title;
  final void Function()? onTap;
  final String? icon;
  final String? prefixIcon;
  final Color? textColor;
  final Color? bgColor;
  final BoxBorder? border;
  final BorderRadiusGeometry? radius;
  final double? fontSize;
  final double? height;
  final double? width;
  final double? size;


  const AppButton({
    super.key,
    required this.title,
    required this.onTap,
    this.icon,
    this.prefixIcon,
    this.textColor,
    this.bgColor,
    this.border, this.radius, this.fontSize, this.height, this.width, this.size,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height ?? 40,
        width: width ?? double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: bgColor ?? AppColors.red,
          border: border,
          borderRadius: radius ?? BorderRadius.circular(20),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            spacing: 10,
            children: [
              if (prefixIcon != null) AppIconWidget(assetPath: prefixIcon!),

              Flexible(
                child: AppText(
                  text: title,
                  fontSize:fontSize ??  18,
                  color: textColor ?? AppColors.red,
                  textAlign: TextAlign.center,
                  maxLine: 1,
                  textOverflow: TextOverflow.ellipsis,
                ),
              ),

              if (icon != null) AppIconWidget(assetPath: icon!,size: size,),
            ],
          ),
        ),
      ),
    );
  }
}