import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_piano/ui/common/piano_octave.dart';
import 'package:flutter_piano/ui/common/piano_slider.dart';

class PianoView extends StatefulWidget {
  const PianoView({
    this.showLabels,
    this.keyWidth,
    @required this.labelsOnlyOctaves,
    this.disableScroll,
  });

  final double keyWidth;
  final bool showLabels;
  final bool labelsOnlyOctaves;
  final bool disableScroll;

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
          child: ListView.builder(
            itemCount: 7,
            physics:
                widget.disableScroll ? NeverScrollableScrollPhysics() : null,
            controller: _controller,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return PianoOctave(
                octave: index * 12,
                keyWidth: widget.keyWidth,
                showLabels: widget.showLabels,
                labelsOnlyOctaves: widget.labelsOnlyOctaves,
              );
            },
          ),
        ),
      ],
    );
  }

  double get currentOffset => widget.keyWidth * (7 * _currentOctave);
}
