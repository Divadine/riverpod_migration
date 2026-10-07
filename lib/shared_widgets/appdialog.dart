import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_learning/core/theme/color.dart';
import 'package:riverpod_learning/shared_widgets/submit_button.dart';

import 'app_icon_widget.dart';
import 'app_text.dart';
import 'asset_images.dart';

class AppDialogue {
  static Future<bool> showPopup({
    required BuildContext context,
    required Widget content,
    bool showCloseIcon = false,
    EdgeInsetsGeometry contentPadding = const EdgeInsets.all(15),
    EdgeInsets? insetPadding,
    Color backgroundColor = AppColors.white,
    double radius = 12,
    BorderSide borderSides = BorderSide.none,
  }) async {
    const double btnSize = 30;
    const double gap = 6;

    final result = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: insetPadding ??
              const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Dialog body with the notch cut out of the top-right corner
              ClipPath(
                clipper: _NotchClipper(
                  radius: radius,
                  notchWidth: showCloseIcon ? btnSize + gap : 0,
                  notchHeight: showCloseIcon ? btnSize + gap : 0,
                ),
                child: Container(
                  color: backgroundColor,
                  padding: contentPadding,
                  child: content,
                ),
              ),

              // Close button sitting inside the notch
              if (showCloseIcon)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Material(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(8),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () => Navigator.of(context).pop(),
                      child: SizedBox(
                        width: btnSize,
                        height: btnSize,
                        child: Center(
                          child: Icon(
                            Icons.close,
                            size: 20,
                            color: Colors.red, // use your AppColors.red
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
    return result == true;
  }
}

class _NotchClipper extends CustomClipper<Path> {
  final double radius;
  final double notchWidth;
  final double notchHeight;
  final double innerRadius;

  _NotchClipper({
    required this.radius,
    required this.notchWidth,
    required this.notchHeight,
    this.innerRadius = 8,
  });

  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;
    final r = radius;
    final path = Path();

    // No notch: plain rounded rectangle
    if (notchWidth == 0) {
      return path
        ..addRRect(RRect.fromRectAndRadius(
            Offset.zero & size, Radius.circular(r)));
    }

    final ir = innerRadius;
    final nx = w - notchWidth; // x where the notch starts

    path.moveTo(r, 0);
    path.lineTo(nx - r, 0);
    // convex corner (top edge -> down into notch)
    path.arcToPoint(Offset(nx, r),
        radius: Radius.circular(r), clockwise: true);
    path.lineTo(nx, notchHeight - ir);
    // concave inner corner of the notch
    path.arcToPoint(Offset(nx + ir, notchHeight),
        radius: Radius.circular(ir), clockwise: false);
    path.lineTo(w - r, notchHeight);
    // convex corner below the button
    path.arcToPoint(Offset(w, notchHeight + r),
        radius: Radius.circular(r), clockwise: true);
    path.lineTo(w, h - r);
    path.arcToPoint(Offset(w - r, h),
        radius: Radius.circular(r), clockwise: true);
    path.lineTo(r, h);
    path.arcToPoint(Offset(0, h - r),
        radius: Radius.circular(r), clockwise: true);
    path.lineTo(0, r);
    path.arcToPoint(Offset(r, 0),
        radius: Radius.circular(r), clockwise: true);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant _NotchClipper old) =>
      old.radius != radius ||
          old.notchWidth != notchWidth ||
          old.notchHeight != notchHeight;
}

class AppSnackBar {
  static void show({
    required BuildContext context,
    required String message,
    IconData icon = Icons.info_outline,
    Color backgroundColor = AppColors.white,
    Color textColor = AppColors.black,
    Duration duration = const Duration(seconds: 2),
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 6,
          duration: duration,
          backgroundColor: backgroundColor,
          content: Row(
            children: [
              Icon(icon, color: textColor),
              const SizedBox(width: 10),
              Expanded(
                child: AppText(text: message, color: textColor),
              ),
            ],
          ),
        ),
      );
  }
}



