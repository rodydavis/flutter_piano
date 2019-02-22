import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_midi/flutter_midi.dart';

import 'ui/common/piano_key.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  initState() {
    FlutterMidi.unmute();
    rootBundle.load("assets/sounds/Piano.SF2").then((sf2) {
      FlutterMidi.prepare(sf2: sf2, name: "Piano.SF2");
    });
    super.initState();
  }

  double _keyWidth = 80;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Pocket Piano',
      theme: ThemeData.dark(),
      home: Scaffold(
          appBar: AppBar(
            title: Text("The Pocket Piano",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 30.0)),
          ),
          body: GestureDetector(
            onScaleUpdate: (ScaleUpdateDetails value) =>
                setState(() => _keyWidth = 80 + (80 * value.scale)),
            child: ListView.builder(
              itemCount: 7,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                final int i = index * 12;
                return SafeArea(
                  child: Stack(children: <Widget>[
                    Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                      PianoKey(
                          accidental: false, midi: 24 + i, keyWidth: _keyWidth),
                      PianoKey(
                          accidental: false, midi: 26 + i, keyWidth: _keyWidth),
                      PianoKey(
                          accidental: false, midi: 28 + i, keyWidth: _keyWidth),
                      PianoKey(
                          accidental: false, midi: 29 + i, keyWidth: _keyWidth),
                      PianoKey(
                          accidental: false, midi: 31 + i, keyWidth: _keyWidth),
                      PianoKey(
                          accidental: false, midi: 33 + i, keyWidth: _keyWidth),
                      PianoKey(
                          accidental: false, midi: 35 + i, keyWidth: _keyWidth),
                    ]),
                    Positioned(
                        left: 0.0,
                        right: 0.0,
                        bottom: 100,
                        top: 0.0,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Container(width: 80 * .5),
                              PianoKey(
                                  accidental: true,
                                  midi: 25 + i,
                                  keyWidth: _keyWidth),
                              PianoKey(
                                  accidental: true,
                                  midi: 27 + i,
                                  keyWidth: _keyWidth),
                              Container(width: 80),
                              PianoKey(
                                  accidental: true,
                                  midi: 30 + i,
                                  keyWidth: _keyWidth),
                              PianoKey(
                                  accidental: true,
                                  midi: 32 + i,
                                  keyWidth: _keyWidth),
                              PianoKey(
                                  accidental: true,
                                  midi: 34 + i,
                                  keyWidth: _keyWidth),
                              Container(width: 80 * .5),
                            ])),
                  ]),
                );
              },
            ),
          )),
    );
  }
}
