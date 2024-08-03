import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/presentation/global/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  static final ThemeData _lightTheme = AppTheme.lightTheme;
  static final ThemeData _darkTheme = AppTheme.darkTheme;
  ThemeCubit() : super(ThemeState(_darkTheme));

  void toggleTheme(bool isDark) {
    if (isDark == true) {
      emit(ThemeState(_lightTheme));
      _saveTheme(isDark);
    }

    if (isDark == false) {
      emit(ThemeState(_darkTheme));
      _saveTheme(isDark);
    }
  }

  Future<void> _saveTheme(bool isDark) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool('isDark', isDark);
  }

  static Future<bool> _loadTheme() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getBool('isDark') ?? false;
  }

  Future<void> setInitialTheme() async {
    final isDark = await _loadTheme();
    final themeData = isDark ? _darkTheme : _lightTheme;
    emit(ThemeState(themeData));
  }
}
