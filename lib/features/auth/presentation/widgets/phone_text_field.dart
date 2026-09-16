// features/auth/presentation/widgets/phone_text_field.dart
// titled_text_field.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:otlop_app/core/theme/app_colors.dart';
import 'package:otlop_app/core/helper/validators.dart';

class PhoneTextField extends StatelessWidget {
  const PhoneTextField({super.key, required this.controller});
final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Phone Number",
          style: TextStyle(
            color: AppColors.primayClr,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        TextFormField(
          controller:controller ,
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9]"))],
          validator: (phone) {
            return Validator.validatePhoneNumber(phone!);
          },
          maxLength: 11,
          autovalidateMode: AutovalidateMode.onUserInteraction,

          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            hintText: "Enter your phone",
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.red),
            ),
            hintStyle: TextStyle(color: AppColors.greyClr, fontSize: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: AppColors.primayClr, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
