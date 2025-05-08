// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData lightTheme(String languageCode) {
    final isArabic = languageCode == 'ar';
    
    return ThemeData(
      useMaterial3: true,
      fontFamily: isArabic ? 'Cairo' : 'Poppins',
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        tertiary: AppColors.tertiary,
        error: AppColors.error,
        background: AppColors.background,
        surface: AppColors.surface,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onTertiary: Colors.white,
        onError: Colors.white,
        onBackground: AppColors.textPrimary,
        onSurface: AppColors.textPrimary,
        brightness: Brightness.light,
      ),
      
      textTheme: TextTheme(
        displayLarge: _getTextStyle(isArabic, 
          fontSize: 32, 
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        displayMedium: _getTextStyle(isArabic, 
          fontSize: 28, 
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        displaySmall: _getTextStyle(isArabic, 
          fontSize: 24, 
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        headlineLarge: _getTextStyle(isArabic, 
          fontSize: 22, 
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        headlineMedium: _getTextStyle(isArabic, 
          fontSize: 20, 
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        headlineSmall: _getTextStyle(isArabic, 
          fontSize: 18, 
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        titleLarge: _getTextStyle(isArabic, 
          fontSize: 18, 
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        titleMedium: _getTextStyle(isArabic, 
          fontSize: 16, 
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        titleSmall: _getTextStyle(isArabic, 
          fontSize: 14, 
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        bodyLarge: _getTextStyle(isArabic, 
          fontSize: 16, 
          color: AppColors.textPrimary,
        ),
        bodyMedium: _getTextStyle(isArabic, 
          fontSize: 14, 
          color: AppColors.textPrimary,
        ),
        bodySmall: _getTextStyle(isArabic, 
          fontSize: 12, 
          color: AppColors.textSecondary,
        ),
        labelLarge: _getTextStyle(isArabic, 
          fontSize: 14, 
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
        labelMedium: _getTextStyle(isArabic, 
          fontSize: 12, 
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
        labelSmall: _getTextStyle(isArabic, 
          fontSize: 10, 
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondary,
        ),
      ),
      
      scaffoldBackgroundColor: AppColors.background,
      
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.primary),
        titleTextStyle: _getTextStyle(isArabic,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
        toolbarHeight: 60,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
        shadowColor: Colors.transparent,
      ),
      
      cardTheme: CardTheme(
        color: AppColors.card,
        elevation: 4,
        shadowColor: AppColors.shadow,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: AppColors.primary.withOpacity(0.3),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: _getTextStyle(isArabic,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          minimumSize: const Size(double.infinity, 50),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: _getTextStyle(isArabic,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          minimumSize: const Size(double.infinity, 50),
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: _getTextStyle(isArabic,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.primary.withOpacity(0.1),
        selectedColor: AppColors.primary.withOpacity(0.2),
        disabledColor: Colors.grey[300],
        labelStyle: _getTextStyle(isArabic,
          color: AppColors.primary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        secondaryLabelStyle: _getTextStyle(isArabic,
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: TextStyle(color: AppColors.textSecondary),
        labelStyle: TextStyle(color: AppColors.textSecondary),
        prefixIconColor: AppColors.primary,
        suffixIconColor: AppColors.textSecondary,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        floatingLabelStyle: TextStyle(color: AppColors.primary),
      ),
      
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: _getTextStyle(isArabic,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: _getTextStyle(isArabic,
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
      ),
      
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        circularTrackColor: Colors.white24,
        linearTrackColor: Colors.white24,
      ),
      
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.primary,
        inactiveTrackColor: AppColors.primary.withOpacity(0.3),
        thumbColor: AppColors.primary,
        overlayColor: AppColors.primary.withOpacity(0.2),
        valueIndicatorColor: AppColors.primary,
        valueIndicatorTextStyle: const TextStyle(
          color: Colors.white,
        ),
        trackHeight: 4,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
      ),
      
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.primary;
          }
          return Colors.transparent;
        }),
        checkColor: MaterialStateProperty.all(Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        side: BorderSide(color: AppColors.textSecondary, width: 1.5),
      ),
      
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 24,
        indent: 16,
        endIndent: 16,
      ),
      
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.selected)) {
            return Colors.white;
          }
          return Colors.grey[300]!;
        }),
        trackColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.primary;
          }
          return Colors.grey[400]!;
        }),
        trackOutlineColor: MaterialStateProperty.all(Colors.transparent),
      ),
      
      tabBarTheme: TabBarTheme(
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textSecondary,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        labelStyle: _getTextStyle(isArabic,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: _getTextStyle(isArabic,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      
      // Material 3 themes
      snackBarTheme: SnackBarThemeData(
        backgroundColor: Colors.grey[900],
        contentTextStyle: const TextStyle(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        modalBackgroundColor: Colors.white,
        modalElevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
      ),
      
      dialogTheme: DialogTheme(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        titleTextStyle: _getTextStyle(isArabic,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        contentTextStyle: _getTextStyle(isArabic,
          fontSize: 14,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
  
  static ThemeData darkTheme(String languageCode) {
    // TODO: نحتاج لتطبيق سمة الوضع الداكن بشكل كامل
    // للتبسيط، نستخدم سمة الوضع الفاتح مع بعض التعديلات
    
    final ThemeData baseTheme = lightTheme(languageCode);
    
    final ColorScheme darkColorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      brightness: Brightness.dark,
      background: const Color(0xFF121212),
      surface: const Color(0xFF1E1E1E),
      onPrimary: Colors.white,
      onBackground: Colors.white,
      onSurface: Colors.white,
    );
    
    return baseTheme.copyWith(
      colorScheme: darkColorScheme,
      scaffoldBackgroundColor: darkColorScheme.background,
      cardTheme: baseTheme.cardTheme.copyWith(
        color: darkColorScheme.surface,
      ),
      appBarTheme: baseTheme.appBarTheme.copyWith(
        backgroundColor: darkColorScheme.surface,
        titleTextStyle: baseTheme.appBarTheme.titleTextStyle?.copyWith(
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      bottomNavigationBarTheme: baseTheme.bottomNavigationBarTheme.copyWith(
        backgroundColor: darkColorScheme.surface,
      ),
      inputDecorationTheme: baseTheme.inputDecorationTheme.copyWith(
        fillColor: darkColorScheme.surface,
      ),
    );
  }
  
  // Helper method to get text style based on language
  static TextStyle _getTextStyle(
    bool isArabic, {
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.normal,
    Color? color,
  }) {
    return isArabic
      ? GoogleFonts.cairo(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
        )
      : GoogleFonts.poppins(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
        );
  }
}