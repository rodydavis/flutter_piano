import 'package:flutter/material.dart';

import 'piano_key.dart';

class PianoOctave extends StatelessWidget {
  const PianoOctave({
    this.keyWidth,
    this.octave,
    @required this.showLabels,
    @required this.labelsOnlyOctaves,
  });

  final double keyWidth;
  final int octave;
  final bool showLabels;
  final bool labelsOnlyOctaves;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(children: <Widget>[
        Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
          PianoKey(
            midi: 24 + octave,
            accidental: false,
            keyWidth: keyWidth,
            showLabels: showLabels,
            labelsOnlyOctaves: labelsOnlyOctaves,
          ),
          PianoKey(
            midi: 26 + octave,
            accidental: false,
            keyWidth: keyWidth,
            showLabels: showLabels,
            labelsOnlyOctaves: labelsOnlyOctaves,
          ),
          PianoKey(
            midi: 28 + octave,
            accidental: false,
            keyWidth: keyWidth,
            showLabels: showLabels,
            labelsOnlyOctaves: labelsOnlyOctaves,
          ),
          PianoKey(
            midi: 29 + octave,
            accidental: false,
            keyWidth: keyWidth,
            showLabels: showLabels,
            labelsOnlyOctaves: labelsOnlyOctaves,
          ),
          PianoKey(
            midi: 31 + octave,
            accidental: false,
            keyWidth: keyWidth,
            showLabels: showLabels,
            labelsOnlyOctaves: labelsOnlyOctaves,
          ),
          PianoKey(
            midi: 33 + octave,
            accidental: false,
            keyWidth: keyWidth,
            showLabels: showLabels,
            labelsOnlyOctaves: labelsOnlyOctaves,
          ),
          PianoKey(
            midi: 35 + octave,
            accidental: false,
            keyWidth: keyWidth,
            showLabels: showLabels,
            labelsOnlyOctaves: labelsOnlyOctaves,
          ),
        ]),
        Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 115,
            top: 0.0,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(width: keyWidth * .5),
                  PianoKey(
                    midi: 25 + octave,
                    accidental: true,
                    keyWidth: keyWidth,
                    showLabels: showLabels,
                    labelsOnlyOctaves: labelsOnlyOctaves,
                  ),
                  PianoKey(
                    midi: 27 + octave,
                    accidental: true,
                    keyWidth: keyWidth,
                    showLabels: showLabels,
                    labelsOnlyOctaves: labelsOnlyOctaves,
                  ),
                  Container(width: keyWidth),
                  PianoKey(
                    midi: 30 + octave,
                    accidental: true,
                    keyWidth: keyWidth,
                    showLabels: showLabels,
                    labelsOnlyOctaves: labelsOnlyOctaves,
                  ),
                  PianoKey(
                    midi: 32 + octave,
                    accidental: true,
                    keyWidth: keyWidth,
                    showLabels: showLabels,
                    labelsOnlyOctaves: labelsOnlyOctaves,
                  ),
                  PianoKey(
                    midi: 34 + octave,
                    accidental: true,
                    keyWidth: keyWidth,
                    showLabels: showLabels,
                    labelsOnlyOctaves: labelsOnlyOctaves,
                  ),
                  Container(width: keyWidth * .5),
                ])),
      ]),
    );
  }
}
