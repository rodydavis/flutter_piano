export 'unsupported.dart'
    if (dart.library.html) 'web.dart'
    if (dart.library.io) 'mobile.dart';
import 'package:flutter/services.dart';

import 'unsupported.dart'
    if (dart.library.html) 'web.dart'
    if (dart.library.io) 'mobile.dart';

Future<void> initMidiUtils() async {
  final sf2 = await rootBundle.load("assets/sounds/Piano.sf2");
  if (sf2 != null) MidiUtils.prepare(sf2, "Piano.sf2");
}
