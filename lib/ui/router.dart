import 'package:go_router/go_router.dart';

import 'screens/home.dart';
import 'screens/settings.dart';
import '../src/services/injection.dart';
import '../src/services/settings.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const Home(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) =>
          SettingsScreen(settings: getIt<SettingsService>()),
    ),
  ],
);
