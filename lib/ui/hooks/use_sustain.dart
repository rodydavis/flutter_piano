import 'package:flutter_hooks/flutter_hooks.dart';
import '../../src/services/player.dart';
import '../../src/services/injection.dart';

class SustainState {
  final bool value;
  final void Function(bool) setSustain;

  SustainState({
    required this.value,
    required this.setSustain,
  });
}

SustainState useSustain() {
  final sustain = useState(false);
  final player = getIt<PlayerService>();

  void setSustain(bool val) {
    sustain.value = val;
    if (!val) {
      player.stopSustain();
    }
  }

  return SustainState(
    value: sustain.value,
    setSustain: setSustain,
  );
}
