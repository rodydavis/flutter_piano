import 'package:dart_melty_soundfont/dart_melty_soundfont.dart';
import 'package:flutter/services.dart';

import '../audio_stream/audio_stream.dart';
import 'impl.dart';

class MidiPlayer extends IMidiPlayer {
  MidiPlayer(this.audioStream);
  final AudioStream audioStream;
  Synthesizer? synth;

  @override
  Future<void> init() async {
    await rootBundle.load('assets/sounds/Piano.sf2').then((bytes) async {
      final settings = SynthesizerSettings(
        sampleRate: audioStream.sampleRate,
        blockSize: 64,
        maximumPolyphony: 64,
        enableReverbAndChorus: false,
      );
      synth = Synthesizer.loadByteData(bytes, settings);
    });
  }

  @override
  Future<void> play(int note, int velocity) async {
    synth!.reset();
    synth!.noteOn(
      channel: 0,
      key: note,
      velocity: velocity,
    );
    const frames = 3;
    await audioStream.play(synth!.pcm(frames), frames);
  }
}
