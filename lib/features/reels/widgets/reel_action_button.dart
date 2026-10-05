import 'package:flutter/material.dart';

class ReelActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  const ReelActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.black.withValues(
                alpha: 0.25,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 27,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}