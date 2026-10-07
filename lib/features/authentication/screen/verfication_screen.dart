import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_learning/features/auth/screens/auth_gate.dart';
import 'package:riverpod_learning/features/authentication/screen/login_screen.dart';
import 'package:riverpod_learning/features/authentication/widget/resend_row.dart';
import 'package:riverpod_learning/shared_widgets/submit_button.dart';
import '../models/auth_mode.dart';
import '../provider/otp_provider.dart';
import '../widget/auth_bottom_link.dart';
import '../widget/auth_header.dart';
import '../widget/auth_toast.dart';
import '../widget/otp_input_field.dart';

import 'signup_screen.dart';

class VerificationScreen extends ConsumerStatefulWidget {
  final String phone; // e.g. "+91 9853478650"
  final AuthMode mode; // login or signup

  const VerificationScreen({
    super.key,
    required this.phone,
    required this.mode,
  });

  @override
  ConsumerState<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends ConsumerState<VerificationScreen> {
  int _resetToken = 0;
  late final _provider =
  otpProvider(OtpArgs(phone: widget.phone, mode: widget.mode));

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(_provider);
    final notifier = ref.read(_provider.notifier);

    ref.listen(_provider.select((s) => s.error), (_, err) {
      if (err != null) {
        showAuthToast(context, err);
        notifier.clearError();
      }
    });

    ref.listen(_provider.select((s) => s.isVerified), (_, ok) {
      if (ok) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
              (route) => false,
        );
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          AuthHeader(
            title: AuthTexts.verificationTitle,
            subtitle: AuthTexts.verificationSubtitle,
            timerText: state.timerText,
            onBack: () => Navigator.pop(context),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 48, 18, 20),
              child: Column(
                children: [
                  OtpInputField(
                    length: kOtpLength,
                    resetToken: _resetToken,
                    onChanged: notifier.onOtpChanged,
                  ),
                  const SizedBox(height: 18),
                  OtpResendRow(
                    enabled: state.canResend,
                    onResend: () {
                      setState(() => _resetToken++);
                      notifier.resend();
                    },
                  ),
                  const SizedBox(height: 28),
                  AppButton(

                    title: 'Verify',
                    isLoading: state.isLoading,
                    onTap: notifier.verify,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(widget.phone,
                          style: const TextStyle(color: Colors.grey)),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => Navigator.pop(context), // edit number
                        child: const Icon(Icons.edit,
                            size: 16, color: kPrimaryRed),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          AuthBottomLink(
            text: "You don't have an account ?",
            linkText: 'Sign up',
            onTap: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const SignupScreen()),
                  (route) => false,
            ),
          ),
        ],
      ),
    );
  }
}