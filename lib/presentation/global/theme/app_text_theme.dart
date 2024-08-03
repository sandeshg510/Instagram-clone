import 'package:flutter/material.dart';
import 'package:instagram_clone/consts.dart';

class AppTextTheme {
  AppTextTheme._();

  static TextTheme lightTextTheme = TextTheme(
    headlineLarge: const TextStyle().copyWith(
        fontWeight: FontWeight.w400,
        color: AppColors.textColorBlack,
        fontSize: 18),
    headlineSmall: const TextStyle().copyWith(
        fontWeight: FontWeight.w400,
        color: AppColors.textColorBlack,
        fontSize: 14),
  );
}
