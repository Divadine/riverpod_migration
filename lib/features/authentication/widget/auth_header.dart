import 'package:flutter/material.dart';
import 'package:riverpod_learning/shared_widgets/asset_images.dart';

const Color kPrimaryRed = Color(0xFFE63946);

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onBack;
  final String? timerText;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.onBack,
    this.timerText,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          color: kPrimaryRed,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 30),
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                SizedBox(
                  height: 24,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: onBack == null
                        ? null
                        : GestureDetector(
                      onTap: onBack,
                      child: const Icon(Icons.arrow_back,
                          color: Colors.white),
                    ),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    AssetImages.loginImage,
                    height: 72,
                    width: 72,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 72,
                      width: 72,
                      color: Colors.white,
                      child: const Icon(Icons.image_not_supported),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
              ],
            ),
          ),
        ),
        if (timerText != null)
          Positioned(
            bottom: -16,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  timerText!,
                  style: const TextStyle(
                    color: kPrimaryRed,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}