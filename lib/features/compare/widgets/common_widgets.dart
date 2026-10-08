import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:riverpod_learning/core/theme/color.dart';

// ============================================================
// DOTTED BORDER (rounded rect with optional VS notches)
// ============================================================

class DottedBorderBox extends StatelessWidget {
  const DottedBorderBox({
    super.key,
    this.child,
    this.radius = 12,
    this.color = AppColors.primary,
    this.fillColor,
    this.strokeWidth = 1.5,
    this.dash = 2,
    this.gap = 2.5,
    this.hasLeftNotch = false,
    this.hasRightNotch = false,
    this.vsNotchRadius = 16.0,
    this.cornerNotch,
    this.notchRadius = 5,
  });

  final Widget? child;
  final double radius;
  final Color color;
  final Color? fillColor;
  final double strokeWidth;
  final double dash;
  final double gap;
  final bool hasLeftNotch;
  final bool hasRightNotch;
  final double vsNotchRadius;

  final double? cornerNotch;
  final double notchRadius;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DottedPainter(
        color,
        radius,
        fillColor,
        strokeWidth,
        dash,
        gap,
        hasLeftNotch,
        hasRightNotch,
        vsNotchRadius,
        cornerNotch,
        notchRadius,
      ),
      child: child,
    );
  }
}

class _DottedPainter extends CustomPainter {
  _DottedPainter(
    this.color,
    this.radius,
    this.fill,
    this.stroke,
    this.dash,
    this.gap,
    this.hasLeftNotch,
    this.hasRightNotch,
    this.vsNotchRadius,
    this.cornerNotch,
    this.notchRadius,
  );

  final Color color;
  final double radius;
  final Color? fill;
  final double stroke;
  final double dash;
  final double gap;
  final bool hasLeftNotch;
  final bool hasRightNotch;
  final double vsNotchRadius;
  final double? cornerNotch;
  final double notchRadius;

