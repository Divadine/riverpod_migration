import 'package:flutter/material.dart';
import 'package:riverpod_learning/core/theme/color.dart';
import 'package:riverpod_learning/shared_widgets/app_dropdown_field.dart';
import 'package:riverpod_learning/shared_widgets/phone_number_field.dart';
import 'package:riverpod_learning/shared_widgets/text_box_normal.dart';

class PhoneSection extends StatelessWidget {
  final TextEditingController controller;
  final String? country;
  final ValueChanged<String?> onCountryChanged;

  const PhoneSection({
    super.key,
    required this.controller,
    required this.country,
    required this.onCountryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return buildTextFieldWithHeading(
      title: 'Enter phone Number',
      fieldWidget: Column(
        children: [
          AppDropdownField<String>(
            borderColor: AppColors.fieldGrey,
            menuHeight: 200,
            value: country,
            items: const ['India', 'USA', 'UK', 'UAE', 'DUBAI', 'TN'],
            onChanged: onCountryChanged,
            hintText: '',
            itemLabel: (c) => c,
          ),
          const SizedBox(height: 8),
          PhoneNumberField(controller: controller, onChanged: (_) {}),
        ],
      ),
    );
  }
}