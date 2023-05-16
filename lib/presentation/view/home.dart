// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dart_melty_soundfont/dart_melty_soundfont.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raw_sound/raw_sound_player.dart';
import 'package:recase/recase.dart';

import '../../data/source/settings.dart';
import '../widget/color_picker.dart';
import '../widget/color_role.dart';
import '../widget/piano_key.dart';
import '../widget/piano_section.dart';
import '../widget/piano_slider.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  Synthesizer? synth;

  static int bufferSize = 4096 << 4;
  static int nChannels = 1;
  static int sampleRate = 16000; //44100

  final _players = <int, List<RawSoundPlayer>>{};

  late ScrollController _controller;

  @override
  void initState() {
    super.initState();
    rootBundle.load('assets/sounds/Piano.sf2').then((bytes) async {
      final settings = SynthesizerSettings(
        sampleRate: sampleRate,
        blockSize: 64,
        maximumPolyphony: 64,
        enableReverbAndChorus: false,
      );
      if (mounted) {
        setState(() {
          synth = Synthesizer.loadByteData(bytes, settings);
        });
      }
    });
    _controller = ScrollController(
      initialScrollOffset: ref.read(currentOctaveProvider).toDouble(),
    );
  }

  Future<void> play(int midi) async {
    synth!.reset();
    synth!.noteOn(
      channel: 0,
      key: midi,
      velocity: 120,
    );
    final current = _players[midi] ??= [];
    final player = RawSoundPlayer();
    await player.initialize(
      bufferSize: bufferSize,
      nChannels: nChannels,
      sampleRate: sampleRate,
      pcmType: RawSoundPCMType.PCMI16,
    );
    current.add(player);
    await player.play();
    final buffer = synth!.pcm(3);
    await player.feed(buffer);
    if (current.length > 1) {
      current.remove(player);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('The Pocket Piano'),
        actions: [
          Builder(builder: (context) {
            return IconButton(
              onPressed: () {
                showBottomSheet(
                  context: context,
                  builder: (context) =>
                      StatefulBuilder(builder: (context, setState) {
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
                                    ref.read(themeModeProvider.notifier).state =
                                        value.first;
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
                              ref.read(themeColorProvider.notifier).state =
                                  value;
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
                                  min: 80,
                                  max: 200,
                                  onChanged: (value) {
                                    setState(() {
                                      ref
                                          .read(keyWidthProvider.notifier)
                                          .state = value;
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
                                      ref
                                          .read(invertKeysProvider.notifier)
                                          .state = value;
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
                                      ref
                                          .read(colorRoleProvider.notifier)
                                          .state = value!;
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
                                      ref
                                          .read(keyLabelsProvider.notifier)
                                          .state = value!;
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
                                      ref.read(hapticsProvider.notifier).state =
                                          value;
                                    });
                                  },
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                height: 300,
                                color: Theme.of(context)
                                    .colorScheme
                                    .surfaceVariant,
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
                  }),
                );
              },
              icon: const Icon(Icons.settings),
            );
          }),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
      body: Consumer(builder: (context, ref, child) {
        final octave = ref.watch(currentOctaveProvider);
        return Column(
          children: [
            Flexible(
              flex: 1,
              child: PianoSlider(
                currentOctave: octave,
                octaveTapped: (value) {
                  ref.read(currentOctaveProvider.notifier).state = value;
                  _controller.animateTo(
                    value * (ref.read(keyWidthProvider) * 7),
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ),
            Flexible(
              flex: 8,
              child: ListView.builder(
                itemCount: 7,
                controller: _controller,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return PianoSection(
                    index: index,
                    onPlay: play,
                  );
                },
              ),
            ),
          ],
        );
      }),
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
