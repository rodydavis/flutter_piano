import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_piano/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:recase/recase.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../src/services/settings.dart';
import '../../src/models/settings_models.dart';
import '../widgets/color_picker.dart';
import '../widgets/locale.dart';

class SettingsScreen extends HookWidget {
  const SettingsScreen({super.key, required this.settings});

  final SettingsService settings;

  @override
  Widget build(BuildContext context) {
    final themeMode = useListenableSelector(
        settings.themeMode, () => settings.themeMode.value);
    final themeColor = useListenableSelector(
        settings.themeColor, () => settings.themeColor.value);
    final keyWidth =
        useListenableSelector(settings.keyWidth, () => settings.keyWidth.value);
    final invertKeys = useListenableSelector(
        settings.invertKeys, () => settings.invertKeys.value);
    final keyLabel = useListenableSelector(
        settings.keyLabels, () => settings.keyLabels.value);
    final colorRole = useListenableSelector(
        settings.colorRole, () => settings.colorRole.value);
    final haptics =
        useListenableSelector(settings.haptics, () => settings.haptics.value);
    final disableScroll = useListenableSelector(
        settings.disableScroll, () => settings.disableScroll.value);
    final currentLocale =
        useListenableSelector(settings.locale, () => settings.locale.value);

    final shadTheme = ShadTheme.of(context);

    Widget buildBentoTile({
      required String title,
      required IconData icon,
      required Widget child,
      Color? accentColor,
    }) {
      return Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: shadTheme.colorScheme.border.withValues(alpha: 0.5),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(icon, size: 18, color: accentColor ?? shadTheme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: shadTheme.textTheme.large.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              child,
            ],
          ),
        ),
      );
    }

    final themeSection = buildBentoTile(
      title: context.locale.themeBrightness,
      icon: LucideIcons.sun,
      child: ShadRadioGroup<ThemeMode>(
        initialValue: themeMode,
        onChanged: (value) {
          if (value != null) settings.themeMode.value = value;
        },
        items: [
          for (final item in [
            ThemeMode.light,
            ThemeMode.system,
            ThemeMode.dark,
          ])
            ShadRadio(
              value: item,
              label: Text(item.label(context)),
            ),
        ],
      ),
    );

    final colorSection = buildBentoTile(
      title: context.locale.themeColor,
      icon: LucideIcons.palette,
      accentColor: themeColor,
      child: ColorPicker(
        color: themeColor,
        onColorChanged: (value) {
          settings.themeColor.value = value;
        },
        label: context.locale.themeColor,
      ),
    );

    final keyboardSection = buildBentoTile(
      title: context.locale.keySettings,
      icon: LucideIcons.keyboard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(context.locale.keyWidth, style: shadTheme.textTheme.muted),
          ShadSlider(
            initialValue: keyWidth,
            min: 50,
            max: 200,
            onChanged: (value) {
              settings.keyWidth.value = value;
            },
          ),
          _SettingRow(
            label: context.locale.invertKeys,
            child: ShadSwitch(
              value: invertKeys,
              onChanged: (value) => settings.invertKeys.value = value,
            ),
          ),
        ],
      ),
    );

    final advancedSection = buildBentoTile(
      title: "Advanced", // Might need locale key
      icon: LucideIcons.settings2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _SettingRow(
            label: context.locale.colorRole,
            child: ShadSelect<ColorRole>(
              initialValue: colorRole,
              onChanged: (value) {
                if (value != null) settings.colorRole.value = value;
              },
              options: [
                for (final item in ColorRole.values)
                  ShadOption(
                    value: item,
                    child: Text(item.name.titleCase),
                  ),
              ],
              selectedOptionBuilder: (context, value) =>
                  Text(value.name.titleCase),
            ),
          ),
          _SettingRow(
            label: context.locale.keyLabels,
            child: ShadSelect<PitchLabels>(
              initialValue: keyLabel,
              onChanged: (value) {
                if (value != null) settings.keyLabels.value = value;
              },
              options: [
                for (final item in PitchLabels.values)
                  ShadOption(
                    value: item,
                    child: Text(item.name.titleCase),
                  ),
              ],
              selectedOptionBuilder: (context, value) =>
                  Text(value.name.titleCase),
            ),
          ),
          _SettingRow(
            label: context.locale.hapticFeedback,
            child: ShadSwitch(
              value: haptics,
              onChanged: (value) => settings.haptics.value = value,
            ),
          ),
          _SettingRow(
            label: context.locale.disableScroll,
            child: ShadSwitch(
              value: disableScroll,
              onChanged: (value) => settings.disableScroll.value = value,
            ),
          ),
        ],
      ),
    );

    final languageSection = buildBentoTile(
      title: context.locale.language,
      icon: LucideIcons.languages,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final locale in AppLocalizations.supportedLocales)
                ShadButton.outline(
                  onPressed: currentLocale?.languageCode == locale.languageCode
                      ? null
                      : () => settings.locale.value = locale,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      locale.flag,
                      const SizedBox(width: 8),
                      Text(locale.description(context)),
                    ],
                  ),
                ),
            ],
          ),
          if (currentLocale != null) ...[
            const SizedBox(height: 12),
            ShadButton.ghost(
              onPressed: () => settings.locale.value = null,
              child: Text(context.locale.resetToDefault),
            ),
          ],
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(context.locale.settings),
        leading: ShadIconButton.ghost(
          onPressed: () => context.pop(),
          icon: const Icon(LucideIcons.chevronLeft),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 800;
              
              if (isWide) {
                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    // Layout: Theme (1/2), Color (1/2), Keyboard (1/3), Advanced (2/3), Language (1/1)
                    SizedBox(width: (constraints.maxWidth - 16) / 2, child: themeSection),
                    SizedBox(width: (constraints.maxWidth - 16) / 2, child: colorSection),
                    SizedBox(width: (constraints.maxWidth - 32) / 3, child: keyboardSection),
                    SizedBox(width: (constraints.maxWidth * 2 / 3) - 16, child: advancedSection),
                    SizedBox(width: constraints.maxWidth, child: languageSection),
                  ],
                );
              } else {
                return Column(
                  children: [
                    themeSection,
                    const SizedBox(height: 16),
                    colorSection,
                    const SizedBox(height: 16),
                    keyboardSection,
                    const SizedBox(height: 16),
                    advancedSection,
                    const SizedBox(height: 16),
                    languageSection,
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  const _SettingRow({required this.label, required this.child});
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          child,
        ],
      ),
    );
  }
}

