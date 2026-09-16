// features/auth/presentation/widgets/forget_pass_section.dart
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:otlop_app/core/theme/app_colors.dart';
import 'package:otlop_app/core/common_widgets/custom_text_button.dart';

class ForgetPassSection extends StatefulWidget {
  const ForgetPassSection({super.key});

  @override
  State<ForgetPassSection> createState() => _ForgetPassSectionState();
}

class _ForgetPassSectionState extends State<ForgetPassSection> {
  bool isActive = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          visualDensity: VisualDensity(horizontal: -4, vertical: -2),
          value: isActive,
          onChanged: (newVal) {
            log(newVal.toString());
            isActive = newVal!;
            setState(() {});
          },
        ),

        CustomTextButton(
          text: 'Remember Me',
          onPressed: () {
            log("Remember me pressed");
            isActive = !isActive;
            setState(() {});

          },
        ),
        Spacer(),
        CustomTextButton(
          text: 'Forgot Password',
          textClr: AppColors.primayClr,
          onPressed: () {
            log("Forget pass pressed");
          },
        ),
      ],
    );
  }
}
