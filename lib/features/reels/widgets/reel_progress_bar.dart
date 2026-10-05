import 'package:flutter/material.dart';

class ReelProgressBar extends StatelessWidget {
  final double progress;
  final ValueChanged<double> onChanged;

  const ReelProgressBar({
    super.key,
    required this.progress,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final safeProgress = progress.clamp(0.0, 1.0);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,

      // -------------------------------------------------------
      // DRAG
      // -------------------------------------------------------

      onHorizontalDragUpdate: (details) {
        final renderBox =
        context.findRenderObject() as RenderBox;

        final localPosition =
        renderBox.globalToLocal(
          details.globalPosition,
        );

        final value =
            localPosition.dx / renderBox.size.width;

        onChanged(
          value.clamp(0.0, 1.0),
        );
      },

      // -------------------------------------------------------
      // TAP
      // -------------------------------------------------------

      onTapDown: (details) {
        final renderBox =
        context.findRenderObject() as RenderBox;

        final localPosition =
        renderBox.globalToLocal(
          details.globalPosition,
        );

        final value =
            localPosition.dx / renderBox.size.width;

        onChanged(
          value.clamp(0.0, 1.0),
        );
      },

      child: SizedBox(
        height: 30,
        child: Center(
          child: Container(
            height: 3,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withValues(
                alpha: 0.35,
              ),
              borderRadius:
              BorderRadius.circular(10),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: safeProgress,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}