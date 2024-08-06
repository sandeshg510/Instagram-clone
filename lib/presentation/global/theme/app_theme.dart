import 'package:flutter/material.dart';
import '../../../consts.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
      useMaterial3: true,
      textTheme: const TextTheme(headlineLarge: TextStyle(fontSize: 16)),
      // AppTextTheme.lightTextTheme,
      scaffoldBackgroundColor: AppColors.white,
      brightness: Brightness.light,
      iconTheme: const IconThemeData(color: AppColors.black),
      appBarTheme: const AppBarTheme(backgroundColor: AppColors.white),
      colorScheme: const ColorScheme.light(
          brightness: Brightness.light,
          primary: AppColors.black,
          secondary: darkGreyColor,
          tertiary: AppColors.white));

  static ThemeData darkTheme = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.black,
      iconTheme: const IconThemeData(color: AppColors.white),
      appBarTheme: const AppBarTheme(backgroundColor: backGroundColor),
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
          brightness: Brightness.dark,
          primary: AppColors.white,
          secondary: AppColors.greyColor,
          tertiary: AppColors.primaryDarkBlue));
}
