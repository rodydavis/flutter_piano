import 'package:flutter_hooks_test/flutter_hooks_test.dart';
import 'package:flutter_piano/src/services/injection.dart';
import 'package:flutter_piano/src/services/player.dart';
import 'package:flutter_piano/ui/hooks/use_sustain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPlayerService extends Mock implements PlayerService {}

void main() {
  late MockPlayerService mockPlayerService;

  setUp(() {
    mockPlayerService = MockPlayerService();
    when(() => mockPlayerService.stopSustain()).thenAnswer((_) async {});
    getIt.registerSingleton<PlayerService>(mockPlayerService);
  });

  tearDown(() {
    getIt.reset();
  });

  group('useSustain', () {
    testWidgets('initial state is false', (tester) async {
      final result = await buildHook(() => useSustain());
      expect(result.current.value, false);
    });

    testWidgets('setSustain updates value', (tester) async {
      final result = await buildHook(() => useSustain());

      await act(() => result.current.setSustain(true));
      expect(result.current.value, true);

      await act(() => result.current.setSustain(false));
      expect(result.current.value, false);
    });

    testWidgets('calls player.stopSustain() when sustain is set to false', (tester) async {
      when(() => mockPlayerService.stopSustain()).thenAnswer((_) async {});

      final result = await buildHook(() => useSustain());

      // Set to true first
      await act(() => result.current.setSustain(true));
      verifyNever(() => mockPlayerService.stopSustain());

      // Set to false
      await act(() => result.current.setSustain(false));
      verify(() => mockPlayerService.stopSustain()).called(1);
    });
  });
}
