import 'package:flutter/material.dart';

/// Premium theme system with role-based styling using harmonious green tones
class PremiumTheme {
  // Writer Theme (Darker Greens - Professional)
  static const Color writerPrimary = Color(0xFF059669);      // Emerald 600
  static const Color writerSecondary = Color(0xFF047857);    // Emerald 700
  static const Color writerAccent = Color(0xFF065F46);       // Emerald 800
  static const Color writerLight = Color(0xFF10B981);        // Emerald 500
  
  // Illustrator Theme (Lighter Greens - Creative)
  static const Color illustratorPrimary = Color(0xFF34D399); // Emerald 400
  static const Color illustratorSecondary = Color(0xFF6EE7B7); // Emerald 300
  static const Color illustratorAccent = Color(0xFF10B981);  // Emerald 500
  static const Color illustratorLight = Color(0xFFA7F3D0);   // Emerald 200
  
  // Premium Colors (Golden accents)
  static const Color premiumGold = Color(0xFFFFD700);
  static const Color premiumOrange = Color(0xFFFFA500);
  static const Color premiumBronze = Color(0xFFCD7F32);
  
  // Neutral Colors
  static const Color backgroundLight = Color(0xFFFAFAFA);
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color cardBackgroundElevated = Color(0xFFFFFFFE);
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textTertiary = Color(0xFF94A3B8);
  static const Color divider = Color(0xFFE2E8F0);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  
  // Gradients
  static const LinearGradient writerGradient = LinearGradient(
    colors: [writerPrimary, writerSecondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient illustratorGradient = LinearGradient(
    colors: [illustratorPrimary, illustratorSecondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient premiumGradient = LinearGradient(
    colors: [premiumGold, premiumOrange, premiumBronze],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient subtleGradient = LinearGradient(
    colors: [Color(0xFFF8FAFC), Color(0xFFF1F5F9)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  // Shadows
  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 10,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: Color(0x05000000),
      blurRadius: 20,
      offset: Offset(0, 8),
    ),
  ];

  
  static const List<BoxShadow> elevatedShadow = [
    BoxShadow(
      color: Color(0x15000000),
      blurRadius: 20,
      offset: Offset(0, 8),
    ),
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 40,
      offset: Offset(0, 16),
    ),
  ];
  
  static const List<BoxShadow> premiumShadow = [
    BoxShadow(
      color: Color(0x20FFD700),
      blurRadius: 20,
      offset: Offset(0, 8),
    ),
    BoxShadow(
      color: Color(0x10FFA500),
      blurRadius: 40,
      offset: Offset(0, 16),
    ),
  ];
  
  // Border radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 24.0;
  
  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;
  
  // Typography
  static const TextStyle displayLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
    height: 1.2,
  );
  
  static const TextStyle displayMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.25,
    height: 1.3,
  );
  
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.25,
    height: 1.3,
  );
  
  static const TextStyle headlineMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.15,
    height: 1.4,
  );
  
  static const TextStyle titleLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.1,
    height: 1.4,
  );
  
  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.5,
  );
  
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
    height: 1.5,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 1.5,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.4,
  );
  
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.4,
  );
  
  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.3,
  );
  
  static const TextStyle labelSmall = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.2,
  );
  
  // Animation durations
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationMedium = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);
  
  // Animation curves
  static const Curve curveDefault = Curves.easeOutCubic;
  static const Curve curveEmphasized = Curves.easeOutExpo;
  static const Curve curveSpring = Curves.elasticOut;
  
  // Role-based theme data
  static ThemeData getThemeForRole(String role) {
    final isWriter = role.toLowerCase() == 'escritor' || role.toLowerCase() == 'writer';
    final primaryColor = isWriter ? writerPrimary : illustratorPrimary;
    final secondaryColor = isWriter ? writerSecondary : illustratorSecondary;
    
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
        primary: primaryColor,
        secondary: secondaryColor,
        surface: cardBackground,
        background: backgroundLight,
      ),
      textTheme: const TextTheme(
        displayLarge: displayLarge,
        displayMedium: displayMedium,
        headlineLarge: headlineLarge,
        headlineMedium: headlineMedium,
        titleLarge: titleLarge,
        titleMedium: titleMedium,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        bodySmall: bodySmall,
        labelLarge: labelLarge,
        labelMedium: labelMedium,
        labelSmall: labelSmall,
      ),
      cardTheme: CardThemeData( // <-- ¡Usa CardThemeData!
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLarge),
        ),
        color: cardBackground,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: spacingL,
            vertical: spacingM,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacingM,
          vertical: spacingM,
        ),
      ),
    );
  }
}

/// Extension to easily access theme colors based on user role
extension PremiumThemeExtension on BuildContext {
  Color get roleBasedPrimary {
    // Get from shared preferences or state management
    // For now, defaulting to illustrator theme
    return PremiumTheme.illustratorPrimary;
  }
  
  LinearGradient get roleBasedGradient {
    return PremiumTheme.illustratorGradient;
  }
  
  bool get isPremiumUser {
    // Check user's subscription status from state
    return false; // Placeholder
  }
}
