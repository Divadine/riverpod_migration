// features/.../widget/phone_number_field.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/color.dart';
import '../../../shared_widgets/app_text.dart';
import '../../../shared_widgets/app_text_field.dart';

class PhoneNumberField extends StatelessWidget {
  final TextEditingController controller;
  final String  dialCode;
  final ValueChanged<String> onChanged;

  const PhoneNumberField({
    super.key,
    required this.controller,
    required this.onChanged,
     this.dialCode = '+91',
  });


  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            //height: ,
            width: 64,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.fieldGrey),
            ),
            child: AppText(text: dialCode, fontSize: 14),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: AppTextField(
              textController: controller,
              hintText: 'Phone number',
              textInputType: TextInputType.phone,
              maxLength: 10,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              borderRadius: BorderRadius.circular(12),
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              onChange: onChanged,

              onSubmit: (_) {},
            ),
          ),
        ],
      ),
    );
  }
}