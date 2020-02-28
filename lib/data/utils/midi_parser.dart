import 'package:dart_midi/dart_midi.dart';

MidiFile midiParser(List<int> buffer) {
  final parser = MidiParser();
  try {
    MidiFile parsedMidi = parser.parseMidiFromBuffer(buffer);
    return parsedMidi;
  } catch (e) {
    print('Error Loading Midi: $e');
  }
  return null;
}
