import 'dart:typed_data';

import 'package:raw_sound/raw_sound_player.dart';

import 'impl.dart';

class AudioStream extends IAudioStream {
  final _players = <RawSoundPlayer>[];

  @override
  Future<void> play(Uint8List bytes, int frames) async {
    final player = RawSoundPlayer();
    await player.initialize(
      bufferSize: bufferSize,
      nChannels: nChannels,
      sampleRate: sampleRate,
      pcmType: RawSoundPCMType.PCMI16,
    );
    _players.add(player);
    await player.play();
    await player.feed(bytes);
    _players.remove(player);
  }
}
