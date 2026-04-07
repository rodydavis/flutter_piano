import 'package:dart_melty_soundfont/array_int16.dart';

import 'pcm_audio_player_stub.dart'
    if (dart.library.io) 'pcm_audio_player_native.dart'
    if (dart.library.js_interop) 'pcm_audio_player_web.dart';

abstract class PcmAudioPlayer {
  factory PcmAudioPlayer() => getPcmAudioPlayer();

  Future<void> setup({required int sampleRate, required int channelCount});
  Future<void> play();
  Future<void> pause();
  Future<void> release();
  
  void setFeedCallback(void Function(int frames) onFeed);
  Future<void> feed(ArrayInt16 buffer);
}
