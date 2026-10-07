import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_learning/core/theme/color.dart';
import 'package:riverpod_learning/features/authentication/screen/verfication_screen.dart';
import 'package:riverpod_learning/features/car_filter_search/widget/filter_sheet.dart';
import 'package:riverpod_learning/shared_widgets/app_text.dart';
import 'package:riverpod_learning/shared_widgets/appdialog.dart';
import 'package:riverpod_learning/shared_widgets/bottomsheets.dart';
import 'package:riverpod_learning/shared_widgets/dialog_popup.dart';
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
    AppDialogue.showPopup(
       showCloseIcon: true,
       context: context,
       content: ConfirmPopup(
           title: 'Exit ?',
           description: 'Are you sure you want to exit from the Agri machinery app?',
         cancelText: 'dont',
         confirmText: 'apply',
         onConfirm: (){
           Navigator.push(context,MaterialPageRoute(builder: (_) => const SignupScreen()));
         },
       )

   );


   // AppUiHelper.showBottomSheet(
   //   showHandle: true,
   //   title: 'Report',
   //   showButton: true,
   //   showCloseIcon: true,
   //     buttonBgColor: AppColors.red,
   //     buttonTextColor: Colors.white,
   //     contentBgColor: Colors.transparent,
   //     context: context,
   //     child: Column(
   //   children: [
   //     AppText(text: 'hey'),
   //     AppText(text: 'hey'),
   //     AppText(text: 'hey'),
   //     AppText(text: 'hey'),
   //   ],
   // ));
    return;
    // FocusScope.of(context).unfocus();
    // final phone = phoneCtrl.text.trim();
    // final ok = await ref
    //     .read(authProvider.notifier)
    //     .sendOtp(mode: mode, phone: phone);
    // if (!ok || !mounted) return;
    //
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (_) => VerificationScreen(phone: '+91 $phone', mode: mode),
    //   ),
    // );
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
          AuthHeader(title: mode.title(), subtitle: mode.subtitle()),
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
                  AppButton(
                    bgColor: Colors.transparent,
                    textColor: Colors.red,
                    border: Border.all(color: Colors.red),
                    title: mode.buttonText(),
                    onTap: _onLogin,
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