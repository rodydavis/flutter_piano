import 'package:flutter/services.dart';
import 'package:tonic/tonic.dart' as tonic;
// import 'package:universal_html/prefer_universal/html.dart' as html;
import 'dart:js' as js;

class MidiUtils {
  MidiUtils._();

  static void play(int midi) {
    String _note = tonic.Pitch.fromMidiNumber(midi).toString();
    _note = _note.replaceAll('♭', 'b').replaceAll('♯', '#');
    // print('Midi -> $midi/$_note');
    js.context.callMethod("playNote", ["$_note", "8n"]);
    // html.window.document.getElementById('midiPlay$midi').click();
  }
  static String midi2name(int number) => "${tonic.flatNoteNames[number % 12]}${number ~/ 12 - 1}";
  static void stop(int midi) {}

  static void unmute() {}

  static void prepare(ByteData sf2, String name) {
    print('Setup Midi..');
  }
}
