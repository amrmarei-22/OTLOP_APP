// custom_text_button.dart
import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    super.key,
    required this.text,
    this.textClr,
    required this.onPressed,
  });
  final String text;
  final Color? textClr;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return TextButton(
      style: TextButton.styleFrom(padding: EdgeInsets.zero),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textClr ?? colorScheme.onSurface,
        ),
      ),
    );
  }
}
