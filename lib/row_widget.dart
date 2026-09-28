import 'package:flutter/material.dart';

class RowWidget extends StatelessWidget {
  final String title;
  final String price;

  const RowWidget({super.key, required this.title, required this.price});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            color: colorScheme.onSurfaceVariant,
            height: 1.5,
          ),
        ),
        const Spacer(),
        Text(
          price,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }
}
