import 'package:flutter/material.dart';
import 'package:riverpod_learning/core/theme/color.dart';
import 'package:riverpod_learning/features/compare/models/car_model.dart';
import 'common_widgets.dart';

/// One dotted "slot" on the home screen: empty ("Select Car") or filled.
class CompareSlotCard extends StatelessWidget {
  const CompareSlotCard({
    super.key,
    required this.car,
    required this.onTap,
    required this.onRemove,
    this.showLeadingVs = false,
    this.hasTrailingVs = false,
  });

  final SelectedCar? car;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  /// Draws the VS badge on the left edge (between this and previous slot).
  final bool showLeadingVs;

  /// Whether there is a slot to the right (so the border breaks at the VS).
  final bool hasTrailingVs;

  static const double _radius = 5;

  // close button: flush with the card corner, border goes around it
  static const double _closeSize = 20;
  static const double _closeGap = 4; // clear space between border and button
  static const double _notch = _closeSize + _closeGap; // 24

  static const double _vsNotchRadius = 16.0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTap,
            child: DottedBorderBox(
              radius: _radius,
              fillColor: Colors.white,
              cornerNotch: car != null ? _notch : null,
              hasLeftNotch: showLeadingVs,
              hasRightNotch: hasTrailingVs,
              vsNotchRadius: _vsNotchRadius,
              child: car == null
                  ? const _EmptySlot()
                  : _FilledSlot(
                      car: car!,
                      showLeadingVs: showLeadingVs,
                      hasTrailingVs: hasTrailingVs,
                    ),
            ),
          ),
        ),
        if (car != null)
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: onRemove,
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: _closeSize,
                height: _closeSize,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: AppColors.primary, width: 1),
                ),
                child: const Icon(Icons.close,
                    size: 13, color: AppColors.primary),
              ),
            ),
          ),
        if (showLeadingVs)
          const Positioned(
            left: -23,
            top: 0,
            bottom: 0,
            width: 40,
            child: Center(
              child: Text(
                'VS',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// ============================================================
// EMPTY STATE
// ============================================================

class _EmptySlot extends StatelessWidget {
  const _EmptySlot();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 35,
            height: 35,
            child: DottedBorderBox(
              radius: 17.5,
              child: Center(child: _ThinPlus()),
            ),
          ),
          SizedBox(height: 6),
          Text('Select Car',
              style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w400)),
        ],
      ),
    );
  }
}

/// Thin 1px "+" like the design (Icons.add is too heavy).
class _ThinPlus extends StatelessWidget {
  const _ThinPlus();

  @override
  Widget build(BuildContext context) =>
      const CustomPaint(size: Size(9, 9), painter: _PlusPainter());
}

class _PlusPainter extends CustomPainter {
  const _PlusPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.butt;
    final c = size.center(Offset.zero);
    canvas.drawLine(Offset(0, c.dy), Offset(size.width, c.dy), p);
    canvas.drawLine(Offset(c.dx, 0), Offset(c.dx, size.height), p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ============================================================
// FILLED STATE
// ============================================================

class _FilledSlot extends StatelessWidget {
  const _FilledSlot({
    required this.car,
    required this.showLeadingVs,
    required this.hasTrailingVs,
  });

  final SelectedCar car;
  final bool showLeadingVs;
  final bool hasTrailingVs;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, outer) {
      final carH = (outer.maxWidth * 0.48).clamp(50.0, 90.0).toDouble();

      final leftPad = showLeadingVs ? 20.0 : 12.0;
      final rightPad = hasTrailingVs ? 20.0 : 12.0;

      return Padding(
        padding: EdgeInsets.fromLTRB(leftPad, 4, rightPad, 8),
        child: LayoutBuilder(builder: (context, inner) {
          return FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: inner.maxWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: CarImage(
                      path: car.image,
                      height: carH,
                      shadowColor: const Color(0xFFD9D9D9),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(car.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 13,
                          height: 1.2,
                          fontWeight: FontWeight.w500,
                          color: AppColors.text)),
                  const SizedBox(height: 3),
                  Text(car.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 11, height: 1.2, color: AppColors.grey2)),
                  const SizedBox(height: 8),
                  PriceRow(
                    price: car.price,
                    fontSize: 11,
                    symbolSize: 14,
                    symbolWeight: FontWeight.w400,
                    gap: 6,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Flexible(
                        child: IconLabel(
                            icon: Icons.local_gas_station_outlined,
                            label: car.variant.fuel,
                            fontSize: 11,
                            iconSize: 14),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: IconLabel(
                            icon: Icons.settings_outlined,
                            label: car.variant.transmission,
                            fontSize: 11,
                            iconSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      );
    });
  }
}