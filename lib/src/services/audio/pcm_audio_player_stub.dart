import 'pcm_audio_player.dart';

PcmAudioPlayer getPcmAudioPlayer() {
  throw UnsupportedError(
    'Cannot create a PcmAudioPlayer without dart:js_interop or dart:io.',
  );
}
