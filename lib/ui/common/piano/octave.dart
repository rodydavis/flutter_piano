import 'package:flutter/material.dart';
import 'package:flutter_piano/data/models/app_model.dart';
import 'package:scoped_model/scoped_model.dart';

import '../piano_key.dart';

class PianoOctave extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _app = ScopedModel.of<AppModel>(context, rebuildOnChange: true);

    return Container(
      child: Stack(
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              PianoKey(accidental: false),
              PianoKey(accidental: false),
              PianoKey(accidental: false),
              PianoKey(accidental: false),
              PianoKey(accidental: false),
              PianoKey(accidental: false),
              PianoKey(accidental: false),
            ],
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 100.0,
            top: 0.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(width: _app.keyWidth * .5),
                PianoKey(accidental: true),
                PianoKey(accidental: true),
                Container(width: _app.keyWidth),
                PianoKey(accidental: true),
                PianoKey(accidental: true),
                PianoKey(accidental: true),
                Container(width: _app.keyWidth * .5),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
