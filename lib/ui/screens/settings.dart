import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_piano/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:recase/recase.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../src/services/settings.dart';
import '../../src/models/settings_models.dart';
import '../../src/version.dart';
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

    return Scaffold(
      backgroundColor: shadTheme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: shadTheme.colorScheme.background,
        elevation: 0,
        leading: ShadButton.ghost(
          child: const Icon(LucideIcons.arrowLeft),
          onPressed: () => context.pop(),
        ),
        title: Text(
          context.locale.settings,
          style: shadTheme.textTheme.h4,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Theme Section
              _SectionHeader(title: context.locale.themeBrightness),
              _ThemeItem(
                label: context.locale.themeBrightnessSystem,
                icon: LucideIcons.sunMoon,
                isSelected: themeMode == ThemeMode.system,
                onPressed: () => settings.themeMode.value = ThemeMode.system,
              ),
              _ThemeItem(
                label: context.locale.themeBrightnessLight,
                icon: LucideIcons.sun,
                isSelected: themeMode == ThemeMode.light,
                onPressed: () => settings.themeMode.value = ThemeMode.light,
              ),
              _ThemeItem(
                label: context.locale.themeBrightnessDark,
                icon: LucideIcons.moon,
                isSelected: themeMode == ThemeMode.dark,
                onPressed: () => settings.themeMode.value = ThemeMode.dark,
              ),
              const SizedBox(height: 24),
                
              // Color Section
              _SectionHeader(title: context.locale.themeColor),
              ColorPicker(
                color: themeColor,
                onColorChanged: (value) => settings.themeColor.value = value,
                label: context.locale.themeColor,
              ),
              const SizedBox(height: 24),
                
              // Keyboard Section
              _SectionHeader(title: context.locale.keySettings),
              Text(context.locale.keyWidth, style: shadTheme.textTheme.muted),
              const SizedBox(height: 8),
              ShadSlider(
                initialValue: keyWidth,
                min: 50,
                max: 200,
                onChanged: (value) => settings.keyWidth.value = value,
              ),
              const SizedBox(height: 8),
              _SettingRow(
                label: context.locale.invertKeys,
                child: ShadSwitch(
                  value: invertKeys,
                  onChanged: (value) => settings.invertKeys.value = value,
                ),
              ),
              const SizedBox(height: 24),
                
              // Advanced Section
              _SectionHeader(title: "Advanced"),
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
              const SizedBox(height: 8),
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
              const SizedBox(height: 8),
              _SettingRow(
                label: context.locale.hapticFeedback,
                child: ShadSwitch(
                  value: haptics,
                  onChanged: (value) => settings.haptics.value = value,
                ),
              ),
              const SizedBox(height: 8),
              _SettingRow(
                label: context.locale.disableScroll,
                child: ShadSwitch(
                  value: disableScroll,
                  onChanged: (value) => settings.disableScroll.value = value,
                ),
              ),
              const SizedBox(height: 24),
                
              // Language Section
              _SectionHeader(title: context.locale.language),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final locale in AppLocalizations.supportedLocales)
                    ShadButton.outline(
                      onPressed:
                          currentLocale?.languageCode == locale.languageCode
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
              const SizedBox(height: 32),
                
              // About Section (Premium Design)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: shadTheme.colorScheme.muted.withValues(alpha: 0.1),
                ),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: shadTheme.colorScheme.foreground
                                .withValues(alpha: 0.1),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Image.asset(
                          'web/icons/Icon-192.png',
                          width: 96,
                          height: 96,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      context.locale.title,
                      style: shadTheme.textTheme.h3,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${context.locale.version} $packageVersion',
                      style: shadTheme.textTheme.muted,
                    ),
                    const SizedBox(height: 24),
                    ShadButton.secondary(
                      onPressed: () async {
                        final url = Uri.parse('https://pocketpiano.app');
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        }
                      },
                      child: Text(context.locale.webVersion),
                    ),
                    const SizedBox(height: 12),
                    ShadButton.outline(
                      onPressed: () {
                        showLicensePage(
                          context: context,
                          applicationName: context.locale.title,
                          applicationVersion: packageVersion,
                        );
                      },
                      child: Text(context.locale.showLicenses),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: ShadTheme.of(context)
            .textTheme
            .large
            .copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _ThemeItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onPressed;

  const _ThemeItem({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ShadButton.outline(
        onPressed: onPressed,
        mainAxisAlignment: MainAxisAlignment.start,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 16),
                const SizedBox(width: 12),
                Text(label),
              ],
            ),
            if (isSelected) const Icon(LucideIcons.check, size: 16),
          ],
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
