import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recase/recase.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../data/source/settings.dart';
import '../view/app.dart';
import 'color_picker.dart';
import 'color_role.dart';
import 'locale.dart';
import 'piano_key.dart';
import 'piano_section.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ExpansionTile(
          title: Text(context.locale.themeBrightness),
          leading: const Icon(Icons.brightness_6),
          children: [
            Consumer(builder: (context, ref, child) {
              final brightness = ref.watch(themeModeProvider);
              return ListTile(
                title: SegmentedButton(
                  segments: [
                    for (final item in [
                      ThemeMode.light,
                      ThemeMode.system,
                      ThemeMode.dark,
                    ])
                      ButtonSegment(
                        value: item,
                        label: Text(item.label(context)),
                        icon: Icon(item.icon),
                      ),
                  ],
                  selected: {brightness},
                  onSelectionChanged: (value) {
                    ref.read(themeModeProvider.notifier).state = value.first;
                  },
                ),
              );
            }),
          ],
        ),
        Consumer(builder: (context, ref, child) {
          final color = ref.watch(themeColorProvider);
          return ColorPicker(
            color: color,
            onColorChanged: (value) {
              ref.read(themeColorProvider.notifier).state = value;
            },
            label: context.locale.themeColor,
          );
        }),
        Consumer(builder: (context, ref, child) {
          final keyWidth = ref.watch(keyWidthProvider);
          final invertKeys = ref.watch(invertKeysProvider);
          final keyLabel = ref.watch(keyLabelsProvider);
          final colorRole = ref.watch(colorRoleProvider);
          final haptics = ref.watch(hapticsProvider);
          final disableScroll = ref.watch(disableScrollProvider);
          return ExpansionTile(
            title: Text(context.locale.keySettings),
            leading: const Icon(Icons.music_note),
            children: [
              ListTile(
                title: Text(context.locale.keyWidth),
                leading: const Icon(Icons.settings_ethernet),
                subtitle: Slider(
                  label: keyWidth.toString(),
                  value: keyWidth,
                  min: 50,
                  max: 200,
                  onChanged: (value) {
                    setState(() {
                      ref.read(keyWidthProvider.notifier).state = value;
                    });
                  },
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.restore),
                  tooltip: context.locale.resetToDefault,
                  onPressed: keyWidth == 80
                      ? null
                      : () {
                          setState(() {
                            ref.read(keyWidthProvider.notifier).state = 80;
                          });
                        },
                ),
              ),
              ListTile(
                title: Text(context.locale.invertKeys),
                leading: const Icon(Icons.swap_horiz),
                trailing: Switch(
                  value: invertKeys,
                  onChanged: (value) {
                    setState(() {
                      ref.read(invertKeysProvider.notifier).state = value;
                    });
                  },
                ),
              ),
              ListTile(
                title: Text(context.locale.colorRole),
                leading: const Icon(Icons.colorize),
                trailing: DropdownButton<ColorRole>(
                  value: colorRole,
                  onChanged: (value) {
                    setState(() {
                      ref.read(colorRoleProvider.notifier).state = value!;
                    });
                  },
                  items: [
                    for (final item in ColorRole.values)
                      DropdownMenuItem(
                        value: item,
                        child: Text(item.name.titleCase),
                      ),
                  ],
                ),
              ),
              ListTile(
                title: Text(context.locale.keyLabels),
                leading: const Icon(Icons.label),
                trailing: DropdownButton<PitchLabels>(
                  value: keyLabel,
                  onChanged: (value) {
                    setState(() {
                      ref.read(keyLabelsProvider.notifier).state = value!;
                    });
                  },
                  items: [
                    for (final item in PitchLabels.values)
                      DropdownMenuItem(
                        value: item,
                        child: Text(item.name.titleCase),
                      ),
                  ],
                ),
              ),
              ListTile(
                title: Text(context.locale.hapticFeedback),
                leading: const Icon(Icons.vibration),
                trailing: Switch(
                  value: haptics,
                  onChanged: (value) {
                    setState(() {
                      ref.read(hapticsProvider.notifier).state = value;
                    });
                  },
                ),
              ),
              ListTile(
                title: Text(context.locale.disableScroll),
                leading: const Icon(Icons.list),
                trailing: Switch(
                  value: disableScroll,
                  onChanged: (value) {
                    setState(() {
                      ref.read(disableScrollProvider.notifier).state = value;
                    });
                  },
                ),
              ),
              Container(
                width: double.infinity,
                height: 300,
                color: Theme.of(context).colorScheme.surfaceVariant,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: IgnorePointer(
                    child: PianoSection(
                      index: 4,
                      onPlay: (midi) {},
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
        Consumer(builder: (context, ref, child) {
          return ExpansionTile(
            title: Text(context.locale.language),
            leading: const Icon(Icons.language),
            children: [
              SizedBox(
                width: double.infinity,
                child: Wrap(
                  children: [
                    for (final locale in AppLocalizations.supportedLocales)
                      TextButton.icon(
                        icon: locale.flag,
                        label: Text(locale.description(context)),
                        onPressed: ref.watch(localeProvider)?.languageCode ==
                                locale.languageCode
                            ? null
                            : () => ref.read(localeProvider.notifier).state =
                                locale,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              if (ref.watch(localeProvider) != null)
                OutlinedButton(
                  child: Text(context.locale.resetToDefault),
                  onPressed: () =>
                      ref.read(localeProvider.notifier).state = null,
                ),
              const SizedBox(height: 10),
            ],
          );
        }),
      ],
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

  IconData get icon {
    switch (this) {
      case ThemeMode.light:
        return Icons.wb_sunny;
      case ThemeMode.dark:
        return Icons.nights_stay;
      case ThemeMode.system:
        return Icons.brightness_auto;
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

  CountryFlag get flag {
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
        height: 24,
        width: 31,
        borderRadius: 4,
      );
    }
    return CountryFlag.fromLanguageCode(
      languageCode.toUpperCase(),
      height: 24,
      width: 31,
      borderRadius: 4,
    );
  }
}
