import 'package:flutter/material.dart';

class Settings {
  Settings({
    this.darkMode = false,
    this.useSystemSetting = true,
    this.locale = const Locale("en", "US"),
    this.widthRatio = 0.5,
    this.showLabels = true,
    this.labelsOnlyOctaves = false,
    this.disableScroll = false,
    this.shouldVibrate = true,
  });

  bool darkMode,
      useSystemSetting,
      showLabels,
      labelsOnlyOctaves,
      disableScroll,
      shouldVibrate;
  Locale locale;
  double widthRatio;
}
