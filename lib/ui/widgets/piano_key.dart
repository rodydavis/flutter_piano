import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../src/services/settings.dart';
import '../../src/models/settings_models.dart';

class PianoKey extends HookWidget {
  const PianoKey({
    super.key,
    required this.accidental,
    required this.midi,
    required this.onPlay,
    this.onStop,
    required this.settings,
  });

  final bool accidental;
  final int midi;
  final VoidCallback onPlay;
  final VoidCallback? onStop;
  final SettingsService settings;

  static const BorderRadius borderRadius = BorderRadius.only(
    bottomLeft: Radius.circular(8),
    bottomRight: Radius.circular(8),
  );

  @override
  Widget build(BuildContext context) {
    final labels = useListenableSelector(settings.keyLabels, () => settings.keyLabels.value);
    final keyWidth = useListenableSelector(settings.keyWidth, () => settings.keyWidth.value);
    final invertKeys = useListenableSelector(settings.invertKeys, () => settings.invertKeys.value);
    final haptics = useListenableSelector(settings.haptics, () => settings.haptics.value);

    final isPressed = useState(false);
    final pitchName = midi.pitchName(labels);
    
    final shadTheme = ShadTheme.of(context);
    final shadColors = shadTheme.colorScheme;
    
    Color black = shadColors.foreground;
    Color white = shadColors.background;
    
    if (invertKeys) {
      final tmp = black;
      black = white;
      white = tmp;
    }
    
    final bgColor = accidental ? black : white;
    final fgColor = !accidental ? black : white;

    return GestureDetector(
      onTapDown: (_) {
        onPlay();
        isPressed.value = true;
        if (haptics) {
          HapticFeedback.mediumImpact();
        }
      },
      onTapUp: (_) {
        isPressed.value = false;
        onStop?.call();
      },
      onTapCancel: () {
        isPressed.value = false;
        onStop?.call();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: keyWidth,
        margin: const EdgeInsets.symmetric(horizontal: 1.0),
        decoration: BoxDecoration(
          color: isPressed.value ? bgColor.withValues(alpha: 0.8) : bgColor,
          borderRadius: borderRadius,
          border: Border.all(
            color: shadColors.border,
            width: accidental ? 0 : 0.5,
          ),
          boxShadow: [
            if (!isPressed.value)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 2,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Stack(
          children: <Widget>[
            Semantics(
              button: true,
              hint: pitchName,
              child: const SizedBox.expand(),
            ),
            Positioned(
              left: 0.0,
              right: 0.0,
              bottom: 12.0,
              child: pitchName.isNotEmpty
                  ? Text(
                      pitchName,
                      textAlign: TextAlign.center,
                      style: shadTheme.textTheme.small.copyWith(
                        color: fgColor,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
