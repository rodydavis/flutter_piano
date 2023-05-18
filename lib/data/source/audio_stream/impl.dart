import 'dart:typed_data';

abstract class IAudioStream {
  int nOctaves = 7;
  int bufferSize = 4096 << 4;
  int nChannels = 1;
  int sampleRate = 16000; //44100

  Future<void> play(Uint8List bytes, int frames);
}
