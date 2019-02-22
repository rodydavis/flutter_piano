import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_midi/flutter_midi.dart';

import 'ui/home/screen.dart';

void main() async {
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);
  FlutterMidi.unmute();
  ByteData _byte = await rootBundle.load("assets/sounds/Piano.SF2");
  FlutterMidi.prepare(sf2: _byte, name: "Piano.SF2");
  return runApp(MaterialApp(
      title: 'The Pocket Piano', theme: ThemeData.dark(), home: HomeScreen()));
}
