import 'package:flutter_pcm_sound/flutter_pcm_sound.dart';
import 'package:dart_melty_soundfont/array_int16.dart';
import 'pcm_audio_player.dart';

PcmAudioPlayer getPcmAudioPlayer() => NativePcmAudioPlayer();

class NativePcmAudioPlayer implements PcmAudioPlayer {
  @override
  Future<void> setup({required int sampleRate, required int channelCount}) async {
    await FlutterPcmSound.setLogLevel(LogLevel.standard);
    await FlutterPcmSound.setFeedThreshold(2000);
    await FlutterPcmSound.setup(sampleRate: sampleRate, channelCount: channelCount);
  }

  @override
  Future<void> play() async {
    FlutterPcmSound.start();
  }

  @override
  Future<void> pause() async {
    // Unsupported natively
  }

  @override
  Future<void> release() => FlutterPcmSound.release();

  @override
  void setFeedCallback(void Function(int frames) onFeed) {
    FlutterPcmSound.setFeedCallback(onFeed);
  }

  @override
  Future<void> feed(ArrayInt16 buffer) async {
    await FlutterPcmSound.feed(PcmArrayInt16(bytes: buffer.bytes));
  }
}
