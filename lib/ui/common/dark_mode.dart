import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/blocs/blocs.dart';
import '../../generated/i18n.dart';

class DarkModeToggle extends StatelessWidget {
  const DarkModeToggle({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          if (state is SettingsReady) {
            return IconButton(
              tooltip: I18n.of(context).settingsDarkMode,
              icon: state.settings.darkMode
                  ? Icon(Icons.brightness_high)
                  : Icon(Icons.brightness_low),
              onPressed: () => BlocProvider.of<SettingsBloc>(context).dispatch(
                  ChangeSettings(
                      state.settings..darkMode = !state.settings.darkMode)),
            );
          }
          return Container();
        },
      ),
    );
  }
}
