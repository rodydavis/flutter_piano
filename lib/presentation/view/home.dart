// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_piano/data/source/settings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/source/audio_stream/audio_stream.dart';
import '../../data/source/midi_player/midi_player.dart';
import '../widget/piano_view.dart';
import '../widget/settings.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  // TODO: flutter_midi_command
  final _focusNode = FocusNode();
  final audioStream = AudioStream();
  int octaveOffset = 0;
  int velocity = 127;
  int nOctaves = 7;

  final midiPlayer = MidiPlayer(AudioStream());

  @override
  void initState() {
    super.initState();
    midiPlayer.init().then((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> play(int midi) => midiPlayer.play(midi, velocity);

  KeyEventResult onKey(ScaffoldMessengerState messenger, RawKeyEvent event) {
    KeyEventResult result = KeyEventResult.ignored;
    if (event is RawKeyDownEvent) {
      // Use hardware keyboard for midi notes
      final key = event.logicalKey;
      final midiNotes = {
        LogicalKeyboardKey.keyA: 60 + (octaveOffset * 12),
        LogicalKeyboardKey.keyW: 61 + (octaveOffset * 12),
        LogicalKeyboardKey.keyS: 62 + (octaveOffset * 12),
        LogicalKeyboardKey.keyE: 63 + (octaveOffset * 12),
        LogicalKeyboardKey.keyD: 64 + (octaveOffset * 12),
        LogicalKeyboardKey.keyF: 65 + (octaveOffset * 12),
        LogicalKeyboardKey.keyT: 66 + (octaveOffset * 12),
        LogicalKeyboardKey.keyG: 67 + (octaveOffset * 12),
        LogicalKeyboardKey.keyY: 68 + (octaveOffset * 12),
        LogicalKeyboardKey.keyH: 69 + (octaveOffset * 12),
        LogicalKeyboardKey.keyU: 70 + (octaveOffset * 12),
        LogicalKeyboardKey.keyJ: 71 + (octaveOffset * 12),
        LogicalKeyboardKey.keyK: 72 + (octaveOffset * 12),
        LogicalKeyboardKey.keyO: 73 + (octaveOffset * 12),
        LogicalKeyboardKey.keyL: 74 + (octaveOffset * 12),
        LogicalKeyboardKey.keyP: 75 + (octaveOffset * 12),
        LogicalKeyboardKey.semicolon: 76 + (octaveOffset * 12),
        LogicalKeyboardKey.quoteSingle: 77 + (octaveOffset * 12),
      };
      if (midiNotes.containsKey(key)) {
        final midi = midiNotes[key]!;
        play(midi);
        result = KeyEventResult.handled;
      }
      final octaveAdjustment = {
        LogicalKeyboardKey.keyZ: -1,
        LogicalKeyboardKey.keyX: 1,
      };
      if (octaveAdjustment.containsKey(key)) {
        final adjustment = octaveAdjustment[key]!;
        setState(() {
          octaveOffset = (octaveOffset + adjustment).clamp(
            -nOctaves + 2,
            nOctaves - 2,
          );
          result = KeyEventResult.handled;
        });
      }
      final velocityAdjustment = {
        LogicalKeyboardKey.keyC: -1,
        LogicalKeyboardKey.keyV: 1,
      };
      if (velocityAdjustment.containsKey(key)) {
        final adjustment = velocityAdjustment[key]!;
        setState(() {
          velocity = (velocity + adjustment).clamp(0, 127);
          result = KeyEventResult.handled;
        });
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final splitKeyboard = ref.watch(splitKeyboardProvider);
    return LayoutBuilder(builder: (context, dimens) {
      final canSplit = dimens.maxHeight > 600;
      return Scaffold(
        appBar: AppBar(
          title: const Text('The Pocket Piano'),
          actions: [
            if (canSplit) ...[
              IconButton(
                onPressed: () {
                  ref.read(splitKeyboardProvider.notifier).state =
                      !splitKeyboard;
                },
                icon:
                    Icon(!splitKeyboard ? Icons.splitscreen : Icons.fullscreen),
                tooltip: 'Split keyboard',
              ),
            ],
            Builder(builder: (context) {
              return IconButton(
                onPressed: () {
                  showBottomSheet(
                    context: context,
                    builder: (context) => const Settings(),
                  );
                },
                icon: const Icon(Icons.settings),
              );
            }),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.outlineVariant,
        body: Focus(
          focusNode: _focusNode,
          autofocus: true,
          onKey: (_, event) => onKey(
            ScaffoldMessenger.of(context),
            event,
          ),
          child: Builder(builder: (context) {
            if (canSplit && splitKeyboard) {
              return Column(
                children: [
                  Flexible(
                    child: PianoView(
                      octaves: nOctaves,
                      onPlay: play,
                    ),
                  ),
                  Flexible(
                    child: PianoView(
                      octaves: nOctaves,
                      onPlay: play,
                    ),
                  ),
                ],
              );
            }
            return PianoView(
              octaves: nOctaves,
              onPlay: play,
            );
          }),
        ),
      );
    });
  }
}
