import 'package:app_review/app_review.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../src/services/settings.dart';
import '../../src/services/injection.dart';
import '../widgets/locale.dart';
import '../widgets/piano_view.dart';
import '../hooks/use_octave.dart';
import '../hooks/use_velocity.dart';
import '../hooks/use_sustain.dart';
import '../hooks/use_player.dart';
import '../hooks/use_piano_keyboard.dart';
import '../hooks/use_app_version_check.dart';
import '../hooks/use_chord_recognition.dart';

class Home extends HookWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsService = getIt<SettingsService>();
    final splitKeyboard = useListenableSelector(
      settingsService.splitKeyboard,
      () => settingsService.splitKeyboard.value,
    );

    final focusNode = useFocusNode();
    final octave = useOctave();
    final velocity = useVelocity();
    final sustain = useSustain();
    final player = usePlayer(sustain: sustain.value);
    final chord = useChordRecognition();

    useAppVersionCheck(context);

    final onKeyEvent = usePianoKeyboard(
      octave: octave,
      velocity: velocity,
      sustain: sustain,
      player: player,
      onNoteOn: chord.onNoteOn,
      onNoteOff: chord.onNoteOff,
    );

    const nOctaves = 7;

    final onPlay = useCallback((int midi) {
      chord.onNoteOn(midi);
      player.play(midi);
    }, [chord, player]);

    final onStop = useCallback((int midi) {
      chord.onNoteOff(midi);
    }, [chord]);

    final shadTheme = ShadTheme.of(context);

    return LayoutBuilder(builder: (context, dimens) {
      final canSplit = dimens.maxHeight > 600;
      final showControls = dimens.maxWidth > 550;
      final isLandscape = dimens.maxWidth > dimens.maxHeight;

      return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Text(context.locale.title),
              if (isLandscape && chord.chord.isNotEmpty) ...[
                const SizedBox(width: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: shadTheme.colorScheme.accent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    chord.chord,
                    style: shadTheme.textTheme.small.copyWith(
                      color: shadTheme.colorScheme.accentForeground,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
          actions: [
            if (showControls) ...[
              ShadIconButton(
                onPressed: () => octave.adjust(-1),
                icon: const Icon(LucideIcons.minus),
              ),
              const SizedBox(width: 4),
              ShadIconButton.outline(
                onPressed: octave.reset,
                icon: Text(
                  octave.offset.toString(),
                ),
              ),
              const SizedBox(width: 4),
              ShadIconButton(
                onPressed: () => octave.adjust(1),
                icon: const Icon(LucideIcons.plus),
              ),
              const SizedBox(width: 10),
            ],
            Text('${context.locale.sustain}:'),
            ShadSwitch(
              value: sustain.value,
              onChanged: sustain.setSustain,
            ),
            if (canSplit) ...[
              ShadIconButton.ghost(
                onPressed: () async {
                  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
                    AppReview.requestReview();
                  }
                  settingsService.splitKeyboard.value = !splitKeyboard;
                },
                icon: Icon(!splitKeyboard
                    ? LucideIcons.layoutPanelTop
                    : LucideIcons.maximize),
              ),
            ],
            ShadIconButton.ghost(
              onPressed: () => context.push('/settings'),
              icon: const Icon(LucideIcons.settings),
            ),
          ],
        ),
        backgroundColor: ShadTheme.of(context).colorScheme.background,
        body: Focus(
          focusNode: focusNode,
          autofocus: true,
          onKeyEvent: onKeyEvent,
          child: Column(
            children: [
              Expanded(
                child: Builder(builder: (context) {
                  if (canSplit && splitKeyboard) {
                    return Column(
                      children: [
                        Flexible(
                          child: PianoView(
                            octaves: nOctaves,
                            onPlay: onPlay,
                            onStop: onStop,
                            settings: settingsService,
                          ),
                        ),
                        Flexible(
                          child: PianoView(
                            octaves: nOctaves,
                            onPlay: onPlay,
                            onStop: onStop,
                            settings: settingsService,
                          ),
                        ),
                      ],
                    );
                  }
                  return PianoView(
                    octaves: nOctaves,
                    onPlay: onPlay,
                    onStop: onStop,
                    settings: settingsService,
                  );
                }),
              ),
            ],
          ),
        ),
      );
    });
  }
}
