import 'package:flutter/material.dart';

class AppColors {
  static const Color backgroundDeep = Color(0xFF0A0A0F);
  static const Color backgroundSurface = Color(0xFF0D0020);
  static const Color backgroundCard = Color(0xFF100A1E);
  static const Color primaryPurple = Color(0xFF6B21A8);
  static const Color accentPurpleLight = Color(0xFF9A6ABA);
  static const Color accentGreen = Color(0xFF7FFF6A);
  static const Color greenDark = Color(0xFF1A6E3A);
  static const Color textPrimary = Color(0xFFE8D5FF);
  static const Color textSecondary = Color(0xFF9A6ABA);
  static const Color textMuted = Color(0xFF4A2A6A);
  static const Color dangerRed = Color(0xFFFF4444);
  static const Color warningAmber = Color(0xFFFFB800);
  static const Color borderSubtle = Color(0xFF1A0A30);
  static const Color borderAccent = Color(0xFF2A1050);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryPurple, greenDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient get backgroundGradient => const LinearGradient(
    colors: [Color(0xFF1A0040), backgroundDeep],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
