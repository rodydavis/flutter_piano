import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'presentation/view/app.dart';

void main() {
  runApp(const ProviderScope(child: ThePocketPiano()));
}
