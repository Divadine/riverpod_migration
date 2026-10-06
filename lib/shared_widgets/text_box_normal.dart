
import 'package:flutter/cupertino.dart';

import 'app_text.dart';

Widget buildTextFieldWithHeading({
  required String title,
  required Widget fieldWidget,

}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          AppText(text: title, fontSize: 14, fontWeight: FontWeight.w500),
        ],
      ),
      const SizedBox(height: 10),
      fieldWidget,
    ],
  );
}