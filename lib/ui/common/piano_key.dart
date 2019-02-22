import 'package:flutter/material.dart';
import 'package:flutter_midi/flutter_midi.dart';

const double keyWidth = 80.0;

class PianoKey extends StatelessWidget {
  const PianoKey({
    this.accidental = false,
    this.midi = 60,
  });

  final bool accidental;
  final int midi;

  @override
  Widget build(BuildContext context) {
    if (accidental) {
      return Container(
        width: keyWidth,
        margin: EdgeInsets.symmetric(horizontal: 2.0),
        padding: EdgeInsets.symmetric(horizontal: keyWidth * .1),
        child: Material(
          elevation: 6.0,
          borderRadius: BorderRadius.circular(10.0),
          shadowColor: Color(0x802196F3),
          child: InkWell(
            onTap: () => FlutterMidi.playMidiNote(midi: midi),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return InkWell(
      onTap: () => FlutterMidi.playMidiNote(midi: midi),
      child: Container(
        width: keyWidth,
        margin: EdgeInsets.symmetric(horizontal: 2.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0),
          ),
        ),
      ),
    );
  }
}
