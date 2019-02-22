import 'package:flutter/material.dart';
import 'package:tonic/tonic.dart';
import 'package:flutter_midi/flutter_midi.dart';

const double keyWidth = 80.0;

class PianoKey extends StatefulWidget {
  const PianoKey({
    this.accidental = false,
    this.midi = 60,
  });

  final bool accidental;
  final int midi;

  @override
  _PianoKeyState createState() => _PianoKeyState();
}

class _PianoKeyState extends State<PianoKey> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final String pitchName = Pitch.fromMidiNumber(widget.midi).toString();
    final Widget pianoKey = GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: () {
          FlutterMidi.playMidiNote(midi: widget.midi);
          setState(() => _pressed = false);
        },
        child: Semantics(
            button: true,
            hint: pitchName,
            child: Stack(
              children: <Widget>[
                Container(
                    width: keyWidth,
                    margin: EdgeInsets.symmetric(horizontal: 2.0),
                    decoration: BoxDecoration(
                      color: widget.accidental
                          ? (_pressed ? Colors.black26 : Colors.black)
                          : (_pressed ? Colors.grey : Colors.white),
                      borderRadius: borderRadius,
                    )),
                Positioned(
                    left: 0.0,
                    right: 0.0,
                    bottom: 20.0,
                    child: Text(pitchName,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: !widget.accidental
                                ? Colors.black
                                : Colors.white))),
              ],
            )));
    if (widget.accidental) {
      return Container(
        width: keyWidth,
        margin: EdgeInsets.symmetric(horizontal: 2.0),
        padding: EdgeInsets.symmetric(horizontal: keyWidth * .1),
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
  bottomLeft: Radius.circular(10.0),
  bottomRight: Radius.circular(10.0),
);
