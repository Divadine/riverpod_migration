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

  // VS cut: badge radius (19) + 3px clear space
  static const double _vsCutRadius = VsBadge.size / 2 + 1;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // white body + very soft shadow (kept low so it never tints the
        // neighbouring card's border)
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(_radius),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 14,
                  spreadRadius: -2,
                  offset: Offset(0, 3),
                ),
              ],
            ),
          ),
        ),
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTap,
            child: DottedBorderBox(
              radius: _radius,
              cornerNotch: car != null ? _notch : null,
              cutouts: [
                if (hasTrailingVs)
                  const NotchCut(
                      alignment: Alignment.centerRight,
                      offset: Offset(3, 0),
                      radius: _vsCutRadius),
                if (showLeadingVs)
                  const NotchCut(
                      alignment: Alignment.centerLeft,
                      offset: Offset(-3, 0),
                      radius: _vsCutRadius),
              ],
              child: car == null ? const _EmptySlot() : _FilledSlot(car: car!),
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
            left: -22,
            top: 0,
            bottom: 0,
            width: 38,
            child: Center(child: VsBadge()),
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
  const _FilledSlot({required this.car});

  final SelectedCar car;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, outer) {
      // car image scales with the card (shadow ~75% of card width)
      final carH = (outer.maxWidth * 0.5).clamp(60.0, 100.0).toDouble();

      return Padding(
        padding: const EdgeInsets.fromLTRB(14, 2, 14, 10),
        child: LayoutBuilder(builder: (context, inner) {
          // FittedBox(scaleDown) = never overflows, even with big text scale
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
                  const SizedBox(height: 12),
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
                  const SizedBox(height: 10),
                  PriceRow(
                    price: car.price,
                    fontSize: 12,
                    symbolSize: 15,
                    symbolWeight: FontWeight.w400,
                    gap: 8,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Flexible(
                        child: IconLabel(
                            icon: Icons.local_gas_station_outlined,
                            label: car.variant.fuel,
                            fontSize: 12,
                            iconSize: 16),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: IconLabel(
                            icon: Icons.settings_outlined,
                            label: car.variant.transmission,
                            fontSize: 12,
                            iconSize: 16),
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