import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'data/blocs/blocs.dart';
import 'generated/i18n.dart';
import 'plugins/desktop/desktop.dart';
import 'ui/home/screen.dart';
import 'ui/theme.dart';

void main() {
  setTargetPlatformForDesktop();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({
    Key key,
  }) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _settingsBloc = SettingsBloc();

  @override
  void initState() {
    _settingsBloc.add(CheckSettings());
    super.initState();
  }

  @override
  void dispose() {
    _settingsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final i18n = I18n.delegate;
    final theme = ThemeUtils(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider<SettingsBloc>(create: (_) => _settingsBloc),
      ],
      child: BlocListener<SettingsBloc, SettingsState>(
        listener: (context, state) {
          if (state is SettingsReady) {
            I18n.locale = state.settings.locale;
          }
        },
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, settingState) {
            ThemeMode mode = ThemeMode.system;
            if (settingState is SettingsReady) {
              mode = settingState.themeMode;
            }
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: theme.light,
              darkTheme: theme.dark,
              themeMode: mode,
              home: HomeScreen(),
              onGenerateTitle: (context) => I18n.of(context).title,
              locale: settingState is SettingsReady
                  ? settingState.settings.locale
                  : Locale("en", "US"),
              localizationsDelegates: [
                i18n,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              supportedLocales: i18n.supportedLocales,
              localeResolutionCallback: i18n.resolution(
                fallback: settingState is SettingsReady
                    ? settingState.settings.locale
                    : Locale("en", "US"),
              ),
            );
          },
        ),
      ),
    );
  }
}
