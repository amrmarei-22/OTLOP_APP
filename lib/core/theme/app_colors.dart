// app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // --- Brand Colors ---
  static const Color primayClr = Color(0xFFFF5C39); // Vibrant warm coral-orange
  static const Color primaryClr = primayClr;
  static const Color primaryDarkClr = Color(0xFFE04524);
  static const Color primaryLightClr = Color(0xFFFF8A6E);

  // --- Backgrounds & Surfaces (Light) ---
  static const Color scaffoldBackgroundClr = Color(0xFFFAF9F8); // Warm, clean oyster white
  static const Color surfaceClr = Colors.white;
  static const Color containerBgClr = Color(0xFFFFF5F2); // Soft warm peach tint
  static const Color surfaceContainerHighest = Color(0xFFF3F1EE);

  // --- Backgrounds & Surfaces (Dark) ---
  static const Color scaffoldBackgroundDarkClr = Color(0xFF141316);
  static const Color surfaceDarkClr = Color(0xFF1E1D22);
  static const Color containerBgDarkClr = Color(0xFF26232B);
  static const Color surfaceContainerHighestDark = Color(0xFF2A2830);

  // --- Neutrals & Typography ---
  static const Color blackClr = Color(0xFF1A1817);
  static const Color whiteClr = Colors.white;
  static const Color greyClr = Color(0xFF8E8B88); // Warm neutral grey
  static const Color greyLightClr = Color(0xFFE8E5E2);
  static const Color borderClr = Color(0xFFEAE7E4);
  static const Color borderDarkClr = Color(0xFF333038);

  // --- Status & Feedback Colors ---
  static const Color greenClr = Color(0xFF2E9E5B); // Delivered / Success
  static const Color greenLightClr = Color(0xFFEAF7EE);
  static const Color redClr = Color(0xFFE53935); // Cancelled / Error
  static const Color redLightClr = Color(0xFFFEECEB);
  static const Color orangeClr = Color(0xFFF59E0B); // In Progress / Warning
  static const Color orangeLightClr = Color(0xFFFEF6E7);
  static const Color blueClr = Color(0xFF3B82F6); // Info
  static const Color blueLightClr = Color(0xFFEFF5FF);
}

