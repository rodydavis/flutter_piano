import 'package:flutter_hooks/flutter_hooks.dart';
import '../../src/services/chord_engine.dart';

class ChordState {
  final String chord;
  final void Function(int midi) onNoteOn;
  final void Function(int midi) onNoteOff;
  final void Function() clear;

  ChordState({
    required this.chord,
    required this.onNoteOn,
    required this.onNoteOff,
    required this.clear,
  });
}

ChordState useChordRecognition() {
  final activeNotes = useState<Set<int>>({});

  void onNoteOn(int midi) {
    if (!activeNotes.value.contains(midi)) {
      activeNotes.value = {...activeNotes.value, midi};
    }
  }

  void onNoteOff(int midi) {
    if (activeNotes.value.contains(midi)) {
      activeNotes.value = activeNotes.value.where((n) => n != midi).toSet();
    }
  }

  void clear() {
    activeNotes.value = {};
  }

  final chord = useMemoized(() {
    final midiNotes = activeNotes.value.map(MidiNote.new).toList();
    return identifyChord(midiNotes);
  }, [activeNotes.value]);

  return ChordState(
    chord: chord,
    onNoteOn: onNoteOn,
    onNoteOff: onNoteOff,
    clear: clear,
  );
}
