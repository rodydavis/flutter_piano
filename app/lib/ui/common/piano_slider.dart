import 'package:flutter/material.dart';

class PianoSlider extends StatelessWidget {
  const PianoSlider({
    this.keyWidth,
    this.currentOctave,
    this.octaveTapped,
  });

  final double keyWidth;
  final int currentOctave;
  final ValueChanged<int> octaveTapped;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(bottom: 8.0),
          child: Row(
            children: <Widget>[
              _buildSection(context, 0),
              _buildSection(context, 1),
              _buildSection(context, 2),
              _buildSection(context, 3),
              _buildSection(context, 4),
              _buildSection(context, 5),
              _buildSection(context, 6),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSection(BuildContext context, int octave) {
    final _keyWidth = MediaQuery.of(context).size.width / 49;
    return InkWell(
      onTap: () => octaveTapped(octave),
      child: Stack(
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildKey(context, false),
              _buildKey(context, false),
              _buildKey(context, false),
              _buildKey(context, false),
              _buildKey(context, false),
              _buildKey(context, false),
              _buildKey(context, false),
            ],
          ),
          Positioned(
              left: 0.0,
              right: 0.0,
              bottom: 15.0,
              top: 0.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(width: _keyWidth * .5),
                  _buildKey(context, true),
                  _buildKey(context, true),
                  Container(width: _keyWidth),
                  _buildKey(context, true),
                  _buildKey(context, true),
                  _buildKey(context, true),
                  Container(width: _keyWidth * .5),
                ],
              )),
          Positioned(
            left: 0.0,
            right: 0.0,
            top: 0.0,
            bottom: 0.0,
            child: Container(
              color: currentOctave != octave
                  ? Color.fromARGB(100, 126, 126, 126)
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKey(BuildContext context, bool accidental) {
    final _keyWidth = MediaQuery.of(context).size.width / 49;
    if (accidental) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 1.0),
        width: _keyWidth,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: _borderRadius,
            color: Colors.black,
          ),
        ),
      );
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 1.0),
      width: _keyWidth,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: _borderRadius,
          color: Colors.white,
        ),
      ),
    );
  }
}

const BorderRadiusGeometry _borderRadius = BorderRadius.only(
  bottomLeft: Radius.circular(5.0),
  bottomRight: Radius.circular(5.0),
);
