// auth_divider_row.dart
import 'package:flutter/material.dart';

class AuthDividerRow extends StatelessWidget {
  const AuthDividerRow({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(child: Divider(thickness: 2)),
        Text(
          '   Or With   ',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        Expanded(child: Divider(thickness: 2)),
      ],
    );
  }
}
