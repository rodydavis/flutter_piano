import 'package:vibrate/vibrate.dart';

class VibrateUtils {
  VibrateUtils._();

  static void light() => Vibrate.feedback(FeedbackType.light);

  static Future<bool> get canVibrate => Vibrate.canVibrate;
}
