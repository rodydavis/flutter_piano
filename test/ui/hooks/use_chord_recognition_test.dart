import 'package:flutter_hooks_test/flutter_hooks_test.dart';
import 'package:flutter_piano/ui/hooks/use_chord_recognition.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('useChordRecognition', () {
    testWidgets('initial state is empty', (tester) async {
      final result = await buildHook(() => useChordRecognition());
      expect(result.current.chord, '');
    });

    testWidgets('onNoteOn adds notes and updates chord', (tester) async {
      final result = await buildHook(() => useChordRecognition());

      await act(() => result.current.onNoteOn(60)); // C
      expect(result.current.chord, 'C');

      await act(() => result.current.onNoteOn(64)); // E
      await act(() => result.current.onNoteOn(67)); // G
      expect(result.current.chord, 'C Major');
    });

    testWidgets('onNoteOff removes notes and updates chord', (tester) async {
      final result = await buildHook(() => useChordRecognition());

      await act(() => result.current.onNoteOn(60));
      await act(() => result.current.onNoteOn(64));
      await act(() => result.current.onNoteOn(67));
      expect(result.current.chord, 'C Major');

      await act(() => result.current.onNoteOff(64));
      expect(result.current.chord, 'C 5'); // C and G

      await act(() => result.current.onNoteOff(67));
      expect(result.current.chord, 'C');
    });

    testWidgets('clear removes all notes', (tester) async {
      final result = await buildHook(() => useChordRecognition());

      await act(() => result.current.onNoteOn(60));
      await act(() => result.current.onNoteOn(64));
      expect(result.current.chord, contains('C-E'));

      await act(() => result.current.clear());
      expect(result.current.chord, '');
    });
  });
}
