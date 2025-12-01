import 'package:flutter/material.dart';

class AppColors {
  // Primary gradient colors - Deep purple to vibrant blue
  static const Color primaryDark = Color(0xFF1a1a2e);
  static const Color primaryPurple = Color(0xFF6366f1);
  static const Color primaryBlue = Color(0xFF3b82f6);
  static const Color primaryCyan = Color(0xFF06b6d4);

  // Accent colors
  static const Color accentPink = Color(0xFFec4899);
  static const Color accentOrange = Color(0xFFf97316);
  static const Color accentGreen = Color(0xFF10b981);

  // Semantic colors with vibrant tones
  static const Color success = Color(0xFF10b981);
  static const Color successLight = Color(0xFF34d399);
  static const Color error = Color(0xFFef4444);
  static const Color errorLight = Color(0xFFf87171);
  static const Color warning = Color(0xFFf59e0b);
  static const Color warningLight = Color(0xFFfbbf24);
  static const Color info = Color(0xFF3b82f6);
  static const Color infoLight = Color(0xFF60a5fa);

  // Neutral colors
  static const Color white = Color(0xFFffffff);
  static const Color offWhite = Color(0xFFf8fafc);
  static const Color lightGray = Color(0xFFe2e8f0);
  static const Color mediumGray = Color(0xFF94a3b8);
  static const Color darkGray = Color(0xFF475569);
  static const Color almostBlack = Color(0xFF0f172a);

  // Gradient definitions
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryPurple, primaryBlue, primaryCyan],
  );

  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryDark, Color(0xFF16213e), Color(0xFF0f3460)],
  );

  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [success, successLight, Color(0xFF6ee7b7)],
  );

  static const LinearGradient errorGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [error, errorLight, accentOrange],
  );

  static const LinearGradient warningGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [warning, warningLight, accentOrange],
  );

  static const LinearGradient purpleGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF8b5cf6), Color(0xFFa78bfa), accentPink],
  );

  static const LinearGradient pinkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentPink, Color(0xFFf472b6), Color(0xFFfbbf24)],
  );

  // Glassmorphism overlay
  static Color glassOverlay = Colors.white.withOpacity(0.1);
  static Color glassBorder = Colors.white.withOpacity(0.2);
}
