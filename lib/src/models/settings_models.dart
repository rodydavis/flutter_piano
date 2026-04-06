import 'package:flutter/material.dart';

enum ColorRole {
  primary,
  primaryContainer,
  secondary,
  secondaryContainer,
  tertiary,
  tertiaryContainer,
  surface,
  inverseSurface,
  monoChrome,
}

enum PitchLabels {
  none,
  sharps,
  flats,
  both,
  midi,
}

extension ColorSchemeUtils on ColorScheme {
  Color color(ColorRole role) {
    switch (role) {
      case ColorRole.primary:
        return primary;
      case ColorRole.primaryContainer:
        return primaryContainer;
      case ColorRole.secondary:
        return secondary;
      case ColorRole.secondaryContainer:
        return secondaryContainer;
      case ColorRole.tertiary:
        return tertiary;
      case ColorRole.tertiaryContainer:
        return tertiaryContainer;
      case ColorRole.surface:
        return surface;
      case ColorRole.inverseSurface:
        return inverseSurface;
      case ColorRole.monoChrome:
        return Colors.black;
    }
  }

  Color onColor(ColorRole role) {
    switch (role) {
      case ColorRole.primary:
        return onPrimary;
      case ColorRole.primaryContainer:
        return onPrimaryContainer;
      case ColorRole.secondary:
        return onSecondary;
      case ColorRole.secondaryContainer:
        return onSecondaryContainer;
      case ColorRole.tertiary:
        return onTertiary;
      case ColorRole.tertiaryContainer:
        return onTertiaryContainer;
      case ColorRole.surface:
        return onSurface;
      case ColorRole.inverseSurface:
        return onInverseSurface;
      case ColorRole.monoChrome:
        return Colors.white;
    }
  }
}

extension MidiPitchName on int {
  String pitchName(PitchLabels type) {
    if (type == PitchLabels.midi) {
      return '$this';
    }
    if (type != PitchLabels.none) {
      final octave = (this / 12).floor() - 1;
      final pitchClass = this % 12;
      final flats = type == PitchLabels.flats || type == PitchLabels.both;
      final sharps = type == PitchLabels.sharps || type == PitchLabels.both;
      final both = type == PitchLabels.both;
      switch (pitchClass) {
        case 0:
          return 'C$octave';
        case 1:
          return both ? 'C♯/D♭$octave' : (sharps ? 'C♯$octave' : 'D♭$octave');
        case 2:
          return 'D$octave';
        case 3:
          return both ? 'D♯/E♭$octave' : (flats ? 'E♭$octave' : 'D♯$octave');
        case 4:
          return 'E$octave';
        case 5:
          return 'F$octave';
        case 6:
          return both ? 'F♯/G♭$octave' : (sharps ? 'F♯$octave' : 'G♭$octave');
        case 7:
          return 'G$octave';
        case 8:
          return both ? 'G♯/A♭$octave' : (flats ? 'A♭$octave' : 'G♯$octave');
        case 9:
          return 'A$octave';
        case 10:
          return both ? 'A♯/B♭$octave' : (flats ? 'B♭$octave' : 'A♯$octave');
        case 11:
          return 'B$octave';
        default:
      }
    }

    return '';
  }
}
