import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/blocs/blocs.dart';
import '../../data/blocs/settings/settings.dart';
import '../../generated/i18n.dart';
import '../../plugins/app_review/app_review.dart';
import '../../plugins/midi/midi.dart';
import '../../plugins/vibrate/vibrate.dart';
import '../common/index.dart';
import '../common/piano_view.dart';
import '../settings/screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  @override
  initState() {
    _loadSoundFont();
    Future.delayed(Duration(seconds: 60)).then((_) {
      if (mounted) ReviewUtils.requestReview();
    });
    super.initState();
  }

  void _loadSoundFont() async {
    MidiUtils.unmute();
    rootBundle.load("assets/sounds/Piano.sf2").then((sf2) {
      MidiUtils.prepare(sf2, "Piano.sf2");
    });
    VibrateUtils.canVibrate.then((vibrate) {
      if (mounted)
        setState(() {
          canVibrate = vibrate;
        });
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("State: $state");
    _loadSoundFont();
  }

  bool canVibrate = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) => Scaffold(
        drawer: Drawer(
            child: SafeArea(
          child: ListView(children: <Widget>[
            Container(height: 20.0),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Settings"),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SettingsScreen()));
              },
            ),
            Divider(),
            if (state is SettingsReady) ...[
              ListTile(title: Text("Change Width")),
              Slider(
                  activeColor: Colors.redAccent,
                  inactiveColor: Colors.white,
                  min: 0.0,
                  max: 1.0,
                  value: state.settings.widthRatio,
                  onChanged: (double value) =>
                      BlocProvider.of<SettingsBloc>(context).dispatch(
                          ChangeSettings(state.settings..widthRatio = value))),
              Divider(),
              ListTile(
                  title: Text("Show Labels"),
                  trailing: Switch(
                      value: state.settings.showLabels,
                      onChanged: (bool value) =>
                          BlocProvider.of<SettingsBloc>(context).dispatch(
                              ChangeSettings(
                                  state.settings..showLabels = value)))),
              Container(
                child: state.settings.showLabels
                    ? ListTile(
                        title: Text("Only For Octaves"),
                        trailing: Switch(
                            value: state.settings.labelsOnlyOctaves,
                            onChanged: (bool value) =>
                                BlocProvider.of<SettingsBloc>(context).dispatch(
                                    ChangeSettings(state.settings
                                      ..labelsOnlyOctaves = value))))
                    : null,
              ),
              Divider(),
              ListTile(
                  title: Text("Disable Scroll"),
                  trailing: Switch(
                      value: state.settings.disableScroll,
                      onChanged: (bool value) =>
                          BlocProvider.of<SettingsBloc>(context).dispatch(
                              ChangeSettings(
                                  state.settings..disableScroll = value)))),
              Divider(),
              Container(
                child: canVibrate
                    ? ListTile(
                        title: Text("Key Feedback"),
                        trailing: Switch(
                          value: state.settings.shouldVibrate,
                          onChanged: (bool value) =>
                              BlocProvider.of<SettingsBloc>(context).dispatch(
                                  ChangeSettings(
                                      state.settings..shouldVibrate = value)),
                        ),
                      )
                    : null,
              ),
            ],
          ]),
        )),
        appBar: AppBar(
          title: Text(
            I18n.of(context).title,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 30.0,
            ),
          ),
          actions: <Widget>[
            DarkModeToggle(),
          ],
        ),
        body: state is SettingsReady
            ? Container(
                color: state.settings.darkMode ? null : Colors.grey[300],
                child: _buildKeys(context, state.settings),
              )
            : Container(child: Center(child: CircularProgressIndicator())),
      ),
    );
  }

  Widget _buildKeys(BuildContext context, Settings settings) {
    double keyWidth = 40 + (80 * (settings.widthRatio ?? 0.5));
    final _vibrate = settings.shouldVibrate && canVibrate;
    if (MediaQuery.of(context).size.height > 600) {
      return Flex(
        direction: Axis.vertical,
        children: <Widget>[
          Flexible(
            child: PianoView(
              keyWidth: keyWidth,
              showLabels: settings.showLabels,
              labelsOnlyOctaves: settings.labelsOnlyOctaves,
              disableScroll: settings.disableScroll,
              feedback: _vibrate,
            ),
          ),
          Flexible(
            child: PianoView(
              keyWidth: keyWidth,
              showLabels: settings.showLabels,
              labelsOnlyOctaves: settings.labelsOnlyOctaves,
              disableScroll: settings.disableScroll,
              feedback: _vibrate,
            ),
          ),
        ],
      );
    }
    return PianoView(
      keyWidth: keyWidth,
      showLabels: settings.showLabels,
      labelsOnlyOctaves: settings.labelsOnlyOctaves,
      disableScroll: settings.disableScroll,
      feedback: _vibrate,
    );
  }
}
