import 'package:flutter/services.dart';
import 'package:universal_html/prefer_universal/html.dart' as html;

class MidiUtils {
  MidiUtils._();

  static void play(int midi) {
    html.window.document.getElementById('midiPlay$midi').click();
    print('Midi -> $midi');
  }

  static void stop(int midi) {}

  static void unmute() {}

  static void prepare(ByteData sf2, String name) {
    print('Setup Midi..');
  }
}
