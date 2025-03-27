import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class MaterialTheme {
  static const seedColor =
      Color(0xFF4CAF50); // Change this to your desired color

  static ThemeData baseTheme(Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    );

    return ThemeData(
        colorScheme: colorScheme,
        useMaterial3: true,
        textTheme: GoogleFonts.interTextTheme().copyWith(
          headlineLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),

          headlineSmall: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),

          bodyLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
          // "Welcome back!"

          bodyMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: colorScheme.onSurface,
          ),
          // "Please log in..." & Input Fields

          labelLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: colorScheme.onPrimary,
          ),
          // "Log In" & "Log In With Google"

          bodySmall: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: colorScheme.onSurface.withOpacity(0.7),
          ), // "Forgot password?" & "Don't have an account?"
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: colorScheme.surfaceContainer,
          // Light grayish background
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12), // Soft rounded corners
            borderSide: BorderSide.none, // No visible border
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          hintStyle: TextStyle(
            color: Colors.grey.shade400, // Light gray hint text
            fontSize: 16,
          ),
        ),
        dropdownMenuTheme: DropdownMenuThemeData(
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: colorScheme.surfaceContainer,
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
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            hintStyle: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade400,
              fontSize: 16,
            ),
            labelStyle: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade400,
              fontSize: 16,
            ),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            minimumSize: Size(1.sw, 50),
            backgroundColor: colorScheme.onSurface,
            // Background color
            foregroundColor: colorScheme.surface,
            // Text color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // Rounded corners
            ),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            textStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        searchBarTheme: SearchBarThemeData(
          elevation: WidgetStateProperty.all(0),
          padding:
              WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 16)),
          hintStyle: WidgetStateProperty.all(
              TextStyle(fontSize: 16.sp, fontWeight: FontWeight.normal)),
        ));
  }

  static ThemeData lightTheme() => baseTheme(Brightness.light);

  static ThemeData darkTheme() => baseTheme(Brightness.dark);
}
