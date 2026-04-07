import 'dart:js_interop';
import 'dart:typed_data';
import 'package:web/web.dart' as web;
import 'package:dart_melty_soundfont/array_int16.dart';
import 'pcm_audio_player.dart';

PcmAudioPlayer getPcmAudioPlayer() => WebPcmAudioPlayer();

class WebPcmAudioPlayer implements PcmAudioPlayer {
  web.AudioContext? _audioContext;
  web.ScriptProcessorNode? _scriptNode;
  void Function(int frames)? _onFeed;
  
  final List<double> _bufferQueue = [];
  
  @override
  Future<void> setup({required int sampleRate, required int channelCount}) async {
    _audioContext = web.AudioContext(web.AudioContextOptions(sampleRate: sampleRate));
    _scriptNode = _audioContext!.createScriptProcessor(2048, 0, channelCount);
    
    _scriptNode!.onaudioprocess = ((web.AudioProcessingEvent event) {
      final buffer = event.outputBuffer;
      final channelData = buffer.getChannelData(0);
      final int length = buffer.length;
      
      if (_bufferQueue.length < length) {
        _onFeed?.call(2048); 
      }
      
      final Float32List dartList = channelData.toDart;
      for (int i = 0; i < length; i++) {
        if (_bufferQueue.isNotEmpty) {
           dartList[i] = _bufferQueue.removeAt(0);
        } else {
           dartList[i] = 0.0;
        }
      }
    }.toJS);
  }

  @override
  Future<void> play() async {
    if (_audioContext?.state == 'suspended') {
      // AudioContext.resume returns a JS promise.
      // Wait, in dart package:web we might need to await it carefully or not await.
      _audioContext!.resume();
    }
    _scriptNode?.connect(_audioContext!.destination);
  }

  @override
  Future<void> pause() async {
    _scriptNode?.disconnect();
    if (_audioContext?.state == 'running') {
      _audioContext!.suspend();
    }
  }

  @override
  Future<void> release() async {
    await pause();
    _audioContext?.close();
  }

  @override
  void setFeedCallback(void Function(int frames) onFeed) {
    _onFeed = onFeed;
  }

  @override
  Future<void> feed(ArrayInt16 buffer) async {
    int numShorts = buffer.bytes.lengthInBytes ~/ 2;
    for (var i = 0; i < numShorts; i++) {
      int val = buffer.bytes.getInt16(i * 2, Endian.little);
      _bufferQueue.add(val / 32768.0);
    }
  }
}
