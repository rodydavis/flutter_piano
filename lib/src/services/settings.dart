import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/settings_models.dart';

@singleton
class SettingsService {
  final SharedPreferences _prefs;

  SettingsService(this._prefs) {
    _loadSettings();
  }

  final disableScroll = ValueNotifier<bool>(false);
  final splitKeyboard = ValueNotifier<bool>(true);
  final themeColor = ValueNotifier<Color>(Colors.red);
  final themeMode = ValueNotifier<ThemeMode>(ThemeMode.light);
  final invertKeys = ValueNotifier<bool>(false);
  final keyWidth = ValueNotifier<double>(80);
  final keyLabels = ValueNotifier<PitchLabels>(PitchLabels.both);
  final colorRole = ValueNotifier<ColorRole>(ColorRole.monoChrome);
  final haptics = ValueNotifier<bool>(true);
  final locale = ValueNotifier<Locale?>(null);

  void _loadSettings() {
    disableScroll.value = _prefs.getBool('disableScroll') ?? false;
    splitKeyboard.value = _prefs.getBool('splitKeyboard') ?? true;
    final colorValue = _prefs.getInt('themeColor');
    if (colorValue != null) themeColor.value = Color(colorValue);
    final modeName = _prefs.getString('themeMode');
    if (modeName != null) {
      themeMode.value = ThemeMode.values.firstWhere(
        (e) => e.name == modeName,
        orElse: () => ThemeMode.light,
      );
    }
    invertKeys.value = _prefs.getBool('invertKeys') ?? false;
    keyWidth.value = _prefs.getDouble('keyWidth') ?? 80;
    final labelsName = _prefs.getString('keyLabels');
    if (labelsName != null) {
      keyLabels.value = PitchLabels.values.firstWhere(
        (e) => e.name == labelsName,
        orElse: () => PitchLabels.both,
      );
    }
    final roleName = _prefs.getString('colorRole');
    if (roleName != null) {
      colorRole.value = ColorRole.values.firstWhere(
        (e) => e.name == roleName,
        orElse: () => ColorRole.monoChrome,
      );
    }
    haptics.value = _prefs.getBool('haptics') ?? true;
    
    final localeName = _prefs.getString('locale');
    if (localeName != null) {
      locale.value = Locale(localeName);
    }

    _setupListeners();
  }

  void _setupListeners() {
    disableScroll.addListener(() => _prefs.setBool('disableScroll', disableScroll.value));
    splitKeyboard.addListener(() => _prefs.setBool('splitKeyboard', splitKeyboard.value));
    themeColor.addListener(() => _prefs.setInt('themeColor', themeColor.value.toARGB32()));
    themeMode.addListener(() => _prefs.setString('themeMode', themeMode.value.name));
    invertKeys.addListener(() => _prefs.setBool('invertKeys', invertKeys.value));
    keyWidth.addListener(() => _prefs.setDouble('keyWidth', keyWidth.value));
    keyLabels.addListener(() => _prefs.setString('keyLabels', keyLabels.value.name));
    colorRole.addListener(() => _prefs.setString('colorRole', colorRole.value.name));
    haptics.addListener(() => _prefs.setBool('haptics', haptics.value));
    locale.addListener(() {
      if (locale.value != null) {
        _prefs.setString('locale', locale.value!.languageCode);
      } else {
        _prefs.remove('locale');
      }
    });
  }
}
