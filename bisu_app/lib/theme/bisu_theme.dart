import 'package:flutter/material.dart';

import 'package:bisu_app/theme/bisu_colors.dart';
import 'package:bisu_app/theme/bisu_typography.dart';

/// Assembles the BI-SU [ThemeData] from colors + typography.
class BisuTheme {
  const BisuTheme._();

  /// The single light theme used by the whole app.
  static ThemeData get light {
    const ColorScheme scheme = ColorScheme(
      brightness: Brightness.light,
      primary: BisuColors.goldDeep,
      onPrimary: BisuColors.white,
      secondary: BisuColors.gold,
      onSecondary: BisuColors.white,
      surface: BisuColors.paper,
      onSurface: BisuColors.ink,
      error: Color(0xFFB23B52),
      onError: BisuColors.white,
    );

    const TextTheme textTheme = TextTheme(
      displayLarge: BisuType.display,
      displayMedium: BisuType.display,
      headlineMedium: BisuType.heading,
      titleLarge: BisuType.heading,
      titleMedium: BisuType.title,
      bodyLarge: BisuType.body,
      bodyMedium: BisuType.body,
      bodySmall: BisuType.caption,
      labelLarge: BisuType.label,
      labelSmall: BisuType.caption,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: BisuColors.ivory,
      canvasColor: BisuColors.ivory,
      dividerColor: BisuColors.hair,
      splashFactory: InkRipple.splashFactory,
      // Body sans is the global default family fallback.
      fontFamilyFallback: BisuType.sansFallback,
      textTheme: textTheme,
      iconTheme: const IconThemeData(color: BisuColors.inkSoft),
      dividerTheme: const DividerThemeData(
        color: BisuColors.hair,
        thickness: 1,
        space: 1,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: BisuColors.paper,
        foregroundColor: BisuColors.ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: BisuColors.paper,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: BisuColors.paper,
      ),
    );
  }
}
