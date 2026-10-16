import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:naam_jaap/core/theme/app_colors.dart';

abstract final class AppFonts {
  static bool useGoogleFonts = true;

  static TextTheme body(TextTheme base) =>
      useGoogleFonts ? base.apply(fontFamily: GoogleFonts.poppins().fontFamily) : base;

  static TextStyle heading(TextStyle? style) => useGoogleFonts
      ? GoogleFonts.tiroDevanagariHindi(textStyle: style)
      : (style ?? const TextStyle());
}

abstract final class AppTheme {
  static ThemeData light() => _build(
        ColorScheme.fromSeed(
          seedColor: AppColors.saffron,
          primary: AppColors.kesari,
          secondary: AppColors.gold,
          tertiary: AppColors.maroon,
          surface: AppColors.cream,
          onSurface: AppColors.ink,
        ),
      );

  static ThemeData dark() => _build(
        ColorScheme.fromSeed(
          seedColor: AppColors.saffron,
          brightness: Brightness.dark,
          primary: AppColors.saffron,
          secondary: AppColors.lightGold,
          tertiary: AppColors.lotus,
          surface: AppColors.night,
          onSurface: AppColors.cream,
        ),
      );

  static ThemeData _build(ColorScheme scheme) {
    final isDark = scheme.brightness == Brightness.dark;
    final base = ThemeData(colorScheme: scheme, useMaterial3: true);
    final textTheme = AppFonts.body(base.textTheme).apply(
      bodyColor: scheme.onSurface,
      displayColor: scheme.onSurface,
    );
    final cardColor = isDark ? AppColors.nightSurface : Colors.white.withValues(alpha: 0.85);

    return base.copyWith(
      scaffoldBackgroundColor: scheme.surface,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        foregroundColor: scheme.onSurface,
        titleTextStyle: AppFonts.heading(textTheme.titleLarge).copyWith(
          color: isDark ? AppColors.lightGold : AppColors.maroon,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: AppColors.gold.withValues(alpha: isDark ? 0.25 : 0.3)),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: isDark ? AppColors.nightSurface : Colors.white,
        indicatorColor: scheme.primary.withValues(alpha: 0.18),
        labelTextStyle: WidgetStatePropertyAll(textTheme.labelSmall),
        elevation: 3,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          textStyle: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? AppColors.nightGlow : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        side: BorderSide(color: AppColors.gold.withValues(alpha: 0.4)),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: isDark ? AppColors.nightSurface : AppColors.cream,
        showDragHandle: true,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: isDark ? AppColors.nightSurface : AppColors.cream,
      ),
    );
  }
}
