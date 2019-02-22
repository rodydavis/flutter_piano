import 'dart:io';

import 'package:flutter/material.dart';

import '../common/piano_key.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("The Pocket Piano",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 30.0)),
      ),
      body: ListView.builder(
        itemCount: 7,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          final int i = index * 12;
          return SafeArea(
            child: Stack(children: <Widget>[
              Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                PianoKey(accidental: false, midi: 24 + i),
                PianoKey(accidental: false, midi: 26 + i),
                PianoKey(accidental: false, midi: 28 + i),
                PianoKey(accidental: false, midi: 29 + i),
                PianoKey(accidental: false, midi: 31 + i),
                PianoKey(accidental: false, midi: 33 + i),
                PianoKey(accidental: false, midi: 35 + i),
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
                        Container(width: keyWidth * .5),
                        PianoKey(accidental: true, midi: 25 + i),
                        PianoKey(accidental: true, midi: 27 + i),
                        Container(width: keyWidth),
                        PianoKey(accidental: true, midi: 30 + i),
                        PianoKey(accidental: true, midi: 32 + i),
                        PianoKey(accidental: true, midi: 34 + i),
                        Container(width: keyWidth * .5),
                      ])),
            ]),
          );
        },
      ),
    );
  }
}
