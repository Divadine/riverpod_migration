import 'package:flutter/material.dart';
import 'package:riverpod_learning/shared_widgets/app_dropdown_field.dart';
import 'package:riverpod_learning/shared_widgets/app_text_field.dart';
import 'package:riverpod_learning/shared_widgets/phone_number_field.dart';
import 'package:riverpod_learning/shared_widgets/submit_button.dart';
import 'package:riverpod_learning/shared_widgets/text_box_normal.dart';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  String? country = 'India';

  @override
  void dispose() {
    nameCtrl.dispose();
    phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildTextFieldWithHeading(
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
                    const SizedBox(height: 20),
                    buildTextFieldWithHeading(
                      title: 'Enter phone Number',
                      fieldWidget: Column(
                        children: [
                          AppDropdownField<String>(
                            menuHeight: 200,
                            value: country,
                            items: const ['India', 'USA', 'UK','UAE','DUBAI','TN'],

                            onChanged: (v) => setState(() => country = v),
                            hintText: '',
                            itemLabel: (c) => c,


                          ),
                          const SizedBox(height: 8),
                          PhoneNumberField(
                              controller: phoneCtrl,
                              onChanged: (_) {}
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              AppButton(title: 'Signup',  isLoading: false, onTap: () {  },),
            ],
          ),
        ),
      ),
    );
  }
}