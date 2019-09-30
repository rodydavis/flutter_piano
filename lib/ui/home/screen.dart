import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_midi/flutter_midi.dart';
import 'package:localstorage/localstorage.dart';

import '../../plugins/app_review/app_review.dart';
import '../../plugins/vibrate/vibrate.dart';
import '../common/piano_view.dart';
import '../settings/screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final LocalStorage _storage = new LocalStorage('app_settings');

  bool _isDisposed = false;

  @override
  initState() {
    _loadSoundFont();
    Future.delayed(Duration(seconds: 60)).then((_) {
      if (mounted) ReviewUtils.requestReview();
    });
    super.initState();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void _loadSoundFont() async {
    FlutterMidi.unmute();
    rootBundle.load("assets/sounds/Piano.sf2").then((sf2) {
      FlutterMidi.prepare(sf2: sf2, name: "Piano.sf2");
    });
    _loadSettings();
    VibrateUtils.canVibrate.then((vibrate) {
      if (!_isDisposed)
        setState(() {
          canVibrate = vibrate;
        });
    });
  }

  void _loadSettings() async {
    await _storage.ready;
    if (!_isDisposed)
      setState(() {
        _widthRatio = _storage.getItem("ratio") ?? 0.5;
        _showLabels = _storage.getItem("labels") ?? true;
        _labelsOnlyOctaves = _storage.getItem("octaves") ?? false;
        _disableScroll = _storage.getItem("scroll") ?? false;
        shouldVibrate = _storage.getItem("vibrate") ?? true;
      });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("State: $state");
    _loadSoundFont();
  }

  double get keyWidth => 40 + (80 * (_widthRatio ?? 0.5));
  double _widthRatio;
  bool _showLabels = true;
  bool _labelsOnlyOctaves = true;
  bool _disableScroll = false;
  bool canVibrate = false;
  bool shouldVibrate = true;

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size);
    return Scaffold(
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
          ListTile(title: Text("Change Width")),
          Slider(
              activeColor: Colors.redAccent,
              inactiveColor: Colors.white,
              min: 0.0,
              max: 1.0,
              value: _widthRatio ?? 0.5,
              onChanged: (double value) {
                if (!_isDisposed) setState(() => _widthRatio = value);
                _storage.setItem("ratio", value);
              }),
          Divider(),
          ListTile(
              title: Text("Show Labels"),
              trailing: Switch(
                  value: _showLabels,
                  onChanged: (bool value) {
                    if (!_isDisposed) setState(() => _showLabels = value);
                    _storage.setItem("labels", value);
                  })),
          Container(
            child: _showLabels
                ? ListTile(
                    title: Text("Only For Octaves"),
                    trailing: Switch(
                        value: _labelsOnlyOctaves,
                        onChanged: (bool value) {
                          if (!_isDisposed)
                            setState(() => _labelsOnlyOctaves = value);
                          _storage.setItem("octaves", value);
                        }))
                : null,
          ),
          Divider(),
          ListTile(
              title: Text("Disable Scroll"),
              trailing: Switch(
                  value: _disableScroll,
                  onChanged: (bool value) {
                    if (!_isDisposed) setState(() => _disableScroll = value);
                    _storage.setItem("scroll", value);
                  })),
          Divider(),
          Container(
            child: canVibrate
                ? ListTile(
                    title: Text("Key Feedback"),
                    trailing: Switch(
                        value: shouldVibrate,
                        onChanged: (bool value) {
                          if (!_isDisposed)
                            setState(() => shouldVibrate = value);
                          _storage.setItem("vibrate", value);
                        }))
                : null,
          ),
        ]),
      )),
      appBar: AppBar(
          title: Text(
        "The Pocket Piano",
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 30.0,
        ),
      )),
      body: _buildKeys(context),
    );
  }

  Widget _buildKeys(BuildContext context) {
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
