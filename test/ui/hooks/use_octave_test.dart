import 'package:flutter_hooks_test/flutter_hooks_test.dart';
import 'package:flutter_piano/ui/hooks/use_octave.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('useOctave', () {
    testWidgets('initial state is 0', (tester) async {
      final result = await buildHook(() => useOctave());
      expect(result.current.offset, 0);
    });

    testWidgets('adjust increases and decreases offset', (tester) async {
      final result = await buildHook(() => useOctave());

      await act(() => result.current.adjust(1));
      expect(result.current.offset, 1);

      await act(() => result.current.adjust(-2));
      expect(result.current.offset, -1);
    });

    testWidgets('adjust is clamped at -5 and 5', (tester) async {
      final result = await buildHook(() => useOctave());

      // Max nOctaves=7, clamping at -5 to 5 ( -7+2 to 7-2 )
      await act(() => result.current.adjust(10));
      expect(result.current.offset, 5);

      await act(() => result.current.adjust(-20));
      expect(result.current.offset, -5);
    });

    testWidgets('reset sets offset to 0', (tester) async {
      final result = await buildHook(() => useOctave());

      await act(() => result.current.adjust(3));
      expect(result.current.offset, 3);

      await act(() => result.current.reset());
      expect(result.current.offset, 0);
    });
  });
}
