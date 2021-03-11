import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'settings.dart';

@immutable
abstract class SettingsState {}

class InitialSettingsState extends SettingsState {}

class SettingsReady extends SettingsState {
  SettingsReady(this.settings);

  final Settings settings;

  ThemeMode get themeMode {
    if (!this.settings.useSystemSetting) {
      return this.settings.darkMode ? ThemeMode.dark : ThemeMode.light;
    }
    return ThemeMode.system;
  }
}
