import 'package:flutter/material.dart';

import 'piano_octave.dart';

const double _kDefaultKeyWidth = 40 + (80 * (0.5));

class PianoSection extends StatelessWidget {
  const PianoSection({
    Key key,
    this.controller,
    this.disableScroll = false,
    this.showLabels = true,
    this.labelsOnlyOctaves = false,
    this.feedback = false,
    this.keyWidth = _kDefaultKeyWidth,
  }) : super(key: key);

  final ScrollController controller;
  final bool disableScroll, labelsOnlyOctaves, showLabels, feedback;
  final double keyWidth;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scrollbar(
        child: ListView.builder(
          itemCount: 7,
          physics: disableScroll ? NeverScrollableScrollPhysics() : null,
          controller: controller,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return PianoOctave(
              octave: index * 12,
              keyWidth: keyWidth,
              showLabels: showLabels,
              labelsOnlyOctaves: labelsOnlyOctaves,
              feedback: feedback,
            );
          },
        ),
      ),
    );
  }
}