  Path _outline(Rect rect) {
    final l = rect.left;
    final t = rect.top;
    final r = rect.right;
    final b = rect.bottom;
    final cr = math.min(radius, math.min(rect.width, rect.height) / 2);
    final cy = rect.center.dy;
    final vr = math.min(vsNotchRadius, rect.height / 2 - cr);

    final path = Path();

    // Start top-left (after top-left corner)
    path.moveTo(l + cr, t);

    // Top edge & top-right corner
    final n = cornerNotch;
    if (n != null && n > 0) {
      final nr = notchRadius;
      path.lineTo(r - n - nr, t);
      path.arcToPoint(Offset(r - n, t + nr),
          radius: Radius.circular(nr), clockwise: true);
      path.lineTo(r - n, t + n - nr);
      path.arcToPoint(Offset(r - n + nr, t + n),
          radius: Radius.circular(nr), clockwise: false);
      path.lineTo(r - nr, t + n);
      path.arcToPoint(Offset(r, t + n + nr),
          radius: Radius.circular(nr), clockwise: true);
    } else {
      path.lineTo(r - cr, t);
      path.arcToPoint(Offset(r, t + cr),
          radius: Radius.circular(cr), clockwise: true);
    }

    // Right edge (top to bottom)
    if (hasRightNotch) {
      path.lineTo(r, cy - vr);
      path.arcToPoint(
        Offset(r, cy + vr),
        radius: Radius.circular(vr),
        clockwise: false,
      );
      path.lineTo(r, b - cr);
    } else {
      path.lineTo(r, b - cr);
    }

    // Bottom-right corner
    path.arcToPoint(Offset(r - cr, b),
        radius: Radius.circular(cr), clockwise: true);

    // Bottom edge
    path.lineTo(l + cr, b);

    // Bottom-left corner
    path.arcToPoint(Offset(l, b - cr),
        radius: Radius.circular(cr), clockwise: true);

    // Left edge (bottom to top)
    if (hasLeftNotch) {
      path.lineTo(l, cy + vr);
      path.arcToPoint(
        Offset(l, cy - vr),
        radius: Radius.circular(vr),
        clockwise: false,
      );
      path.lineTo(l, t + cr);
    } else {
      path.lineTo(l, t + cr);
    }

    // Top-left corner
    path.arcToPoint(Offset(l + cr, t),
        radius: Radius.circular(cr), clockwise: true);

    path.close();
    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final path = _outline((Offset.zero & size).deflate(stroke / 2));

    if (fill != null) {
      canvas.drawPath(path, Paint()..color = fill!);
    }

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.butt;

    final period = dash + gap;
    for (final metric in path.computeMetrics()) {
      final count = math.max(1, (metric.length / period).round());
      final step = metric.length / count;
      final dashLen = step * dash / period;

      for (var i = 0; i < count; i++) {
        final d = i * step;
        final end = d + dashLen;
        canvas.drawPath(metric.extractPath(d, end), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DottedPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.radius != radius ||
        oldDelegate.fill != fill ||
        oldDelegate.stroke != stroke ||
        oldDelegate.dash != dash ||
        oldDelegate.gap != gap ||
        oldDelegate.hasLeftNotch != hasLeftNotch ||
        oldDelegate.hasRightNotch != hasRightNotch ||
        oldDelegate.vsNotchRadius != vsNotchRadius ||
        oldDelegate.cornerNotch != cornerNotch ||
        oldDelegate.notchRadius != notchRadius;
  }
}

// ============================================================
// DASHED VERTICAL DIVIDER (between 2 cars in a pair card)
// ============================================================

class DashedVerticalLine extends StatelessWidget {
  const DashedVerticalLine({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1,
      height: double.infinity,
      child: CustomPaint(painter: _VLinePainter()),
    );
  }
}

class _VLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF9A9A9A)
      ..strokeWidth = 1;
    var y = 0.0;
    while (y < size.height) {
      canvas.drawLine(
          Offset(0.5, y), Offset(0.5, math.min(y + 3, size.height)), paint);
      y += 6;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ============================================================
// VS BADGE
// ============================================================

class VsBadge extends StatelessWidget {
  /// Red dotted circle with soft shadow - used between the slots on home.
  const VsBadge({
    super.key,
    this.borderColor = AppColors.primary,
    this.dash = 2.5,
    this.gap = 2.5,
    this.strokeWidth = 1.3,
    this.shadow = true,
    this.diameter = size,
    this.fontSize = 12,
  });

  /// Thin grey dashed circle (red "VS" text) - used in Popular / Recent cards.
  const VsBadge.outlined({super.key})
      : borderColor = const Color(0xFF9E9E9E),
        dash = 3,
        gap = 3,
        strokeWidth = 1,
        shadow = false,
        diameter = 32,
        fontSize = 10;

  static const double size = 38;

  final Color borderColor;
  final double dash;
  final double gap;
  final double strokeWidth;
  final bool shadow;
  final double diameter;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: shadow ? const Color(0xFFF7F7F7) : Colors.white,
        boxShadow: shadow
            ? const [
          BoxShadow(
              color: Color(0x1F000000),
              blurRadius: 8,
              offset: Offset(0, 1)),
        ]
            : null,
      ),
      child: DottedBorderBox(
        radius: diameter / 2,
        color: borderColor,
        dash: dash,
        gap: gap,
        strokeWidth: strokeWidth,
        child: Center(
          child: Text(
            'VS',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// CAR IMAGE with grey ellipse shadow. Falls back to an icon if
// the asset is missing, so the layout never breaks.
// ============================================================

class CarImage extends StatelessWidget {
  const CarImage({
    super.key,
    this.path,
    this.height = 70,
    this.shadowColor = const Color(0xFFE9E9E9),
  });

  final String? path;
  final double height;
  final Color shadowColor;

  @override
  Widget build(BuildContext context) {
    final fallback = Icon(Icons.directions_car_filled,
        size: height * 0.65, color: AppColors.primary);

    return SizedBox(
      height: height,
      width: height * 1.55,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SizedBox(
            width: height * 1.5,
            height: height * 0.3,
            child: ClipOval(child: ColoredBox(color: shadowColor)),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: height * 0.1),
            child: path == null
                ? fallback
                : Image.asset(
              path!,
              height: height * 0.85,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => fallback,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// SMALL HELPERS
// ============================================================

class PriceRow extends StatelessWidget {
  const PriceRow({
    super.key,
    required this.price,
    this.fontSize = 12,
    this.symbolSize,
    this.symbolWeight = FontWeight.w600,
    this.gap = 6,
  });

  final String price;
  final double fontSize;

  /// Size of the red ₹ (defaults to fontSize + 2).
  final double? symbolSize;
  final FontWeight symbolWeight;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('₹',
            style: TextStyle(
                color: AppColors.primary,
                fontSize: symbolSize ?? fontSize + 2,
                fontWeight: symbolWeight)),
        SizedBox(width: gap),
        Flexible(
          child: Text(price,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: AppColors.grey2, fontSize: fontSize)),
        ),
      ],
    );
  }
}

class IconLabel extends StatelessWidget {
  const IconLabel({
    super.key,
    required this.icon,
    required this.label,
    this.fontSize = 11,
    this.iconSize,
  });

  final IconData icon;
  final String label;
  final double fontSize;

  /// Defaults to fontSize + 2.
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: iconSize ?? fontSize + 2, color: AppColors.primary),
        const SizedBox(width: 4),
        Flexible(
          child: Text(label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: AppColors.grey2, fontSize: fontSize)),
        ),
      ],
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.onSeeAll});

  final String title;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.text)),
          if (onSeeAll != null)
            GestureDetector(
              onTap: onSeeAll,
              child: const Text('See all',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.primary)),
            ),
        ],
      ),
    );
  }
}