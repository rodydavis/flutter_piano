import 'package:flutter/material.dart';
import 'package:flutter_piano/l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../src/services/settings.dart';
import '../../src/services/injection.dart';
import '../router.dart';

class ThePocketPiano extends HookWidget {
  const ThePocketPiano({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = getIt<SettingsService>();
    final color = useListenableSelector(
        settings.themeColor, () => settings.themeColor.value);
    final mode = useListenableSelector(
        settings.themeMode, () => settings.themeMode.value);
    final locale =
        useListenableSelector(settings.locale, () => settings.locale.value);

    return ShadApp.router(
      debugShowCheckedModeBanner: false,
      title: 'The Pocket Piano',
      theme: ShadThemeData(
        brightness: Brightness.light,
        colorScheme: ShadZincColorScheme.light(
          primary: color,
        ),
      ),
      darkTheme: ShadThemeData(
        brightness: Brightness.dark,
        colorScheme: ShadZincColorScheme.dark(
          primary: color,
        ),
      ),
      themeMode: mode,
      locale: locale,
      localizationsDelegates: [
        ...AppLocalizations.localizationsDelegates,
        GlobalShadLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
    );
  }
}
