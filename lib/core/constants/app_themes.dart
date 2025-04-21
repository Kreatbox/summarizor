import 'package:flutter/material.dart';
import 'package:summarizor/core/constants/app_colors.dart';

class AppThemes {
  static final lightTheme = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: Colors.white,
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontFamily: 'poppinsreg',
        fontSize: 30,
        fontWeight: FontWeight.w400,
        color: AppColors.grey,
      ),
      displayMedium: TextStyle(
        fontFamily: 'poppinsBold',
        fontSize: 45,
        fontWeight: FontWeight.w400,
        color: AppColors.primary,
      ),
      displaySmall: TextStyle(
        fontFamily: 'poppinsBold',
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: AppColors.primary,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'poppinsBold',
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: AppColors.grey,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'poppinsBold',
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: Colors.black,
      ),
      bodySmall: TextStyle(
        fontFamily: 'poppinsBold',
        fontSize: 15,
        fontWeight: FontWeight.w300,
        color: Colors.white,
      ),
      labelLarge: TextStyle(
        fontFamily: 'poppinsreg',
        fontSize: 20,
        fontWeight: FontWeight.w300,
        color: AppColors.lightGrey,
      ),
      headlineLarge: TextStyle(
        fontFamily: 'poppinsreg',
        fontSize: 40,
        fontWeight: FontWeight.w300,
        color: AppColors.grey,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'poppinsBold',
        fontSize: 40,
        fontWeight: FontWeight.w300,
        color: AppColors.primary,
      ),
      headlineSmall: TextStyle(
        fontFamily: 'poppinsreg',
        fontSize: 25,
        fontWeight: FontWeight.w300,
        color: AppColors.grey,
      ),
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      error: AppColors.error,
      surface: Colors.white,
      onSurface: Colors.black
    ),
  );

  static final darkTheme = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: Colors.black,
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontFamily: 'poppinsreg',
        fontSize: 30,
        fontWeight: FontWeight.w400,
        color: AppColors.grey,
      ),
      displayMedium: TextStyle(
        fontFamily: 'poppinsBold',
        fontSize: 45,
        fontWeight: FontWeight.w400,
        color: AppColors.primary,
      ),
      displaySmall: TextStyle(
        fontFamily: 'poppinsBold',
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: AppColors.primary,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'poppinsBold',
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: AppColors.grey,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'poppinsBold',
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
      bodySmall: TextStyle(
        fontFamily: 'poppinsBold',
        fontSize: 15,
        fontWeight: FontWeight.w300,
        color: Colors.white,
      ),
      labelLarge: TextStyle(
        fontFamily: 'poppinsreg',
        fontSize: 20,
        fontWeight: FontWeight.w300,
        color: AppColors.darkGrey,
      ),
      headlineLarge: TextStyle(
        fontFamily: 'poppinsreg',
        fontSize: 40,
        fontWeight: FontWeight.w300,
        color: AppColors.grey,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'poppinsBold',
        fontSize: 40,
        fontWeight: FontWeight.w300,
        color: AppColors.primary,
      ),
      headlineSmall: TextStyle(
        fontFamily: 'poppinsreg',
        fontSize: 25,
        fontWeight: FontWeight.w300,
        color: AppColors.grey,
      ),
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      error: AppColors.error,
      surface: Colors.black,
      onSurface: Colors.white,
    ),
  );
}
