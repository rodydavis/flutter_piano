import 'package:scoped_model/scoped_model.dart';

class AppModel extends Model {
  double _keyWidth = 80.0;
  double get keyWidth => _keyWidth;

  double get accidentalKeyWidth => _keyWidth * 0.5;

  void changeKeyWidth(double value) {
    _keyWidth = value;
    notifyListeners();
  }
}
