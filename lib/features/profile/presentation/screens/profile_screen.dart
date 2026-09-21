import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otlop_app/core/theme/app_colors.dart';
import 'package:otlop_app/features/auth/data/auth_session.dart';
import 'package:otlop_app/features/auth/presentation/cubits/auth_cubit/auth_cubit.dart';
import 'package:otlop_app/features/auth/presentation/cubits/auth_cubit/auth_states.dart';
import 'package:otlop_app/features/auth/presentation/screens/login_screen.dart';

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
          backgroundColor: const Color(0xFFF8F9FA),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 42, 24, 28),
              children: [
                const Text(
                  'Profile',
                  style: TextStyle(
                    color: Color(0xFF182235),
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
                  iconColor: const Color(0xFF4285F4),
                  iconBackground: const Color(0xFFEFF5FF),
                  title: 'My Orders',
                  subtitle: 'View your order history',
                  onTap: onOrdersTap,
                ),
                _ProfileOption(
                  icon: Icons.location_on,
                  iconColor: const Color(0xFFE94B9A),
                  iconBackground: const Color(0xFFFFF0F8),
                  title: 'My Address',
                  subtitle: 'Manage saved addresses',
                  onTap: () =>
                      _showUnavailableMessage(context, 'Address management'),
                ),
                _ProfileOption(
                  icon: Icons.settings,
                  iconColor: const Color(0xFF9B55EA),
                  iconBackground: const Color(0xFFF7F0FF),
                  title: 'Settings',
                  subtitle: 'App preferences',
                  onTap: () => _showUnavailableMessage(context, 'Settings'),
                ),
                _ProfileOption(
                  icon: Icons.help,
                  iconColor: AppColors.redClr,
                  iconBackground: const Color(0xFFFFF0F0),
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
                      backgroundColor: const Color(0xFFFFF0F0),
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
    return Container(
      height: 102,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.primayClr,
        borderRadius: BorderRadius.circular(23),
        boxShadow: [
          BoxShadow(
            color: AppColors.primayClr.withValues(alpha: 0.22),
            blurRadius: 12,
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
              color: Colors.white.withValues(alpha: 0.28),
              borderRadius: BorderRadius.circular(12),
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
                  style: const TextStyle(color: Colors.white, fontSize: 14),
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
              backgroundColor: Colors.white.withValues(alpha: 0.18),
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

  const _ProfileOption({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
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
                          style: const TextStyle(
                            color: Color(0xFF293346),
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            color: Colors.blueGrey.shade400,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, color: Colors.blueGrey.shade200),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
