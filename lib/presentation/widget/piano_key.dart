import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/source/settings.dart';
import 'color_role.dart';

class PianoKey extends ConsumerStatefulWidget {
  const PianoKey({
    super.key,
    required this.accidental,
    required this.midi,
    required this.onPlay,
  });

  final bool accidental;
  final int midi;
  final VoidCallback onPlay;

  @override
  ConsumerState<PianoKey> createState() => _PianoKeyState();
}

class _PianoKeyState extends ConsumerState<PianoKey>
    with SingleTickerProviderStateMixin {
  static const BorderRadius borderRadius = BorderRadius.only(
    bottomLeft: Radius.circular(10),
    bottomRight: Radius.circular(10),
  );

  late AnimationController _animationController;
  late Animation<double> _animationTween;
  late Animation<double> _opacityTween;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 10),
      vsync: this,
    );
    _animationTween = Tween(begin: 6.0, end: 3.0).animate(_animationController);
    _opacityTween = Tween(begin: 1.0, end: 0.8).animate(_animationController);
    _animationController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final labels = ref.watch(keyLabelsProvider);
    final keyWidth = ref.watch(keyWidthProvider);
    final invertKeys = ref.watch(invertKeysProvider);
    final colorRole = ref.watch(colorRoleProvider);
    final haptics = ref.watch(hapticsProvider);
    final pitchName = widget.midi.pitchName(labels);
    final colors = Theme.of(context).colorScheme;
    Color black = colors.color(colorRole);
    Color white = colors.onColor(colorRole);
    if (invertKeys) {
      final tmp = black;
      black = white;
      white = tmp;
    }
    final bgColor = widget.accidental ? black : white;
    final fgColor = !widget.accidental ? black : white;
    final pianoKey = Stack(
      children: <Widget>[
        Semantics(
          button: true,
          hint: pitchName,
          child: const SizedBox.expand(),
        ),
        Positioned(
          left: 0.0,
          right: 0.0,
          bottom: 20.0,
          child: pitchName.isNotEmpty
              ? Text(
                  pitchName,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: fgColor),
                )
              : Container(),
        ),
      ],
    );
    Widget wrap(Widget child) {
      return InkWell(
        borderRadius: borderRadius,
        onTapDown: (_) {
          widget.onPlay();
          _animationController.forward();
          if (haptics) {
            HapticFeedback.mediumImpact();
          }
        },
        onTapUp: (_) {
          _animationController.reverse();
        },
        onTapCancel: () {
          _animationController.reverse();
        },
        child: child,
      );
    }

    if (widget.accidental) {
      return wrap(Container(
        width: keyWidth,
        margin: const EdgeInsets.symmetric(horizontal: 2.0),
        padding: EdgeInsets.symmetric(horizontal: keyWidth * .1),
        child: Material(
          elevation: _animationTween.value,
          borderRadius: borderRadius,
          color: bgColor.withOpacity(_opacityTween.value),
          child: pianoKey,
        ),
      ));
    } else {
      return wrap(Container(
        width: keyWidth,
        margin: const EdgeInsets.symmetric(horizontal: 2.0),
        child: Material(
          elevation: _animationTween.value,
          borderRadius: borderRadius,
          color: bgColor.withOpacity(_opacityTween.value),
          child: pianoKey,
        ),
      ));
    }
  }
}

extension on int {
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

enum PitchLabels {
  none,
  sharps,
  flats,
  both,
  midi,
}
