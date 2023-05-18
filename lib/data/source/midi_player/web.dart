// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import '../audio_stream/audio_stream.dart';

import 'impl.dart';

class MidiPlayer extends IMidiPlayer {
  MidiPlayer(this.audioStream);
  final AudioStream audioStream;

  @override
  Future<void> play(int note, int velocity) async {
    html.document.body!.dispatchEvent(html.CustomEvent('midi', detail: {
      'note': note,
      'velocity': velocity,
    }));
  }

  @override
  Future<void> init() async {
    await Future.delayed(const Duration(milliseconds: 100));
  }
}
