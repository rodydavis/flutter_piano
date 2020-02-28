import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tonic/tonic.dart';

import '../../plugins/midi/midi.dart';
import '../../plugins/vibrate/vibrate.dart';

class PianoKey extends StatelessWidget {
  const PianoKey({
    @required this.keyWidth,
    this.midi,
    this.accidental,
    @required this.showLabels,
    @required this.labelsOnlyOctaves,
    @required this.isActive,
    this.feedback,
  });

  final bool accidental;
  final double keyWidth;
  final int midi;
  final bool showLabels;
  final bool labelsOnlyOctaves;
  final bool feedback;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    Color _color = accidental ? Colors.black : Colors.white;
    Color _textColor = accidental ? Colors.white : Colors.black;
    return InkWell(
        borderRadius: _borderRadius,
        highlightColor: Colors.grey,
        onTap: () {},
        onTapDown: (_) {
          MidiUtils.play(midi);
          if (feedback) {
            VibrateUtils.light();
          }
        },
        onTapCancel: () {
          MidiUtils.stop(midi);
        },
        child: IgnorePointer(
          child: isActive
              ? Container(color: Colors.red)
              : Builder(
                  builder: (_) {
                    final pitchName = Pitch.fromMidiNumber(midi).toString();
                    final pianoKey = Stack(
                      children: <Widget>[
                        Positioned.fill(
                          child: Semantics(
                              button: true,
                              hint: pitchName,
                              child: Material(
                                borderRadius: _borderRadius,
                                color: _color,
                              )),
                        ),
                        Positioned(
                            left: 0.0,
                            right: 0.0,
                            bottom: 20.0,
                            child: buildShowLabels(pitchName)
                                ? Text(pitchName,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: _textColor))
                                : Container()),
                      ],
                    );
                    if (accidental) {
                      return Container(
                          width: keyWidth,
                          margin: EdgeInsets.symmetric(horizontal: 2.0),
                          padding:
                              EdgeInsets.symmetric(horizontal: keyWidth * .1),
                          child: Material(
                              elevation: 6.0,
                              borderRadius: _borderRadius,
                              shadowColor: Color(0x802196F3),
                              child: pianoKey));
                    }
                    return Container(
                        width: keyWidth,
                        child: pianoKey,
                        margin: EdgeInsets.symmetric(horizontal: 2.0));
                  },
                ),
        ));
  }

  bool buildShowLabels(String pitchName) {
    if (showLabels) {
      if (labelsOnlyOctaves) {
        if (pitchName.replaceAll(RegExp("[0-9]"), "") == "C") return true;
        return false;
      }
      return true;
    }
    return false;
  }
}

const BorderRadiusGeometry _borderRadius = BorderRadius.only(
  bottomLeft: Radius.circular(10.0),
  bottomRight: Radius.circular(10.0),
);
