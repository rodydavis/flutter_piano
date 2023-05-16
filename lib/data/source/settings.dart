import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../presentation/widget/color_role.dart';
import '../../presentation/widget/piano_key.dart';

final disableScrollProvider = StateProvider<bool>(
  (ref) {
    ref.listenSelf((previous, next) async {
      final prefs = await ref.watch(prefsProvider.future);
      await prefs.setBool('disableScroll', next);
    });
    return false;
  },
);

final themeColorProvider = StateProvider<Color>((ref) {
  ref.listenSelf((previous, next) async {
    final prefs = await ref.watch(prefsProvider.future);
    await prefs.setInt('themeColor', next.value);
  });
  return Colors.red;
});

final themeModeProvider = StateProvider<ThemeMode>((ref) {
  ref.listenSelf((previous, next) async {
    final prefs = await ref.watch(prefsProvider.future);
    await prefs.setString('themeMode', next.name);
  });
  return ThemeMode.light;
});

final invertKeysProvider = StateProvider<bool>((ref) {
  ref.listenSelf((previous, next) async {
    final prefs = await ref.watch(prefsProvider.future);
    await prefs.setBool('invertKeys', next);
  });
  return false;
});

final keyWidthProvider = StateProvider<double>((ref) {
  ref.listenSelf((previous, next) async {
    final prefs = await ref.watch(prefsProvider.future);
    await prefs.setDouble('keyWidth', next);
  });
  return 80;
});

final keyLabelsProvider = StateProvider<PitchLabels>((ref) {
  ref.listenSelf((previous, next) async {
    final prefs = await ref.watch(prefsProvider.future);
    await prefs.setString('keyLabels', next.name);
  });
  return PitchLabels.both;
});

final colorRoleProvider = StateProvider<ColorRole>((ref) {
  ref.listenSelf((previous, next) async {
    final prefs = await ref.watch(prefsProvider.future);
    await prefs.setString('colorRole', next.name);
  });
  return ColorRole.monoChrome;
});

final hapticsProvider = StateProvider<bool>((ref) {
  ref.listenSelf((previous, next) async {
    final prefs = await ref.watch(prefsProvider.future);
    await prefs.setBool('haptics', next);
  });
  return true;
});

final currentOctaveProvider = StateProvider<int>((ref) {
  ref.listenSelf((previous, next) async {
    final prefs = await ref.watch(prefsProvider.future);
    await prefs.setInt('currentOctave', next);
  });
  return 4;
});

final prefsProvider = FutureProvider<SharedPreferences>((ref) {
  return SharedPreferences.getInstance();
});

final loadSettings = FutureProvider<void>((ref) async {
  final prefs = await ref.watch(prefsProvider.future);
  final themeColor = prefs.getInt('themeColor');
  if (themeColor != null) {
    ref.read(themeColorProvider.notifier).state = Color(themeColor);
  }
  final themeMode = prefs.getString('themeMode');
  if (themeMode != null) {
    ref.read(themeModeProvider.notifier).state = ThemeMode.values.firstWhere(
      (e) => e.name == themeMode,
    );
  }
  final invertKeys = prefs.getBool('invertKeys');
  if (invertKeys != null) {
    ref.read(invertKeysProvider.notifier).state = invertKeys;
  }
  final keyWidth = prefs.getDouble('keyWidth');
  if (keyWidth != null) {
    ref.read(keyWidthProvider.notifier).state = keyWidth;
  }
  final keyLabels = prefs.getString('keyLabels');
  if (keyLabels != null) {
    ref.read(keyLabelsProvider.notifier).state = PitchLabels.values.firstWhere(
      (e) => e.name == keyLabels,
    );
  }
  final colorRole = prefs.getString('colorRole');
  if (colorRole != null) {
    ref.read(colorRoleProvider.notifier).state = ColorRole.values.firstWhere(
      (e) => e.name == colorRole,
    );
  }
  final haptics = prefs.getBool('haptics');
  if (haptics != null) {
    ref.read(hapticsProvider.notifier).state = haptics;
  }
  final currentOctave = prefs.getInt('currentOctave');
  if (currentOctave != null) {
    ref.read(currentOctaveProvider.notifier).state = currentOctave;
  }
});
