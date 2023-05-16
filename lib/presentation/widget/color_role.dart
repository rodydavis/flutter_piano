// ignore_for_file: public_member_api_docs, sort_constructors_first
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
