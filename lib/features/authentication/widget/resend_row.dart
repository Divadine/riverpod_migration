import 'package:flutter/material.dart';
import 'package:riverpod_learning/shared_widgets/auth_change_text.dart';
import 'auth_header.dart'; // kPrimaryRed

class OtpResendRow extends StatelessWidget {
  final bool enabled;
  final VoidCallback onResend;

  const OtpResendRow({
    super.key,
    required this.enabled,
    required this.onResend,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AuthChangeText(
        text1: 'Resent code ?',
        tappableText: 'Resend',
        fadeColor: enabled ? kPrimaryRed : kPrimaryRed.withOpacity(0.5),
        onTap: () {
          if (enabled) onResend();
        },
      ),
    );
  }
}