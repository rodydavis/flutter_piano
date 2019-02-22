import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text(
                  "Piano Controls",
                  style: Theme.of(context).textTheme.headline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
