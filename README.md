# flutter_piano

A Crossplatform Midi Piano built with Flutter.io.

- This application runs on both iOS and Android.
- This runs a custom crossplatform midi synth I built for a Flutter plugin `flutter_midi` that uses .SF2 sound font files.

```
 assets:
   - assets/sounds/Piano.SF2

```

- There are Semantics included for the visually impaired. All keys show up as buttons and have the pitch name of the midi note not just the number.

## Getting Started

This application only runs in landscape mode, orientation is set in the AndroidManifest.xml and in the Runner.xcworspace settings.

1. Make sure to turn your volume up and unmute the phone (the application will try to unmute the device but it can be overriden).
2. Tap on any note to play
3. Scroll in either direction to change octaves
4. Polyphony is supported with multiple fingers

## Configuration

- Optionally the key width can be changed in the settings for adjusting key densitity.

- The key labels can also be turned off if you want a more minimal look.

### IOS

![alt-text-1](https://github.com/AppleEducate/flutter_piano/blob/master/screenshots/ios_2.PNG)

### Android

![alt-text-2](https://github.com/AppleEducate/flutter_piano/blob/master/screenshots/android_1.jpg)

- You can change the Piano.sf2 file to any sound font file for playing different instruments.

## Screenshots

### iOS

![alt-text-1](https://github.com/AppleEducate/flutter_piano/blob/master/screenshots/ios_1.PNG)
![alt-text-1](https://github.com/AppleEducate/flutter_piano/blob/master/screenshots/ios_3.PNG)

### Android

![alt-text-2](https://github.com/AppleEducate/flutter_piano/blob/master/screenshots/android_3.jpg)
![alt-text-2](https://github.com/AppleEducate/flutter_piano/blob/master/screenshots/android_2.jpg)

## Code

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_midi/flutter_midi.dart';
import 'package:tonic/tonic.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  initState() {
    FlutterMidi.unmute();
    rootBundle.load("assets/sounds/Piano.sf2").then((sf2) {
      FlutterMidi.prepare(sf2: sf2, name: "Piano.sf2");
    });
    super.initState();
  }

  double get keyWidth => 80 + (80 * _widthRatio);
  double _widthRatio = 0.0;
  bool _showLabels = true;

  @override
  Widget build(context) {
    return MaterialApp(
      title: 'The Pocket Piano',
      theme: ThemeData.dark(),
      home: Scaffold(
          drawer: Drawer(
              child: SafeArea(
                  child: ListView(children: <Widget>[
            SizedBox(height: 20),
            ListTile(title: Text("Change Width")),
            Slider(
                activeColor: Colors.redAccent,
                inactiveColor: Colors.white,
                min: 0,
                max: 1,
                value: _widthRatio,
                onChanged: (value) => setState(() => _widthRatio = value)),
            Divider(),
            ListTile(
                title: Text("Show Labels"),
                trailing: Switch(
                    value: _showLabels,
                    onChanged: (value) => setState(() => _showLabels = value))),
            Divider(),
          ]))),
          appBar: AppBar(title: Text("The Pocket Piano")),
          body: ListView.builder(
            itemCount: 7,
            controller: ScrollController(initialScrollOffset: 1500),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final int i = index * 12;
              return SafeArea(
                child: Stack(children: <Widget>[
                  Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                    _buildKey(24 + i, false),
                    _buildKey(26 + i, false),
                    _buildKey(28 + i, false),
                    _buildKey(29 + i, false),
                    _buildKey(31 + i, false),
                    _buildKey(33 + i, false),
                    _buildKey(35 + i, false),
                  ]),
                  Positioned(
                      left: 0,
                      right: 0,
                      bottom: 100,
                      top: 0,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(width: keyWidth / 2),
                            _buildKey(25 + i, true),
                            _buildKey(27 + i, true),
                            Container(width: keyWidth),
                            _buildKey(30 + i, true),
                            _buildKey(32 + i, true),
                            _buildKey(34 + i, true),
                            Container(width: keyWidth / 2),
                          ])),
                ]),
              );
            },
          )),
    );
  }

  Widget _buildKey(int midi, bool accidental) {
    final pitchName = Pitch.fromMidiNumber(midi).toString();
    final pianoKey = Stack(
      children: <Widget>[
        Semantics(
            button: true,
            hint: pitchName,
            child: Material(
                borderRadius: borderRadius,
                color: accidental ? Colors.black : Colors.white,
                child: InkWell(
                  borderRadius: borderRadius,
                  highlightColor: Colors.grey,
                  onTap: () {},
                  onTapDown: (_) => FlutterMidi.playMidiNote(midi: midi),
                ))),
        Positioned(
            left: 0,
            right: 0,
            bottom: 20,
            child: _showLabels
                ? Text(pitchName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: !accidental ? Colors.black : Colors.white))
                : Container()),
      ],
    );
    if (accidental) {
      return Container(
          width: keyWidth,
          margin: EdgeInsets.symmetric(horizontal: 2),
          padding: EdgeInsets.symmetric(horizontal: keyWidth * .1),
          child: Material(
              elevation: 6,
              borderRadius: borderRadius,
              shadowColor: Color(0x802196F3),
              child: pianoKey));
    }
    return Container(
        width: keyWidth,
        child: pianoKey,
        margin: EdgeInsets.symmetric(horizontal: 2));
  }
}

const BorderRadiusGeometry borderRadius = BorderRadius.only(
    bottomLeft: Radius.circular(9), bottomRight: Radius.circular(9));

```

### Total Dart Code Size: 4918 bytes