extension on ThemeMode {
  String label(BuildContext context) {
    switch (this) {
      case ThemeMode.light:
        return context.locale.themeBrightnessLight;
      case ThemeMode.dark:
        return context.locale.themeBrightnessDark;
      case ThemeMode.system:
        return context.locale.themeBrightnessSystem;
    }
  }
}

extension on Locale {
  String description(BuildContext context) {
    switch (languageCode) {
      case 'en':
        return context.locale.languageEn;
      case 'es':
        return context.locale.languageEs;
      case 'de':
        return context.locale.languageDe;
      case 'fr':
        return context.locale.languageFr;
      case 'ja':
        return context.locale.languageJa;
      case 'ko':
        return context.locale.languageKo;
      case 'zh':
        return context.locale.languageZh;
      case 'ru':
        return context.locale.languageRu;
      default:
    }
    return 'Unknown';
  }

  Widget get flag {
    String? code;
    switch (languageCode) {
      case 'ja':
        code = 'jp';
      case 'en':
        code = 'us';
      case 'ko':
        code = 'kr';
      case 'zh':
        code = 'cn';
      case 'ru':
        code = 'ru';
      default:
    }
    if (code != null) {
      return CountryFlag.fromCountryCode(
        code,
        height: 16,
        width: 24,
        shape: const RoundedRectangle(2),
      );
    }
    return CountryFlag.fromLanguageCode(
      languageCode.toUpperCase(),
      height: 16,
      width: 24,
      shape: const RoundedRectangle(2),
    );
  }
}
