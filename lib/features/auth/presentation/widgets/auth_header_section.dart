// auth_header_section.dart
import 'package:flutter/material.dart';
import 'package:otlop_app/core/theme/app_colors.dart';

class AuthHeaderSection extends StatelessWidget {
  const AuthHeaderSection({
    super.key,
    required this.title,
    required this.subTitle,
  });
  final String title, subTitle;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
        ),
        Text(
          subTitle,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.greyClr,
          ),
        ),
      ],
    );
  }
}
