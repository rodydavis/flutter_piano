import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/source/settings.dart';
import 'piano_section.dart';
import 'piano_slider.dart';

class PianoView extends ConsumerStatefulWidget {
  const PianoView({
    super.key,
    required this.octaves,
    required this.onPlay,
  });

  final int octaves;
  final ValueChanged<int> onPlay;

  @override
  ConsumerState<PianoView> createState() => _PianoViewState();
}

class _PianoViewState extends ConsumerState<PianoView> {
  final _controller = ScrollController();
  double currentOffset = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (mounted) {
        setState(() {
          currentOffset = _controller.offset;
        });
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final keyWidth = ref.read(keyWidthProvider) + 4;
      final middleC4Offset = ((keyWidth * 7) * 3) - (keyWidth * 3.5);
      if (mounted) {
        setState(() {
          currentOffset = middleC4Offset;
        });
      }
      _controller.jumpTo(currentOffset);
    });
  }

  @override
  Widget build(BuildContext context) {
    final offset = currentOffset;
    final keyWidth = ref.read(keyWidthProvider) + 4;
    final sectionSize = keyWidth * 7;
    final disableScroll = ref.watch(disableScrollProvider);
    final physics = disableScroll
        ? const NeverScrollableScrollPhysics()
        : const BouncingScrollPhysics();
    return Column(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(
            maxHeight: 50,
          ),
          child: PianoSlider(
            viewport: sectionSize,
            offset: offset,
            offsetChanged: (value) {
              _controller.jumpTo(value);
              if (mounted) {
                setState(() {
                  currentOffset = value;
                });
              }
            },
          ),
        ),
        Expanded(
          flex: 1,
          child: ListView.builder(
            physics: physics,
            itemCount: widget.octaves,
            controller: _controller,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return PianoSection(
                index: index,
                onPlay: widget.onPlay,
              );
            },
          ),
        ),
      ],
    );
  }
}
