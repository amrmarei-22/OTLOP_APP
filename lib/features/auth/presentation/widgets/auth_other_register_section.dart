// features/auth/presentation/widgets/auth_other_register_section.dart
import 'package:flutter/material.dart';
import 'package:otlop_app/features/auth/presentation/widgets/custom_other_register_item.dart';

class AuthOtherRegisterSection extends StatelessWidget {
  const AuthOtherRegisterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 20,
      children: [
        Expanded(
          child: CustomOtherRegisterItem(
            text: 'Github',

            iconPath: 'assets/icons/github_iconsvg.svg',
          ),
        ),
        Expanded(
          child: CustomOtherRegisterItem(
            text: 'GitLab',

            iconPath: 'assets/icons/gitlab_icon.svg',
          ),
        ),
      ],
    );
  }
}
