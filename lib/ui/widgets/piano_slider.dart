import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../src/services/settings.dart';

class PianoSlider extends HookWidget {
  const PianoSlider({
    super.key,
    required this.viewport,
    required this.offset,
    required this.offsetChanged,
    required this.settings,
  });

  final double offset;
  final double viewport;
  final ValueChanged<double> offsetChanged;
  final SettingsService settings;

  @override
  Widget build(BuildContext context) {
    final shadTheme = ShadTheme.of(context);
    final shadColors = shadTheme.colorScheme;
    final invertKeys = useListenableSelector(settings.invertKeys, () => settings.invertKeys.value);
    
    Color black = shadColors.foreground;
    Color white = shadColors.background;
    if (invertKeys) {
      final tmp = black;
      black = white;
      white = tmp;
    }

    return LayoutBuilder(builder: (context, dimens) {
      final viewWidth = dimens.maxWidth;
      final sectionWidth = viewport;
      final totalWidth = sectionWidth * 7;
      final relativeOffset = offset / totalWidth * viewWidth;
      final relativeViewWidth = viewWidth / totalWidth * viewWidth;
      
      return Container(
        color: shadColors.muted,
        padding: const EdgeInsets.only(bottom: 4.0),
        child: GestureDetector(
          onHorizontalDragUpdate: (details) {
            final localX = details.localPosition.dx;
            final newOffset = (localX / viewWidth * totalWidth).clamp(0.0, totalWidth - viewport);
            offsetChanged(newOffset);
          },
          child: Stack(
            children: [
              Positioned.fill(
                child: Row(
                  children: <Widget>[
                    for (int i = 0; i < 7; i++)
                      _buildSection(context, i, black, white),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                width: relativeOffset,
                child: Container(
                  color: shadColors.muted.withValues(alpha: 0.6),
                ),
              ),
              Positioned(
                top: 0,
                bottom: 0,
                left: relativeOffset + relativeViewWidth,
                right: 0,
                child: Container(
                  color: shadColors.muted.withValues(alpha: 0.6),
                ),
              ),
              Positioned(
                left: relativeOffset,
                width: relativeViewWidth,
                top: 0,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: shadColors.primary,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildSection(
    BuildContext context,
    int octave,
    Color black,
    Color white,
  ) {
    return Expanded(
      child: Stack(
        children: <Widget>[
          Row(
            children: <Widget>[
              for (int i = 0; i < 7; i++)
                _buildKey(context, false, black, white),
            ],
          ),
          Positioned.fill(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Spacer(flex: 1),
                _buildKey(context, true, black, white),
                _buildKey(context, true, black, white),
                const Spacer(flex: 2),
                _buildKey(context, true, black, white),
                _buildKey(context, true, black, white),
                _buildKey(context, true, black, white),
                const Spacer(flex: 1),
              ],
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
    return Expanded(
      flex: accidental ? 2 : 1,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 0.5),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(2),
            bottomRight: Radius.circular(2),
          ),
          color: accidental ? black : white,
        ),
      ),
    );
  }
}
