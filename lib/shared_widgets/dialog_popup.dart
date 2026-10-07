import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_learning/core/theme/color.dart';
import 'package:riverpod_learning/shared_widgets/submit_button.dart';

class ConfirmPopup extends StatelessWidget {
  final String title;
  final String description;
  final String confirmText;
  final String cancelText;
  final Color confirmColor;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const ConfirmPopup({
    super.key,
    required this.title,
    required this.description,
    this.confirmText = 'Yes',
    this.cancelText = 'Cancel',
    this.confirmColor = AppColors.red,
    this.onConfirm,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 40),
          child: Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          description,
          style: const TextStyle(fontSize: 18, color: Colors.grey),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: AppButton(
                bgColor: confirmColor,
                textColor: Colors.white,
                title: confirmText,
                onTap: () {
                  Navigator.of(context).pop(true); // close the dialog
                  onConfirm?.call();               // then run this screen's action
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppButton(
                bgColor: Colors.transparent,
                textColor: confirmColor,
                border: Border.all(color: confirmColor),
                title: cancelText,
                onTap: () {
                  Navigator.of(context).pop(false);
                  onCancel?.call();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}