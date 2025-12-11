import 'package:flutter/material.dart';

class AppColors {
  // Primary gradient colors - Deep Blue
  static const Color primaryDark = Color(0xFF0066CC);
  static const Color primaryPurple = Color(0xFF0080FF);
  static const Color primaryBlue = Color(0xFF1E90FF);
  static const Color primaryCyan = Color(0xFF00BFFF);

  // Accent colors
  static const Color accentPink = Color(0xFF0080FF);
  static const Color accentOrange = Color(0xFF1E90FF);
  static const Color accentGreen = Color(0xFF00BFFF);

  // Semantic colors with vibrant tones
  static const Color success = Color(0xFF0080FF);
  static const Color successLight = Color(0xFF1E90FF);
  static const Color error = Color(0xFF00BFFF);
  static const Color errorLight = Color(0xFF1E90FF);
  static const Color warning = Color(0xFF0066CC);
  static const Color warningLight = Color(0xFF0080FF);
  static const Color info = Color(0xFF1E90FF);
  static const Color infoLight = Color(0xFF00BFFF);

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
    colors: [Color(0xFF0066CC), Color(0xFF0080FF), Color(0xFF1E90FF)],
  );

  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0066CC), Color(0xFF0080FF), Color(0xFF1E90FF)],
  );

  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0080FF), Color(0xFF1E90FF), Color(0xFF00BFFF)],
  );

  static const LinearGradient errorGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF00BFFF), Color(0xFF1E90FF), Color(0xFF0066CC)],
  );

  static const LinearGradient warningGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0066CC), Color(0xFF0080FF), Color(0xFF1E90FF)],
  );

  static const LinearGradient purpleGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0066CC), Color(0xFF0080FF), Color(0xFF1E90FF)],
  );

  static const LinearGradient pinkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0080FF), Color(0xFF1E90FF), Color(0xFF00BFFF)],
  );

  // Glassmorphism overlay
  static Color glassOverlay = Colors.white.withOpacity(0.1);
  static Color glassBorder = Colors.white.withOpacity(0.2);
}
