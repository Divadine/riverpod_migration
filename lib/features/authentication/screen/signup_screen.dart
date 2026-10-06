import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_learning/features/authentication/screen/verfication_screen.dart';
import 'package:riverpod_learning/shared_widgets/app_text_field.dart';
import 'package:riverpod_learning/shared_widgets/submit_button.dart';
import 'package:riverpod_learning/shared_widgets/text_box_normal.dart';
import '../models/auth_mode.dart';
import '../provider/auth_provider.dart';
import '../widget/auth_bottom_link.dart';
import '../widget/auth_header.dart';
import '../widget/auth_toast.dart';
import '../widget/phone_section.dart';
import 'login_screen.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  String? country = 'India';
  static const AuthMode mode = AuthMode.signup;

  @override
  void dispose() {
    nameCtrl.dispose();
    phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSignup() async {
    FocusScope.of(context).unfocus();
    final phone = phoneCtrl.text.trim();
    final ok = await ref.read(authProvider.notifier).sendOtp(
      mode: mode,
      phone: phone,
      name: nameCtrl.text,
    );
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
                  Align(
                    alignment: Alignment.centerLeft,
                    child: buildTextFieldWithHeading(
                      title: 'Name',
                      fieldWidget: AppTextField(
                        textController: nameCtrl,
                        hintText: 'Enter Full name',
                        borderRadius: BorderRadius.circular(12),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        onChange: (_) {},
                        onSubmit: (_) {},
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  PhoneSection(
                    controller: phoneCtrl,
                    country: country,
                    onCountryChanged: (v) => setState(() => country = v),
                  ),
                  const SizedBox(height: 28),
                  SubmitButton(
                    title: mode.buttonText,
                    isLoading: state.isLoading,
                    onPressed: _onSignup,
                  ),
                  SizedBox(height: 100,),

                  AuthBottomLink(
                    text: 'You already have a account ?',
                    linkText: 'Login',
                    onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // AuthBottomLink(
          //   text: 'You already have a account ?',
          //   linkText: 'Login',
          //   onTap: () => Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(builder: (_) => const LoginScreen()),
          //   ),
          // ),
        ],
      ),
    );
  }
}