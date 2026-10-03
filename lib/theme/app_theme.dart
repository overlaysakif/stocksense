import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryOrange = Color(0xFFF97316);
  static const Color darkOrange = Color(0xFFC2410C);
  static const Color charcoal = Color(0xFF252525);
  static const Color softBackground = Color(0xFFF7F7F5);

  static ThemeData light() {
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: primaryOrange,
          brightness: Brightness.light,
        ).copyWith(
          primary: primaryOrange,
          onPrimary: Colors.white,
          secondary: darkOrange,
          onSecondary: Colors.white,
          surface: Colors.white,
          onSurface: charcoal,
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: softBackground,

      appBarTheme: const AppBarTheme(
        backgroundColor: softBackground,
        foregroundColor: charcoal,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),

      textTheme: const TextTheme(
        headlineLarge: TextStyle(color: charcoal),
        headlineMedium: TextStyle(color: charcoal),
        headlineSmall: TextStyle(color: charcoal),
        titleLarge: TextStyle(color: charcoal),
        titleMedium: TextStyle(color: charcoal),
        titleSmall: TextStyle(color: charcoal),
        bodyLarge: TextStyle(color: charcoal),
        bodyMedium: TextStyle(color: charcoal),
      ),

      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: Colors.grey.shade200),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        labelStyle: const TextStyle(color: Color(0xFF666666)),
        hintStyle: const TextStyle(color: Color(0xFF999999)),
        prefixIconColor: charcoal,
        suffixIconColor: charcoal,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primaryOrange, width: 1.7),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primaryOrange,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryOrange,
        foregroundColor: Colors.white,
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: charcoal,
        indicatorColor: primaryOrange.withValues(alpha: 0.20),
        elevation: 4,
        iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: primaryOrange);
          }

          return const IconThemeData(color: Colors.white70);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              color: primaryOrange,
              fontWeight: FontWeight.w700,
            );
          }

          return const TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.w500,
          );
        }),
      ),

      snackBarTheme: const SnackBarThemeData(
        backgroundColor: charcoal,
        contentTextStyle: TextStyle(color: Colors.white),
        behavior: SnackBarBehavior.floating,
      ),

      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primaryOrange,
      ),

      dividerTheme: DividerThemeData(color: Colors.grey.shade200),
    );
  }
}
