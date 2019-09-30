import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_midi/flutter_midi.dart';
import 'package:flutter_piano/data/blocs/blocs.dart';

import '../../generated/i18n.dart';
import '../../plugins/app_review/app_review.dart';
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
    FlutterMidi.unmute();
    rootBundle.load("assets/sounds/Piano.sf2").then((sf2) {
      FlutterMidi.prepare(sf2: sf2, name: "Piano.sf2");
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
    // print(MediaQuery.of(context).size);
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
                  onChanged: (double value) {
                    if (mounted) setState(() => _widthRatio = value);
                    _storage.setItem("ratio", value);
                  }),
              Divider(),
              ListTile(
                  title: Text("Show Labels"),
                  trailing: Switch(
                      value: state.settings.showLabels,
                      onChanged: (bool value) {
                        if (mounted) setState(() => _showLabels = value);
                        _storage.setItem("labels", value);
                      })),
              Container(
                child: _showLabels
                    ? ListTile(
                        title: Text("Only For Octaves"),
                        trailing: Switch(
                            value: state.settings.labelsOnlyOctaves,
                            onChanged: (bool value) {
                              if (mounted)
                                setState(() => _labelsOnlyOctaves = value);
                              _storage.setItem("octaves", value);
                            }))
                    : null,
              ),
              Divider(),
              ListTile(
                  title: Text("Disable Scroll"),
                  trailing: Switch(
                      value: state.settings.disableScroll,
                      onChanged: (bool value) {
                        if (mounted) setState(() => _disableScroll = value);
                        _storage.setItem("scroll", value);
                      })),
              Divider(),
              Container(
                child: canVibrate
                    ? ListTile(
                        title: Text("Key Feedback"),
                        trailing: Switch(
                            value: state.settings.shouldVibrate,
                            onChanged: (bool value) {
                              if (mounted)
                                setState(() => shouldVibrate = value);
                              _storage.setItem("vibrate", value);
                            }))
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
        body: _buildKeys(context),
      ),
    );
  }

  Widget _buildKeys(BuildContext context) {
    double = keyWidth = 40 + (80 * (_widthRatio ?? 0.5));
    final _vibrate = shouldVibrate && canVibrate;
    if (MediaQuery.of(context).size.height > 600) {
      return Flex(
        direction: Axis.vertical,
        children: <Widget>[
          Flexible(
            child: PianoView(
              keyWidth: keyWidth,
              showLabels: _showLabels,
              labelsOnlyOctaves: _labelsOnlyOctaves,
              disableScroll: _disableScroll,
              feedback: _vibrate,
            ),
          ),
          Flexible(
            child: PianoView(
              keyWidth: keyWidth,
              showLabels: _showLabels,
              labelsOnlyOctaves: _labelsOnlyOctaves,
              disableScroll: _disableScroll,
              feedback: _vibrate,
            ),
          ),
        ],
      );
    }
    return PianoView(
      keyWidth: keyWidth,
      showLabels: _showLabels,
      labelsOnlyOctaves: _labelsOnlyOctaves,
      disableScroll: _disableScroll,
      feedback: _vibrate,
    );
  }
}
