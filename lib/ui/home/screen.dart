import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_midi/flutter_midi.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/piano_view.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  SharedPreferences prefs;
  bool _isDisposed = false;

  @override
  initState() {
    _loadSoundFont();
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
  }

  void _loadSettings() async {
    prefs = await SharedPreferences.getInstance();
    if (!_isDisposed)
      setState(() {
        _widthRatio = prefs.getDouble("ratio") ?? 0.5;
        _showLabels = prefs.getBool("labels") ?? true;
        _labelsOnlyOctaves = prefs.getBool("octaves") ?? false;
        _disableScroll = prefs.getBool("scroll") ?? false;
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

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size);
    return Scaffold(
      drawer: Drawer(
          child: SafeArea(
        child: ListView(children: <Widget>[
          Container(height: 20.0),
          ListTile(title: Text("Change Width")),
          Slider(
              activeColor: Colors.redAccent,
              inactiveColor: Colors.white,
              min: 0.0,
              max: 1.0,
              value: _widthRatio ?? 0.5,
              onChanged: (double value) {
                if (!_isDisposed) setState(() => _widthRatio = value);
                prefs.setDouble("ratio", value);
              }),
          Divider(),
          ListTile(
              title: Text("Show Labels"),
              trailing: Switch(
                  value: _showLabels,
                  onChanged: (bool value) {
                    if (!_isDisposed) setState(() => _showLabels = value);
                    prefs.setBool("labels", value);
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
                          prefs.setBool("octaves", value);
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
                    prefs.setBool("scroll", value);
                  })),
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
            ),
          ),
          Flexible(
            child: PianoView(
              keyWidth: keyWidth,
              showLabels: _showLabels,
              labelsOnlyOctaves: _labelsOnlyOctaves,
              disableScroll: _disableScroll,
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
    );
  }
}
