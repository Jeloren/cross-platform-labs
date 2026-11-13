import 'package:material_ui/material_ui.dart';

import 'theme_colors.dart';

// Тема оформления.
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: ThemeColors.background,
      colorScheme: _colorScheme,
      appBarTheme: _appBarTheme,
      textTheme: ThemeData.light().textTheme.apply(
            bodyColor: ThemeColors.black,
            displayColor: ThemeColors.black,
          ),
    );
  }
}

final _colorScheme = ColorScheme.fromSeed(
  seedColor: ThemeColors.accent,
);

final _appBarTheme = AppBarTheme(
  toolbarHeight: 56,
  elevation: 0,
  scrolledUnderElevation: 0,
  centerTitle: true,
  titleTextStyle: const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: ThemeColors.white,
  ),
  backgroundColor: ThemeColors.black,
  foregroundColor: ThemeColors.white,
);
