// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/source/settings.dart';
import 'piano_key.dart';

class PianoSection extends ConsumerWidget {
  const PianoSection({
    Key? key,
    required this.index,
    required this.onPlay,
  }) : super(key: key);

  final int index;
  final ValueChanged<int> onPlay;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final keyWidth = ref.watch(keyWidthProvider);
    final int i = index * 12;
    return SafeArea(
      child: Stack(
        children: <Widget>[
          Row(mainAxisSize: MainAxisSize.min, children: [
            _buildKey(24 + i, false),
            _buildKey(26 + i, false),
            _buildKey(28 + i, false),
            _buildKey(29 + i, false),
            _buildKey(31 + i, false),
            _buildKey(33 + i, false),
            _buildKey(35 + i, false),
          ]),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(width: keyWidth * .5),
                _buildKey(25 + i, true),
                _buildKey(27 + i, true),
                Container(width: keyWidth),
                _buildKey(30 + i, true),
                _buildKey(32 + i, true),
                _buildKey(34 + i, true),
                Container(width: keyWidth * .5),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKey(int midi, bool accidental) {
    return PianoKey(
      midi: midi,
      accidental: accidental,
      onPlay: () => onPlay(midi),
    );
  }
}
