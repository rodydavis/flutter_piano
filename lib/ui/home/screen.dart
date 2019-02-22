import 'package:flutter/material.dart';

import '../common/piano_key.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Flutter Piano"),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: 11,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            return SafeArea(
              child: Container(
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
                      bottom: MediaQuery.of(context).size.height * .35,
                      top: 0.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(width: keyWidth * .5),
                          PianoKey(accidental: true),
                          PianoKey(accidental: true),
                          Container(width: keyWidth),
                          PianoKey(accidental: true),
                          PianoKey(accidental: true),
                          PianoKey(accidental: true),
                          Container(width: keyWidth * .5),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
