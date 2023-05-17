import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recase/recase.dart';

import '../../data/source/settings.dart';
import 'color_picker.dart';
import 'color_role.dart';
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
          title: const Text('Theme Brightness'),
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
                        label: Text(item.label),
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
            label: 'Theme Color',
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
            title: const Text('Key Settings'),
            leading: const Icon(Icons.music_note),
            children: [
              ListTile(
                title: const Text('Key Width'),
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
                  tooltip: 'Reset to default',
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
                title: const Text('Invert Keys'),
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
                title: const Text('Color Role'),
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
                title: const Text('Key Labels'),
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
                title: const Text('Haptic Feedback'),
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
                title: const Text('Disable Scroll'),
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
      ],
    );
  }
}

extension on ThemeMode {
  String get label {
    switch (this) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
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
