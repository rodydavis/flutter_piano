import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../data/models/app_model.dart';
import '../app/app_drawer.dart';
import '../common/piano/keys.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AppModel _model = AppModel();
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<AppModel>(
      model: _model,
      child: Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          centerTitle: true,
          title: Text("Flutter Piano"),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.radio_button_checked,
                color: Colors.red,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(
                Icons.play_arrow,
              ),
              onPressed: () {},
            ),
          ],
        ),
        body: PianoKeys(),
      ),
    );
  }
}
