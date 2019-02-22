import 'package:flutter/material.dart';
import 'package:tonic/tonic.dart';
import 'package:flutter_midi/flutter_midi.dart';

class PianoKey extends StatefulWidget {
  const PianoKey(
      {this.accidental = false, this.midi = 60, this.keyWidth = 80.0});

  final bool accidental;
  final int midi;
  final double keyWidth;

  @override
  _PianoKeyState createState() => _PianoKeyState();
}

class _PianoKeyState extends State<PianoKey> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final pitchName = Pitch.fromMidiNumber(widget.midi).toString();
    final pianoKey = GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: () {
          FlutterMidi.playMidiNote(midi: widget.midi);
          setState(() => _pressed = false);
        },
        child: Semantics(
            button: true,
            hint: pitchName,
            child: Stack(children: <Widget>[
              Container(
                  width: widget.keyWidth,
                  margin: EdgeInsets.symmetric(horizontal: 2.0),
                  decoration: BoxDecoration(
                      color: widget.accidental
                          ? (_pressed ? Colors.black26 : Colors.black)
                          : (_pressed ? Colors.grey : Colors.white),
                      borderRadius: borderRadius)),
            ])));
    if (widget.accidental) {
      return Container(
        width: widget.keyWidth,
        margin: EdgeInsets.symmetric(horizontal: 2.0),
        padding: EdgeInsets.symmetric(horizontal: widget.keyWidth * .1),
        child: Material(
            elevation: _pressed ? 2.0 : 6.0,
            borderRadius: borderRadius,
            shadowColor: Color(0x802196F3),
            child: pianoKey),
      );
    }
    return pianoKey;
  }
}

const BorderRadiusGeometry borderRadius = BorderRadius.only(
    bottomLeft: Radius.circular(10.0), bottomRight: Radius.circular(10.0));
