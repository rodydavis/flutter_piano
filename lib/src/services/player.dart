import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:dart_melty_soundfont/synthesizer.dart';
import 'package:dart_melty_soundfont/synthesizer_settings.dart';
import 'package:dart_melty_soundfont/audio_renderer_ex.dart';
import 'package:dart_melty_soundfont/array_int16.dart';

import 'audio/pcm_audio_player.dart';

@lazySingleton
class PlayerService {
  Synthesizer? _synth;
  late final PcmAudioPlayer _audioPlayer;
  bool _isInitialized = false;

  PlayerService() {
    _init();
  }

  Future<void> _init() async {
    _audioPlayer = PcmAudioPlayer();
    await _audioPlayer.setup(sampleRate: 44100, channelCount: 1);
    _audioPlayer.setFeedCallback(_onFeed);

    ByteData bytes = await rootBundle.load('assets/sounds/Piano.sf2');
    _synth = Synthesizer.loadByteData(bytes, SynthesizerSettings());

    _isInitialized = true;
  }

  void _onFeed(int framesToRender) async {
    if (_synth == null) return;
    
    int frames = framesToRender > 0 ? framesToRender : 2048;
    ArrayInt16 buffer = ArrayInt16.zeros(numShorts: frames);
    _synth!.renderMonoInt16(buffer);
    await _audioPlayer.feed(buffer);
  }

  Future<void> play(int midi, {bool sustain = false}) async {
    if (!_isInitialized || _synth == null) return;
    
    // Apply sustain CC if requested (Control change 64, data2 > 63 = on)
    _synth!.processMidiMessage(channel: 0, command: 0xB0, data1: 64, data2: sustain ? 127 : 0);
    _synth!.noteOn(channel: 0, key: midi, velocity: 100);

    // Fire and forget
    _audioPlayer.play();
  }

  Future<void> stop(int midi, {bool sustain = false}) async {
    if (!_isInitialized || _synth == null) return;
    
    _synth!.processMidiMessage(channel: 0, command: 0xB0, data1: 64, data2: sustain ? 127 : 0);
    _synth!.noteOff(channel: 0, key: midi);
  }

  Future<void> stopSustain() async {
    if (!_isInitialized || _synth == null) return;
    _synth!.processMidiMessage(channel: 0, command: 0xB0, data1: 64, data2: 0);
    _synth!.noteOffAll();
  }
}
