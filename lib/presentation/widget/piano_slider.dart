import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/source/settings.dart';
import 'color_role.dart';

class PianoSlider extends ConsumerWidget {
  const PianoSlider({
    super.key,
    required this.currentOctave,
    required this.octaveTapped,
  });

  final int currentOctave;
  final ValueChanged<int> octaveTapped;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final colorRole = ref.watch(colorRoleProvider);
    final invertKeys = ref.watch(invertKeysProvider);
    Color black = colors.color(colorRole);
    Color white = colors.onColor(colorRole);
    if (invertKeys) {
      final tmp = black;
      black = white;
      white = tmp;
    }
    return Stack(
      children: <Widget>[
        Container(
          color: Theme.of(context).colorScheme.surfaceVariant,
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            children: <Widget>[
              _buildSection(context, 0, black, white),
              _buildSection(context, 1, black, white),
              _buildSection(context, 2, black, white),
              _buildSection(context, 3, black, white),
              _buildSection(context, 4, black, white),
              _buildSection(context, 5, black, white),
              _buildSection(context, 6, black, white),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSection(
    BuildContext context,
    int octave,
    Color black,
    Color white,
  ) {
    final _keyWidth = MediaQuery.of(context).size.width / 49;
    return InkWell(
      onTap: () => octaveTapped(octave),
      child: Stack(
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildKey(context, false, black, white),
              _buildKey(context, false, black, white),
              _buildKey(context, false, black, white),
              _buildKey(context, false, black, white),
              _buildKey(context, false, black, white),
              _buildKey(context, false, black, white),
              _buildKey(context, false, black, white),
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
                  _buildKey(context, true, black, white),
                  _buildKey(context, true, black, white),
                  Container(width: _keyWidth),
                  _buildKey(context, true, black, white),
                  _buildKey(context, true, black, white),
                  _buildKey(context, true, black, white),
                  Container(width: _keyWidth * .5),
                ],
              )),
          Positioned(
            left: 0.0,
            right: 0.0,
            top: 0.0,
            bottom: 0.0,
            child: Container(
              color:
                  currentOctave != octave ? Colors.grey.withOpacity(0.7) : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKey(
    BuildContext context,
    bool accidental,
    Color black,
    Color white,
  ) {
    final keyWidth = MediaQuery.of(context).size.width / 49;
    if (accidental) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 1.0),
        width: keyWidth,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: _borderRadius,
            color: black,
          ),
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 1.0),
      width: keyWidth,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: _borderRadius,
          color: white,
        ),
      ),
    );
  }
}

const BorderRadiusGeometry _borderRadius = BorderRadius.only(
  bottomLeft: Radius.circular(5.0),
  bottomRight: Radius.circular(5.0),
);
