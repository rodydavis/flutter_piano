import 'package:flutter/material.dart';

import 'octave.dart';

class PianoKeys extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: 11,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return SafeArea(child: PianoOctave());
        },
      ),
    );
  }
}
