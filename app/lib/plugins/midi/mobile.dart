import 'package:flutter/services.dart';
import 'package:flutter_midi/flutter_midi.dart';

class MidiUtils {
  MidiUtils._();

  static final instance = FlutterMidi();

  static void play(int midi) => instance.playMidiNote(midi: midi);

  static void stop(int midi) => instance.stopMidiNote(midi: midi);

  static void unmute() => instance.unmute();

  static void prepare(ByteData sf2, String name) =>
      instance.prepare(sf2: sf2, name: "Piano.sf2");
}
