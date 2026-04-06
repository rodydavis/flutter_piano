import 'package:flutter_hooks/flutter_hooks.dart';

class VelocityState {
  final int value;
  final void Function(int) adjust;

  VelocityState({
    required this.value,
    required this.adjust,
  });
}

VelocityState useVelocity() {
  final velocity = useState(127);

  void adjust(int adjustment) {
    velocity.value = (velocity.value + adjustment).clamp(0, 127);
  }

  return VelocityState(
    value: velocity.value,
    adjust: adjust,
  );
}
