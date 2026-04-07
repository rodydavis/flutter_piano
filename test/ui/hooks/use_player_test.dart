import 'package:flutter_hooks_test/flutter_hooks_test.dart';
import 'package:flutter_piano/src/services/injection.dart';
import 'package:flutter_piano/src/services/player.dart';
import 'package:flutter_piano/ui/hooks/use_player.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPlayerService extends Mock implements PlayerService {}

void main() {
  late MockPlayerService mockPlayerService;

  setUp(() {
    mockPlayerService = MockPlayerService();
    getIt.registerSingleton<PlayerService>(mockPlayerService);
  });

  tearDown(() {
    getIt.reset();
  });

  group('usePlayer', () {
    testWidgets('play() calls service.play() with correct sustain', (tester) async {
      when(() => mockPlayerService.play(60, sustain: true)).thenAnswer((_) async {});
      
      final result = await buildHook(() => usePlayer(sustain: true));

      await act(() => result.current.play(60));
      verify(() => mockPlayerService.play(60, sustain: true)).called(1);
    });

    testWidgets('stop() calls service.stop() with correct sustain', (tester) async {
      when(() => mockPlayerService.stop(60, sustain: false)).thenAnswer((_) async {});
      
      final result = await buildHook(() => usePlayer(sustain: false));

      await act(() => result.current.stop(60));
      verify(() => mockPlayerService.stop(60, sustain: false)).called(1);
    });
  });
}
