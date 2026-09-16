// auth_divider_row.dart
import 'package:flutter/material.dart';
import 'package:otlop_app/core/theme/app_colors.dart';

class AuthDividerRow extends StatelessWidget {
  const AuthDividerRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider()),
        Text(
          '   Or With   ',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.greyClr,
          ),
        ),
        Expanded(child: Divider()),
      ],
    );
  }
}
