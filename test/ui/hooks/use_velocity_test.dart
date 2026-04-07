import 'package:flutter_hooks_test/flutter_hooks_test.dart';
import 'package:flutter_piano/ui/hooks/use_velocity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('useVelocity', () {
    testWidgets('initial state is 127', (tester) async {
      final result = await buildHook(() => useVelocity());
      expect(result.current.value, 127);
    });

    testWidgets('adjust increases and decreases velocity', (tester) async {
      final result = await buildHook(() => useVelocity());

      await act(() => result.current.adjust(-27));
      expect(result.current.value, 100);

      await act(() => result.current.adjust(10));
      expect(result.current.value, 110);
    });

    testWidgets('adjust is clamped between 0 and 127', (tester) async {
      final result = await buildHook(() => useVelocity());

      await act(() => result.current.adjust(10));
      expect(result.current.value, 127);

      await act(() => result.current.adjust(-200));
      expect(result.current.value, 0);
    });
  });
}
