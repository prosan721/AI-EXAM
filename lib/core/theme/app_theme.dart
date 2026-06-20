import 'package:flutter/material.dart';

class AppTheme {
  // Brand colors
  static const Color primary = Color(0xFF4F46E5); // Indigo
  static const Color secondary = Color(0xFF8B5CF6); // Violet
  static const Color accent = Color(0xFF10B981); // Emerald
  static const Color warning = Color(0xFFF59E0B); // Amber
  static const Color danger = Color(0xFFEF4444); // Red
  
  // HSL customized slate neutrals
  static const Color lightBg = Color(0xFFF8FAFC);
  static const Color lightCard = Colors.white;
  static const Color lightTextMain = Color(0xFF0F172A);
  static const Color lightTextMuted = Color(0xFF64748B);
  static const Color lightBorder = Color(0xFFE2E8F0);
  
  static const Color darkBg = Color(0xFF0B0F19);
  static const Color darkCard = Color(0xFF151D30);
  static const Color darkTextMain = Color(0xFFF1F5F9);
  static const Color darkTextMuted = Color(0xFF94A3B8);
  static const Color darkBorder = Color(0xFF1E293B);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primary,
      scaffoldBackgroundColor: lightBg,
      cardColor: lightCard,
      colorScheme: const ColorScheme.light(
        primary: primary,
        secondary: secondary,
        surface: lightCard,
        error: danger,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: lightCard,
        foregroundColor: lightTextMain,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: lightTextMain),
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(color: lightTextMain, fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Outfit'),
        titleMedium: TextStyle(color: lightTextMain, fontSize: 16, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: lightTextMain, fontSize: 14),
        bodyMedium: TextStyle(color: lightTextMuted, fontSize: 12),
      ),
      cardTheme: CardThemeData(
        color: lightCard,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.04),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      dividerTheme: const DividerThemeData(
        color: lightBorder,
        thickness: 1,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primary,
      scaffoldBackgroundColor: darkBg,
      cardColor: darkCard,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: secondary,
        surface: darkCard,
        error: danger,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkCard,
        foregroundColor: darkTextMain,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: darkTextMain),
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(color: darkTextMain, fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Outfit'),
        titleMedium: TextStyle(color: darkTextMain, fontSize: 16, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: darkTextMain, fontSize: 14),
        bodyMedium: TextStyle(color: darkTextMuted, fontSize: 12),
      ),
      cardTheme: CardThemeData(
        color: darkCard,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      dividerTheme: const DividerThemeData(
        color: darkBorder,
        thickness: 1,
      ),
    );
  }
}
