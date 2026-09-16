// custom_elevated_button.dart
import 'package:flutter/material.dart';
import 'package:otlop_app/core/theme/app_colors.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({super.key, required this.text, this.onPressed});
  final String text;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(15),
        ),
        backgroundColor: AppColors.primayClr,
        minimumSize: Size(double.infinity, 50),
      ),
      onPressed:onPressed ,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: AppColors.whiteClr,
        ),
      ),
    );
  }
}
