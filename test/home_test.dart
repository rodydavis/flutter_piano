import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_piano/src/services/player.dart';
import 'package:flutter_piano/src/services/settings.dart';
import 'package:flutter_piano/src/services/injection.dart';
import 'package:flutter_piano/ui/screens/app.dart';
import 'package:flutter_piano/ui/widgets/piano_view.dart';
import 'package:flutter_piano/src/version.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockPlayerService extends Mock implements PlayerService {}
class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late MockPlayerService mockPlayerService;
  late SettingsService settingsService;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() async {
    mockPlayerService = MockPlayerService();
    mockSharedPreferences = MockSharedPreferences();
    
    // Stub SharedPreferences
    when(() => mockSharedPreferences.getBool(any())).thenReturn(null);
    when(() => mockSharedPreferences.getInt(any())).thenReturn(null);
    when(() => mockSharedPreferences.getDouble(any())).thenReturn(null);
    when(() => mockSharedPreferences.getString(any())).thenReturn(packageVersion);
    when(() => mockSharedPreferences.setBool(any(), any())).thenAnswer((_) async => true);
    when(() => mockSharedPreferences.setInt(any(), any())).thenAnswer((_) async => true);
    when(() => mockSharedPreferences.setDouble(any(), any())).thenAnswer((_) async => true);
    when(() => mockSharedPreferences.setString(any(), any())).thenAnswer((_) async => true);

    settingsService = SettingsService(mockSharedPreferences);
    
    getIt.reset();
    getIt.registerSingleton<PlayerService>(mockPlayerService);
    getIt.registerSingleton<SettingsService>(settingsService);
    getIt.registerSingleton<SharedPreferences>(mockSharedPreferences);
  });

  testWidgets('renders App correctly', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1024, 768));
    await tester.pumpWidget(const ThePocketPiano());
    
    // Wait for GoRouter to initialize and navigate
    for(int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    await tester.pumpAndSettle();

    expect(find.byType(ThePocketPiano), findsOneWidget);
    // Use predicate to avoid type mismatch issues just in case
    expect(find.byWidgetPredicate((w) => w.runtimeType.toString() == 'Home'), findsOneWidget);
    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.byType(PianoView), findsWidgets);
  });
}
