import 'package:flutter/material.dart';
import 'package:riverpod_learning/core/theme/color.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    this.greeting = 'Good morning',
    this.name = 'Skyraan Technologies',
    this.avatarUrl,
    this.onSearch,
    this.onNotification,
  });

  final String greeting;
  final String name;
  final String? avatarUrl;
  final VoidCallback? onSearch;
  final VoidCallback? onNotification;

  static const Color _greetingColor = Color(0xFF555555);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.border,
            backgroundImage:
            avatarUrl != null ? NetworkImage(avatarUrl!) : null,
            child: avatarUrl == null
                ? const Icon(Icons.person, color: AppColors.grey2)
                : null,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(greeting,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 13, color: _greetingColor, height: 1.25)),
                Text(name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        height: 1.25)),
              ],
            ),
          ),
          _IconBox(icon: Icons.search, onTap: onSearch),
          const SizedBox(width: 8),
          _IconBox(icon: Icons.notifications_none, onTap: onNotification),
        ],
      ),
    );
  }
}

class _IconBox extends StatelessWidget {
  const _IconBox({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.border2),
        ),
        child: Icon(icon, size: 18, color: AppColors.text),
      ),
    );
  }
}