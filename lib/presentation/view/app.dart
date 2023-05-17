import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_review/app_review.dart';

import '../../data/source/settings.dart';
import 'home.dart';

class ThePocketPiano extends ConsumerStatefulWidget {
  const ThePocketPiano({super.key});

  @override
  ConsumerState<ThePocketPiano> createState() => _ThePocketPianoState();
}

class _ThePocketPianoState extends ConsumerState<ThePocketPiano> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    ref.read(loadSettings);
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 5), () {
      if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
        AppReview.requestReview.then((onValue) {
          debugPrint('app_review: $onValue');
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = ref.watch(themeColorProvider);
    final mode = ref.watch(themeModeProvider);
    const appBarTheme = AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'The Pocket Piano',
      theme: ThemeData.light(useMaterial3: true).copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: color,
          brightness: Brightness.light,
        ),
        appBarTheme: appBarTheme,
      ),
      darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: color,
          brightness: Brightness.dark,
        ),
        appBarTheme: appBarTheme,
      ),
      themeMode: mode,
      home: const Home(),
    );
  }
}
