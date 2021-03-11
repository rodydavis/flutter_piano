import 'package:flutter/material.dart';
import 'package:flutter_piano/ui/theme.dart';

import 'piano_octave.dart';
import 'piano_section.dart';
import 'piano_slider.dart';

class PianoView extends StatefulWidget {
  const PianoView({
    this.showLabels,
    this.keyWidth,
    @required this.labelsOnlyOctaves,
    this.disableScroll,
    this.feedback,
  });

  final double keyWidth;
  final bool showLabels;
  final bool labelsOnlyOctaves;
  final bool disableScroll;
  final bool feedback;

  @override
  _PianoViewState createState() => _PianoViewState();
}

class _PianoViewState extends State<PianoView> {
  int _currentOctave = 3;
  ScrollController _controller;

  @override
  void initState() {
    _controller = ScrollController(initialScrollOffset: currentOffset);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      children: <Widget>[
        Flexible(
          flex: 1,
          child: Container(
            child: PianoSlider(
              theme: ThemeUtils(context),
              keyWidth: widget.keyWidth,
              currentOctave: _currentOctave,
              octaveTapped: (int octave) {
                setState(() {
                  _currentOctave = octave;
                });
                _controller.jumpTo(currentOffset);
              },
            ),
          ),
        ),
        Flexible(
          flex: 8,
          child: PianoSection(
            controller: _controller,
            disableScroll: widget.disableScroll,
            keyWidth: widget.keyWidth,
            showLabels: widget.showLabels,
            labelsOnlyOctaves: widget.labelsOnlyOctaves,
            feedback: widget.feedback,
          ),
        ),
      ],
    );
  }

  double get currentOffset => widget.keyWidth * (7 * _currentOctave);
}
