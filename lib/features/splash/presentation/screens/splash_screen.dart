import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:otlop_app/core/theme/app_colors.dart';
import 'package:otlop_app/features/auth/data/auth_session.dart';
import 'package:otlop_app/features/auth/presentation/screens/login_screen.dart';
import 'package:otlop_app/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final PageController _pageController;
  late final AnimationController _animController;
  late final Animation<double> _pulseAnimation;
  late final Animation<double> _floatAnimation;

  int _currentPage = 0;
  Timer? _autoAdvanceTimer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.96, end: 1.04).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );

    _floatAnimation = Tween<double>(begin: -6.0, end: 6.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );

    // Auto-advance from Screen 1 to Screen 2 after 4 seconds
    _autoAdvanceTimer = Timer(const Duration(milliseconds: 4200), () {
      if (mounted && _currentPage == 0) {
        _pageController.animateToPage(
          1,
          duration: const Duration(milliseconds: 650),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoAdvanceTimer?.cancel();
    _pageController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _navigateToNext() {
    _autoAdvanceTimer?.cancel();
    final bool isAuthenticated =
        AuthSession.accessToken != null &&
        AuthSession.accessToken!.trim().isNotEmpty;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            isAuthenticated ? const MainScreen() : const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (page) {
          setState(() {
            _currentPage = page;
          });
          if (page == 1) {
            _autoAdvanceTimer?.cancel();
          }
        },
        children: [
          _buildFirstSplashScreen(context),
          _buildSecondSplashScreen(context),
        ],
      ),
    );
  }

  // ===========================================================================
  // SCREEN 1: Brand Essence & Radiant Aura (Visual Identity)
  // ===========================================================================
  Widget _buildFirstSplashScreen(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFE23D1B), Color(0xFFFF5C39), Color(0xFFFF7E55)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            // Ambient glowing background circles
            Positioned(
              top: -60,
              right: -60,
              child: Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            ),
            Positioned(
              bottom: 120,
              left: -70,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.18),
                ),
              ),
            ),

            // Top Bar: Brand Pill & Skip
            Positioned(
              top: 16,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.bolt, color: Color(0xFFFFE082), size: 16),
                        SizedBox(width: 4),
                        Text(
                          'FAST & FRESH',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: _navigateToNext,
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white.withValues(alpha: 0.9),
                      backgroundColor: Colors.white.withValues(alpha: 0.14),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Central Branding Showcase (Not a plain static logo)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        // Pulsing outer glow ring
                        ScaleTransition(
                          scale: _pulseAnimation,
                          child: Container(
                            width: 220,
                            height: 220,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  Colors.white.withValues(alpha: 0.28),
                                  Colors.white.withValues(alpha: 0.0),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Layered Glassmorphic Brand Emblem
                        Container(
                          width: 170,
                          height: 170,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withValues(alpha: 0.30),
                                Colors.white.withValues(alpha: 0.12),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(42),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.45),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.18),
                                blurRadius: 28,
                                offset: const Offset(0, 14),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Stylized fork & cup badge
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.12,
                                      ),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.restaurant_rounded,
                                  color: Color(0xFFFF5C39),
                                  size: 28,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'OTLOP',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 4.5,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'اطلب',
                                style: TextStyle(
                                  color: const Color(0xFFFFE082),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.5,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.25,
                                      ),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Floating Badge 1 (Top-Right): Rating
                        Positioned(
                          top: -12,
                          right: -22,
                          child: AnimatedBuilder(
                            animation: _floatAnimation,
                            builder: (context, child) => Transform.translate(
                              offset: Offset(0, _floatAnimation.value),
                              child: child,
                            ),
                            child: _buildFloatingGlassBadge(
                              icon: Icons.star_rounded,
                              iconColor: const Color(0xFFFFD166),
                              text: '4.9 Rated',
                            ),
                          ),
                        ),

                        // Floating Badge 2 (Bottom-Left): Delivery Speed
                        Positioned(
                          bottom: -14,
                          left: -24,
                          child: AnimatedBuilder(
                            animation: _floatAnimation,
                            builder: (context, child) => Transform.translate(
                              offset: Offset(0, -_floatAnimation.value),
                              child: child,
                            ),
                            child: _buildFloatingGlassBadge(
                              icon: Icons.delivery_dining_rounded,
                              iconColor: Colors.white,
                              text: '20 Min Express',
                            ),
                          ),
                        ),

                        // Floating Badge 3 (Top-Left): Freshness
                        Positioned(
                          top: 40,
                          left: -32,
                          child: AnimatedBuilder(
                            animation: _floatAnimation,
                            builder: (context, child) => Transform.translate(
                              offset: Offset(_floatAnimation.value * 0.5, 0),
                              child: child,
                            ),
                            child: _buildFloatingGlassBadge(
                              icon: Icons.local_fire_department_rounded,
                              iconColor: const Color(0xFFFFD166),
                              text: 'Fresh Daily',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 52),

                    // Title & Tagline
                    const Text(
                      'Your Taste, Delivered.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 27,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'All your favorite drinks, desserts & meals\nin one seamless experience.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Navigation Controls
            Positioned(
              bottom: 24,
              left: 24,
              right: 24,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Page Indicators
                  _buildPageDots(0, activeColor: Colors.white),

                  // Next Button
                  ElevatedButton(
                    onPressed: () {
                      _pageController.animateToPage(
                        1,
                        duration: const Duration(milliseconds: 550),
                        curve: Curves.easeInOutCubic,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primaryClr,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 14,
                      ),
                      elevation: 4,
                      shadowColor: Colors.black.withValues(alpha: 0.25),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Explore',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward_rounded, size: 18),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // SCREEN 2: Cravings & Sensory Experience (Appetite & Action)
  // ===========================================================================
  Widget _buildSecondSplashScreen(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: isDark
          ? AppColors.scaffoldBackgroundDarkClr
          : AppColors.scaffoldBackgroundClr,
      child: SafeArea(
        child: Column(
          children: [
            // Top Navigation Bar
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 12.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.restaurant_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'OTLOP',
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: _navigateToNext,
                    style: TextButton.styleFrom(
                      foregroundColor: colorScheme.onSurfaceVariant,
                      backgroundColor: colorScheme.surfaceContainerHighest,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Visual Food & Beverage Composition
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  // Ambient warm halo backdrop
                  Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          colorScheme.primary.withValues(alpha: 0.22),
                          colorScheme.primary.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),

                  // Center Hero Image (Frappuccino with shadow)
                  AnimatedBuilder(
                    animation: _floatAnimation,
                    builder: (context, child) => Transform.translate(
                      offset: Offset(0, _floatAnimation.value * 0.7),
                      child: child,
                    ),
                    child: Container(
                      width: 210,
                      height: 210,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colorScheme.primary.withValues(alpha: 0.08),
                        border: Border.all(
                          color: colorScheme.primary.withValues(alpha: 0.2),
                          width: 2,
                        ),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/frappuccino.png',
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => Icon(
                            Icons.local_cafe_rounded,
                            size: 80,
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Floating Category Pill 1: Donuts
                  Positioned(
                    top: 10,
                    left: 6,
                    child: _buildCategoryPill(
                      context: context,
                      svgAsset:
                          'assets/icons/donut-doughnut-sweet-dessert-food-fastfood-svgrepo-com.svg',
                      title: 'Donuts',
                      badge: 'Sweet',
                    ),
                  ),

                  // Floating Category Pill 2: Coffee & Latte
                  Positioned(
                    top: 24,
                    right: 6,
                    child: _buildCategoryPill(
                      context: context,
                      svgAsset: 'assets/icons/latte.svg',
                      title: 'Coffee',
                      badge: 'Artisan',
                    ),
                  ),

                  // Floating Category Pill 3: Cakes & Desserts
                  Positioned(
                    bottom: 6,
                    left: 10,
                    child: _buildCategoryPill(
                      context: context,
                      svgAsset: 'assets/icons/cake-svgrepo-com.svg',
                      title: 'Desserts',
                      badge: 'Fresh',
                    ),
                  ),

                  // Floating Promo Pill (Bottom-Right)
                  Positioned(
                    bottom: 12,
                    right: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: colorScheme.outline,
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.local_offer_rounded,
                            color: colorScheme.primary,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Code BITE10',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Value Proposition Headlines
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: Column(
                children: [
                  Text(
                    'Cravings Delivered\nRight to Your Door',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 27,
                      fontWeight: FontWeight.w800,
                      height: 1.22,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Order specialty coffee, bakery treats & favorite meals with instant real-time tracking.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Bottom Navigation & Get Started Action
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
              child: Column(
                children: [
                  // Page Indicators
                  _buildPageDots(1, activeColor: colorScheme.primary),
                  const SizedBox(height: 24),

                  // Main CTA: Get Started
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _navigateToNext,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Get Started • ابدأ الآن',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.4,
                            ),
                          ),
                          SizedBox(width: 10),
                          Icon(Icons.arrow_forward_rounded, size: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Helper: Floating Glass Badge for Screen 1 ---
  Widget _buildFloatingGlassBadge({
    required IconData icon,
    required Color iconColor,
    required String text,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.4),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.14),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: 16),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // --- Helper: Floating Category Pill for Screen 2 ---
  Widget _buildCategoryPill({
    required BuildContext context,
    required String svgAsset,
    required String title,
    required String badge,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            svgAsset,
            width: 24,
            height: 24,
            errorBuilder: (_, __, ___) => Icon(
              Icons.fastfood_rounded,
              size: 20,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
              Text(
                badge,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- Helper: Smooth Page Dots Indicator ---
  Widget _buildPageDots(int activeIndex, {required Color activeColor}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(2, (index) {
        final bool isActive = index == activeIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 26 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? activeColor : activeColor.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(8),
          ),
        );
      }),
    );
  }
}
