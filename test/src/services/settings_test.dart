import 'package:flutter/material.dart';
import 'package:flutter_piano/src/models/settings_models.dart';
import 'package:flutter_piano/src/services/settings.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SettingsService', () {
    late SharedPreferences prefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({
        'disableScroll': true,
        'splitKeyboard': false,
        'themeColor': Colors.blue.toARGB32(),
        'themeMode': 'dark',
        'invertKeys': true,
        'keyWidth': 100.0,
        'keyLabels': 'none',
        'colorRole': 'primary',
        'haptics': false,
        'locale': 'fr',
      });
      prefs = await SharedPreferences.getInstance();
    });

    test('loads initial values from SharedPreferences', () async {
      final service = SettingsService(prefs);

      expect(service.disableScroll.value, true);
      expect(service.splitKeyboard.value, false);
      expect(service.themeColor.value.toARGB32(), Colors.blue.toARGB32());
      expect(service.themeMode.value, ThemeMode.dark);
      expect(service.invertKeys.value, true);
      expect(service.keyWidth.value, 100.0);
      expect(service.keyLabels.value, PitchLabels.none);
      expect(service.colorRole.value, ColorRole.primary);
      expect(service.haptics.value, false);
      expect(service.locale.value, const Locale('fr'));
    });

    test('updates SharedPreferences when values change', () async {
      final service = SettingsService(prefs);

      service.disableScroll.value = false;
      expect(prefs.getBool('disableScroll'), false);

      service.splitKeyboard.value = true;
      expect(prefs.getBool('splitKeyboard'), true);

      service.themeColor.value = Colors.red;
      expect(prefs.getInt('themeColor'), Colors.red.toARGB32());

      service.themeMode.value = ThemeMode.light;
      expect(prefs.getString('themeMode'), 'light');

      service.invertKeys.value = false;
      expect(prefs.getBool('invertKeys'), false);

      service.keyWidth.value = 120.0;
      expect(prefs.getDouble('keyWidth'), 120.0);

      service.keyLabels.value = PitchLabels.both;
      expect(prefs.getString('keyLabels'), 'both');

      service.colorRole.value = ColorRole.monoChrome;
      expect(prefs.getString('colorRole'), 'monoChrome');

      service.haptics.value = true;
      expect(prefs.getBool('haptics'), true);

      service.locale.value = const Locale('en');
      expect(prefs.getString('locale'), 'en');
      
      service.locale.value = null;
      expect(prefs.containsKey('locale'), false);
    });

    test('defaults to standard values if SharedPreferences is empty', () async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      final service = SettingsService(prefs);

      expect(service.disableScroll.value, false);
      expect(service.splitKeyboard.value, true);
      expect(service.themeColor.value, Colors.red);
      expect(service.themeMode.value, ThemeMode.light);
      expect(service.invertKeys.value, false);
      expect(service.keyWidth.value, 80.0);
      expect(service.keyLabels.value, PitchLabels.both);
      expect(service.colorRole.value, ColorRole.monoChrome);
      expect(service.haptics.value, true);
      expect(service.locale.value, null);
    });
  });
}
