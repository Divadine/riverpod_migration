import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_learning/features/authentication/screen/verfication_screen.dart';
import 'package:riverpod_learning/shared_widgets/submit_button.dart';
import '../models/auth_mode.dart';
import '../provider/auth_provider.dart';
import '../widget/auth_bottom_link.dart';
import '../widget/auth_header.dart';
import '../widget/auth_toast.dart';
import '../widget/phone_section.dart';
import 'signup_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final phoneCtrl = TextEditingController();
  String? country = 'India';
  static const AuthMode mode = AuthMode.login;

  @override
  void dispose() {
    phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    FocusScope.of(context).unfocus();
    final phone = phoneCtrl.text.trim();
    final ok = await ref
        .read(authProvider.notifier)
        .sendOtp(mode: mode, phone: phone);
    if (!ok || !mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VerificationScreen(phone: '+91 $phone', mode: mode),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authProvider);

    ref.listen(authProvider.select((s) => s.error), (_, err) {
      if (err != null) {
        showAuthToast(context, err);
        ref.read(authProvider.notifier).clearError();
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          AuthHeader(title: mode.title, subtitle: mode.subtitle),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 24, 18, 20),
              child: Column(
                children: [
                  PhoneSection(
                    controller: phoneCtrl,
                    country: country,
                    onCountryChanged: (v) => setState(() => country = v),
                  ),
                  const SizedBox(height: 28),
                  SubmitButton(
                    title: mode.buttonText,
                    isLoading: state.isLoading,
                    onPressed: _onLogin,
                  ),

                  SizedBox(height: 200,),
                  AuthBottomLink(
                    text: "You don't have an account ?",
                    linkText: 'Sign up',
                    onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const SignupScreen()),
                    ),
                  ),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}