import 'package:flutter/services.dart';

class MidiUtils {
  MidiUtils._();

  static void play(int midi) => throw 'Platform Not Supported';

  static void stop(int midi) => throw 'Platform Not Supported';

  static void unmute() => throw 'Platform Not Supported';

  static void prepare(ByteData sf2, String name) =>
      throw 'Platform Not Supported';
}
