import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'piano_octave.dart';
import 'piano_slider.dart';

class PianoView extends StatefulWidget {
  const PianoView({
    this.showLabels,
    this.keyWidth,
    @required this.labelsOnlyOctaves,
    @required this.listenables,
    this.disableScroll,
    this.feedback,
  });

  final double keyWidth;
  final bool showLabels;
  final bool labelsOnlyOctaves;
  final bool disableScroll;
  final bool feedback;
  final Stream<List<int>> listenables;

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
  void didUpdateWidget(PianoView oldWidget) {
    if (oldWidget.listenables != widget.listenables) {
      if (mounted) setState(() {});
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      children: <Widget>[
        Flexible(
          flex: 1,
          child: StreamBuilder<List<int>>(
              initialData: [],
              stream: widget.listenables,
              builder: (context, snapshot) {
                return PianoSlider(
                  activeNotes: snapshot.data,
                  keyWidth: widget.keyWidth,
                  currentOctave: _currentOctave,
                  octaveTapped: (int octave) {
                    setState(() {
                      _currentOctave = octave;
                    });
                    _controller.jumpTo(currentOffset);
                  },
                );
              }),
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
                feedback: widget.feedback,
                listenables: widget.listenables,
              );
            },
          ),
        ),
      ],
    );
  }

  double get currentOffset => widget.keyWidth * (7 * _currentOctave);
}
