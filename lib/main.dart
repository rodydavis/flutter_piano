import 'package:flutter/material.dart';
import 'src/services/injection.dart';
import 'ui/screens/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const ThePocketPiano());
}
