import 'dart:async';

import 'package:bloc/bloc.dart';

import './bloc.dart';
import 'settings.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(InitialSettingsState());

  @override
  Stream<SettingsState> mapEventToState(
    SettingsEvent event,
  ) async* {
    if (event is CheckSettings) {
      yield SettingsReady(Settings());
    }
    if (event is ChangeSettings) {
      yield SettingsReady(event.settings);
    }
  }
}
