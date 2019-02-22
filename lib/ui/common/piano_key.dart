import 'package:flutter/material.dart';
import 'package:flutter_piano/data/models/app_model.dart';
import 'package:scoped_model/scoped_model.dart';

class PianoKey extends StatelessWidget {
  const PianoKey({
    this.accidental = false,
  });

  final bool accidental;

  @override
  Widget build(BuildContext context) {
    final _app = ScopedModel.of<AppModel>(context, rebuildOnChange: true);

    if (accidental) {
      return Container(
        width: _app.keyWidth,
        margin: EdgeInsets.symmetric(horizontal: 2.0),
        padding: EdgeInsets.symmetric(horizontal: _app.keyWidth * .1),
        child: Material(
          elevation: 6.0,
          borderRadius: BorderRadius.circular(10.0),
          shadowColor: Color(0x802196F3),
          child: InkWell(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      width: _app.keyWidth,
      margin: EdgeInsets.symmetric(horizontal: 2.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10.0),
          bottomRight: Radius.circular(10.0),
        ),
      ),
    );
  }
}
