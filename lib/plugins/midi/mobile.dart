import 'package:flutter/services.dart';
import 'package:flutter_midi/flutter_midi.dart';

class MidiUtils {
  MidiUtils._();

  static void play(int midi) => FlutterMidi.playMidiNote(midi: midi);

  static void stop(int midi) => FlutterMidi.stopMidiNote(midi: midi);

  static void unmute() => FlutterMidi.unmute();

  static void prepare(ByteData sf2, String name) =>
      FlutterMidi.prepare(sf2: sf2, name: "Piano.sf2");
}
