export 'unsupported.dart'
    if (dart.library.html) 'web.dart'
    if (dart.library.io) 'mobile.dart';
import 'package:flutter/services.dart';

import 'unsupported.dart'
    if (dart.library.html) 'web.dart'
    if (dart.library.io) 'mobile.dart';

Future<void> initMidiUtils(String path) async {
  path ??= "assets/sounds/Piano.sf2";
  final sf2 = await rootBundle.load(path);
  if (sf2 != null) MidiUtils.prepare(sf2, path.split('/').last);
}
