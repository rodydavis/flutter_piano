import 'package:flutter/material.dart';

import '../../plugins/midi/midi.dart';
import '../../plugins/vibrate/vibrate.dart';
import 'piano_octave.dart';

const double _kDefaultKeyWidth = 40 + (80 * (0.5));
const String kDefaultSoundFontPath = 'assets/sounds/Piano.sf2';

class PianoSection extends StatefulWidget {
  const PianoSection({
    Key key,
    this.controller,
    this.disableScroll = false,
    this.showLabels = true,
    this.labelsOnlyOctaves = false,
    this.feedback = false,
    this.keyWidth = _kDefaultKeyWidth,
    this.soundFontPath = kDefaultSoundFontPath,
  }) : super(key: key);

  final ScrollController controller;
  final bool disableScroll, labelsOnlyOctaves, showLabels, feedback;
  final double keyWidth;
  final String soundFontPath;

  @override
  _PianoSectionState createState() => _PianoSectionState();
}

class _PianoSectionState extends State<PianoSection>
    with WidgetsBindingObserver {
  bool canVibrate = false;
  @override
  initState() {
    _loadSoundFont();
    super.initState();
  }

  void _loadSoundFont() async {
    MidiUtils.unmute();
    initMidiUtils(widget.soundFontPath);
    if (widget.feedback) {
      VibrateUtils.canVibrate.then((vibrate) {
        if (mounted)
          setState(() {
            canVibrate = vibrate;
          });
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("State: $state");
    _loadSoundFont();
  }

  @override
  Widget build(BuildContext context) {
    final vibrate = canVibrate && widget.feedback;
    return Material(
      color: Theme.of(context).backgroundColor,
      child: Scrollbar(
        child: ListView.builder(
          itemCount: 7,
          physics: widget.disableScroll ? NeverScrollableScrollPhysics() : null,
          controller: widget.controller,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return PianoOctave(
              octave: index * 12,
              keyWidth: widget.keyWidth,
              showLabels: widget.showLabels,
              labelsOnlyOctaves: widget.labelsOnlyOctaves,
              feedback: vibrate,
            );
          },
        ),
      ),
    );
  }
}
