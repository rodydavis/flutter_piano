import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks_test/flutter_hooks_test.dart';
import 'package:flutter_piano/ui/hooks/use_octave.dart';
import 'package:flutter_piano/ui/hooks/use_piano_keyboard.dart';
import 'package:flutter_piano/ui/hooks/use_player.dart';
import 'package:flutter_piano/ui/hooks/use_sustain.dart';
import 'package:flutter_piano/ui/hooks/use_velocity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPianoPlayer extends Mock implements PianoPlayer {}

void main() {
  late MockPianoPlayer mockPlayer;
  late FocusNode focusNode;

  setUp(() {
    mockPlayer = MockPianoPlayer();
    focusNode = FocusNode();
    when(() => mockPlayer.play(any())).thenAnswer((_) async {});
    when(() => mockPlayer.stop(any())).thenAnswer((_) async {});
  });

  group('usePianoKeyboard', () {
    testWidgets('triggers play on KeyDownEvent (KeyA -> C4)', (tester) async {
      final octave = OctaveState(offset: 0, adjust: (_) {}, reset: () {});
      final velocity = VelocityState(value: 127, adjust: (_) {});
      final sustain = SustainState(value: false, setSustain: (_) {});

      final result = await buildHook(() => usePianoKeyboard(
        octave: octave,
        velocity: velocity,
        sustain: sustain,
        player: mockPlayer,
      ));

      final handler = result.current;
      final event = KeyDownEvent(
        logicalKey: LogicalKeyboardKey.keyA,
        physicalKey: PhysicalKeyboardKey.keyA,
        timeStamp: Duration.zero,
      );

      final keyResult = handler(focusNode, event);

      expect(keyResult, KeyEventResult.handled);
      verify(() => mockPlayer.play(60)).called(1);
    });

    testWidgets('triggers stop on KeyUpEvent (KeyA -> C4)', (tester) async {
      final octave = OctaveState(offset: 0, adjust: (_) {}, reset: () {});
      final velocity = VelocityState(value: 127, adjust: (_) {});
      final sustain = SustainState(value: false, setSustain: (_) {});

      final result = await buildHook(() => usePianoKeyboard(
        octave: octave,
        velocity: velocity,
        sustain: sustain,
        player: mockPlayer,
      ));

      final handler = result.current;
      
      handler(focusNode, KeyDownEvent(
        logicalKey: LogicalKeyboardKey.keyA,
        physicalKey: PhysicalKeyboardKey.keyA,
        timeStamp: Duration.zero,
      ));

      final event = KeyUpEvent(
        logicalKey: LogicalKeyboardKey.keyA,
        physicalKey: PhysicalKeyboardKey.keyA,
        timeStamp: Duration.zero,
      );

      final keyResult = handler(focusNode, event);

      expect(keyResult, KeyEventResult.handled);
      verify(() => mockPlayer.stop(60)).called(1);
    });

    testWidgets('adjusts octave with Z and X keys', (tester) async {
      int adjusted = 0;
      final octave = OctaveState(offset: 0, adjust: (v) => adjusted = v, reset: () {});
      final velocity = VelocityState(value: 127, adjust: (_) {});
      final sustain = SustainState(value: false, setSustain: (_) {});

      final result = await buildHook(() => usePianoKeyboard(
        octave: octave,
        velocity: velocity,
        sustain: sustain,
        player: mockPlayer,
      ));

      final handler = result.current;

      handler(focusNode, KeyDownEvent(
        logicalKey: LogicalKeyboardKey.keyZ,
        physicalKey: PhysicalKeyboardKey.keyZ,
        timeStamp: Duration.zero,
      ));
      expect(adjusted, -1);

      handler(focusNode, KeyDownEvent(
        logicalKey: LogicalKeyboardKey.keyX,
        physicalKey: PhysicalKeyboardKey.keyX,
        timeStamp: Duration.zero,
      ));
      expect(adjusted, 1);
    });

    testWidgets('adjusts velocity with C and V keys', (tester) async {
      int adjusted = 0;
      final octave = OctaveState(offset: 0, adjust: (_) {}, reset: () {});
      final velocity = VelocityState(value: 127, adjust: (v) => adjusted = v);
      final sustain = SustainState(value: false, setSustain: (_) {});

      final result = await buildHook(() => usePianoKeyboard(
        octave: octave,
        velocity: velocity,
        sustain: sustain,
        player: mockPlayer,
      ));

      final handler = result.current;

      handler(focusNode, KeyDownEvent(
        logicalKey: LogicalKeyboardKey.keyC,
        physicalKey: PhysicalKeyboardKey.keyC,
        timeStamp: Duration.zero,
      ));
      expect(adjusted, -1);

      handler(focusNode, KeyDownEvent(
        logicalKey: LogicalKeyboardKey.keyV,
        physicalKey: PhysicalKeyboardKey.keyV,
        timeStamp: Duration.zero,
      ));
      expect(adjusted, 1);
    });

    testWidgets('triggers sustain with Space key', (tester) async {
      bool sustained = false;
      final octave = OctaveState(offset: 0, adjust: (_) {}, reset: () {});
      final velocity = VelocityState(value: 127, adjust: (_) {});
      final sustain = SustainState(value: false, setSustain: (v) => sustained = v);

      final result = await buildHook(() => usePianoKeyboard(
        octave: octave,
        velocity: velocity,
        sustain: sustain,
        player: mockPlayer,
      ));

      final handler = result.current;

      handler(focusNode, KeyDownEvent(
        logicalKey: LogicalKeyboardKey.space,
        physicalKey: PhysicalKeyboardKey.space,
        timeStamp: Duration.zero,
      ));
      expect(sustained, true);

      handler(focusNode, KeyUpEvent(
        logicalKey: LogicalKeyboardKey.space,
        physicalKey: PhysicalKeyboardKey.space,
        timeStamp: Duration.zero,
      ));
      expect(sustained, false);
    });

    testWidgets('respects octave offset for MIDI notes', (tester) async {
      final octave = OctaveState(offset: 1, adjust: (_) {}, reset: () {});
      final velocity = VelocityState(value: 127, adjust: (_) {});
      final sustain = SustainState(value: false, setSustain: (_) {});

      final result = await buildHook(() => usePianoKeyboard(
        octave: octave,
        velocity: velocity,
        sustain: sustain,
        player: mockPlayer,
      ));

      final handler = result.current;
      handler(focusNode, KeyDownEvent(
        logicalKey: LogicalKeyboardKey.keyA,
        physicalKey: PhysicalKeyboardKey.keyA,
        timeStamp: Duration.zero,
      ));

      verify(() => mockPlayer.play(72)).called(1);
    });
  });
}
