import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../src/services/settings.dart';
import 'piano_section.dart';
import 'piano_slider.dart';

class PianoView extends HookWidget {
  const PianoView({
    super.key,
    required this.octaves,
    required this.onPlay,
    this.onStop,
    required this.settings,
  });

  final int octaves;
  final ValueChanged<int> onPlay;
  final ValueChanged<int>? onStop;
  final SettingsService settings;

  @override
  Widget build(BuildContext context) {
    final controller = useScrollController();
    final currentOffset = useState(0.0);
    final keyWidthValue = useListenableSelector(settings.keyWidth, () => settings.keyWidth.value);
    final disableScroll = useListenableSelector(settings.disableScroll, () => settings.disableScroll.value);
    
    final keyWidth = keyWidthValue + 4;
    final sectionSize = keyWidth * 7;

    useEffect(() {
      void listener() {
        currentOffset.value = controller.offset;
      }
      controller.addListener(listener);
      
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final middleC4Offset = ((keyWidth * 7) * 3) - (keyWidth * 3.5);
        currentOffset.value = middleC4Offset;
        if (controller.hasClients) {
          controller.jumpTo(middleC4Offset);
        }
      });
      
      return () => controller.removeListener(listener);
    }, [keyWidth]);

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
            settings: settings,
            viewport: sectionSize,
            offset: currentOffset.value,
            offsetChanged: (value) {
              controller.jumpTo(value);
              currentOffset.value = value;
            },
          ),
        ),
        Expanded(
          flex: 1,
          child: ListView.builder(
            physics: physics,
            itemCount: octaves,
            controller: controller,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return PianoSection(
                index: index,
                onPlay: onPlay,
                onStop: onStop,
                settings: settings,
              );
            },
          ),
        ),
      ],
    );
  }
}
