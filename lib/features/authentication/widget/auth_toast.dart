import 'package:flutter/material.dart';
import 'package:riverpod_learning/shared_widgets/asset_images.dart';

void showAuthToast(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.only(bottom: 70),
        padding: EdgeInsets.zero,
        content: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipOval(
                  child: Image.asset(
                    AssetImages.loginImage,
                    height: 20,
                    width: 20,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.error_outline,
                      size: 20,
                      color: Colors.red,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    message,
                    style: const TextStyle(color: Colors.black, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
}