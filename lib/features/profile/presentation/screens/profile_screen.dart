import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otlop_app/core/theme/app_colors.dart';
import 'package:otlop_app/core/theme/theme_cubit.dart';
import 'package:otlop_app/features/auth/data/auth_session.dart';
import 'package:otlop_app/features/auth/presentation/cubits/auth_cubit/auth_cubit.dart';
import 'package:otlop_app/features/auth/presentation/cubits/auth_cubit/auth_states.dart';
import 'package:otlop_app/features/auth/presentation/screens/login_screen.dart';
import 'package:otlop_app/features/profile/presentation/screens/address_map_screen.dart';

class ProfileScreen extends StatelessWidget {
  final VoidCallback onOrdersTap;

  const ProfileScreen({super.key, required this.onOrdersTap});

  Future<void> _confirmLogout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text(
          'Are you sure you want to log out of your account?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.redClr,
              foregroundColor: Colors.white,
            ),
            child: const Text('Log out'),
          ),
        ],
      ),
    );

    if (shouldLogout == true && context.mounted) {
      context.read<AuthCubit>().logout();
    }
  }

  void _showUnavailableMessage(BuildContext context, String title) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$title is coming soon.')));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final name = AuthSession.displayName?.trim().isNotEmpty == true
        ? AuthSession.displayName!.trim()
        : 'User';
    final email = AuthSession.email?.trim().isNotEmpty == true
        ? AuthSession.email!.trim()
        : 'No email added';
    final initial = name.substring(0, 1).toUpperCase();

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LogoutSuccessState) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
            (_) => false,
          );
        } else if (state is LogoutFailureState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Unable to log out: ${state.error}')),
          );
        }
      },
      builder: (context, state) {
        final isLoggingOut = state is LogoutLoadingState;

        return Scaffold(
          backgroundColor: colorScheme.surface,
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 42, 24, 28),
              children: [
                Text(
                  'Profile',
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 20),
                _ProfileHeader(
                  name: name,
                  email: email,
                  initial: initial,
                  onEdit: () =>
                      _showUnavailableMessage(context, 'Profile editing'),
                ),
                const SizedBox(height: 24),
                _ProfileOption(
                  icon: Icons.assignment_outlined,
                  iconColor: AppColors.blueClr,
                  iconBackground: AppColors.blueClr.withValues(alpha: 0.12),
                  title: 'My Orders',
                  subtitle: 'View your order history',
                  onTap: onOrdersTap,
                ),
                _ProfileOption(
                  icon: Icons.location_on,
                  iconColor: colorScheme.primary,
                  iconBackground: colorScheme.primary.withValues(alpha: 0.12),
                  title: 'My Address',
                  subtitle: 'Manage saved addresses',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AddressMapScreen()),
                  ),
                ),
                _ProfileOption(
                  icon: Icons.settings,
                  iconColor: AppColors.orangeClr,
                  iconBackground: AppColors.orangeClr.withValues(alpha: 0.12),
                  title: 'Settings',
                  subtitle: 'App preferences',
                  onTap: () => context.read<ThemeCubit>().toggleTheme(),
                  trailing: BlocBuilder<ThemeCubit, ThemeMode>(
                    builder: (context, themeMode) => Switch(
                      activeThumbColor: AppColors.primayClr,
                      activeTrackColor: AppColors.primayClr.withValues(
                        alpha: 0.12,
                      ),
                      inactiveThumbColor: AppColors.greyClr,
                      inactiveTrackColor: AppColors.greyClr.withValues(
                        alpha: 0.12,
                      ),
                      value: themeMode == ThemeMode.dark,
                      onChanged: (_) =>
                          context.read<ThemeCubit>().toggleTheme(),
                    ),
                  ),
                ),
                _ProfileOption(
                  icon: Icons.help_outline,
                  iconColor: AppColors.greenClr,
                  iconBackground: AppColors.greenClr.withValues(alpha: 0.12),
                  title: 'Help & Support',
                  subtitle: 'Get help or contact us',
                  onTap: () =>
                      _showUnavailableMessage(context, 'Help & Support'),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 56,
                  child: TextButton.icon(
                    onPressed: isLoggingOut
                        ? null
                        : () => _confirmLogout(context),
                    icon: const Icon(Icons.logout, size: 19),
                    label: Text(isLoggingOut ? 'Logging out...' : 'Log out'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.redClr,
                      backgroundColor: AppColors.redClr.withValues(alpha: 0.12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final String name;
  final String email;
  final String initial;
  final VoidCallback onEdit;

  const _ProfileHeader({
    required this.name,
    required this.email,
    required this.initial,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      height: 102,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colorScheme.primary, AppColors.primaryLightClr],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(23),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.28),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.22),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              initial,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  email,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onEdit,
            icon: const Icon(
              Icons.edit_outlined,
              color: Colors.white,
              size: 19,
            ),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              minimumSize: const Size(40, 40),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileOption extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Widget? trailing;

  const _ProfileOption({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(17),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(17),
          child: SizedBox(
            height: 72,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: iconBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: iconColor, size: 21),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: colorScheme.onSurface,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  trailing ??
                      Icon(
                        Icons.chevron_right,
                        color: colorScheme.onSurfaceVariant,
                      ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
