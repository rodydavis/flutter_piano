import 'package:flutter_hooks/flutter_hooks.dart';

class OctaveState {
  final int offset;
  final void Function(int) adjust;
  final void Function() reset;

  OctaveState({
    required this.offset,
    required this.adjust,
    required this.reset,
  });
}

OctaveState useOctave() {
  final offset = useState(0);
  const nOctaves = 7;

  void adjust(int adjustment) {
    offset.value = (offset.value + adjustment).clamp(
      -nOctaves + 2,
      nOctaves - 2,
    );
  }

  void reset() {
    offset.value = 0;
  }

  return OctaveState(
    offset: offset.value,
    adjust: adjust,
    reset: reset,
  );
}
