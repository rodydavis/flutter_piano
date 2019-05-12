import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;
import 'package:flutter/services.dart';
import 'package:flutter_midi/flutter_midi.dart';
import 'package:localstorage/localstorage.dart';
import 'package:persist_theme/persist_theme.dart';
import 'package:scoped_model/scoped_model.dart';
import 'ui/home/screen.dart';

void main() {
  _setTargetPlatformForDesktop();
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
  // final ThemeModel _model = ThemeModel(customLightTheme: ThemeData.dark());
  // final LocalStorage _storage = new LocalStorage('app_settings');

  @override
  void initState() {
    try {
      // _model.init();
      // _storage.ready.then((_) {
      //   final bool _fresh = _storage.getItem("fresh_install");
      //   if (_fresh ?? true) {
      //     _model.changeDarkMode(true);
      //     _storage.setItem('fresh_install', false);
      //   }
      // });
    } catch (e) {
      print("Error Loading Theme: $e");
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // return ScopedModel<ThemeModel>(
    //     model: _model,
    //     child: new ScopedModelDescendant<ThemeModel>(
    //         builder: (context, child, model) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'The Pocket Piano',
      theme: ThemeData.dark(),
      home: HomeScreen(),
    );
    // }));
  }
}

/// If the current platform is desktop, override the default platform to
/// a supported platform (iOS for macOS, Android for Linux and Windows).
/// Otherwise, do nothing.
void _setTargetPlatformForDesktop() {
  TargetPlatform targetPlatform;
  if (Platform.isMacOS) {
    targetPlatform = TargetPlatform.iOS;
  } else if (Platform.isLinux || Platform.isWindows) {
    targetPlatform = TargetPlatform.android;
  }
  if (targetPlatform != null) {
    debugDefaultTargetPlatformOverride = targetPlatform;
  }
}
