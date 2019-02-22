# flutter_piano

A Crossplatform Midi Piano built with Flutter.io.

This application runs on both iOS and Android. This uses a custom CrossPlatform Midi Synth I built for a Flutter plugin that uses .SF2 sound font files located in the assets folder that can pointed to in the pubspec.yaml.

```
 assets:
   - assets/sounds/Piano.SF2

```
There are Semantics included for the visually impaired. All keys show up as buttons and have the pitch name of the midi note not just the number.

## Getting Started

This application only runs in landscape mode, orientation is set in the AndroidManifest.xml and in the Runner.xcworspace settings.

1. Make sure to turn your volume up and unmute phone (the application will try to unmute the device but it can be overriden).
2. Tap on any note to play!
3. Scroll in either direction to change octaves
4. Polyphony is supported with multiple fingers

## Configuration

Optionally the key width can be changed in the settings for adjusting for densitity.

The key labels can also be turned off if you want a more minimal look.

You can change the Piano.sf2 file to any sound font file for playing different instruments. 

Total Dart Code Size: 5039 bytes

## Screenshots

![alt-text-1](https://github.com/AppleEducate/flutter_piano/blob/master/screenshots/ios_1.PNG) 
![alt-text-2](https://github.com/AppleEducate/flutter_piano/blob/master/screenshots/android_1.jpg)
