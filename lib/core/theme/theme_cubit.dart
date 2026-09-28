import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit(this._settingsBox)
    : super(
        _settingsBox.get(_darkModeKey, defaultValue: false) as bool
            ? ThemeMode.dark
            : ThemeMode.light,
      );

  static const _darkModeKey = 'dark_mode';
  final Box<dynamic> _settingsBox;

  Future<void> toggleTheme() async {
    final nextMode = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    emit(nextMode);
    await _settingsBox.put(_darkModeKey, nextMode == ThemeMode.dark);
  }
}
