import 'package:flutter/material.dart';

import 'ui/home/screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Piano',
      theme: ThemeData.dark(),
      home: HomeScreen(),
    );
  }
}
