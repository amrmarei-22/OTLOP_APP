// custom_other_register_item.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomOtherRegisterItem extends StatelessWidget {
  const CustomOtherRegisterItem({
    super.key,
    required this.text,
    required this.iconPath,
  });
  final String text;
  final String iconPath;
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        side: BorderSide(color: colorScheme.outline),
        backgroundColor: colorScheme.surfaceContainerHighest,
        foregroundColor: colorScheme.onSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(15),
        ),
      ),
      onPressed: () {},
      icon: SvgPicture.asset(iconPath),
      label: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
      ),
    );
  }
}
