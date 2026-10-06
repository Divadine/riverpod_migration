import 'package:flutter/material.dart';
import 'package:riverpod_learning/shared_widgets/auth_change_text.dart';
import 'auth_header.dart'; // kPrimaryRed

class AuthBottomLink extends StatelessWidget {
  final String text;
  final String linkText;
  final VoidCallback onTap;

  const AuthBottomLink({
    super.key,
    required this.text,
    required this.linkText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 50, top: 8),
        child: Center(
          child: AuthChangeText(
            text1: text,
            tappableText: linkText,
            fadeColor: kPrimaryRed,
            onTap: onTap,
          ),
        ),
      ),
    );
  }
}