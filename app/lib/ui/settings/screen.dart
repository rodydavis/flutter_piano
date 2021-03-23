import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('General'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.bug_report),
              title: Text('Bug Report'),
              subtitle: Text('File a new Issue'),
              onTap: () => launch(
                'https://github.com/AppleEducate/flutter_piano/issues/new',
              ),
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About'),
              subtitle: Text('App Info and Credits'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SettingsSubView(
                          title: 'About',
                          children: <Widget>[
                            ListTile(
                              leading: Icon(Icons.web),
                              title: Text('Website'),
                              subtitle: Text('rodydavis.com'),
                              onTap: () => launch(
                                'https://rodydavis.com/',
                              ),
                            ),
                            ListTile(
                              leading: Icon(FontAwesomeIcons.twitter),
                              title: Text('Twitter'),
                              subtitle: Text('@rodydavis'),
                              onTap: () => launch(
                                'https://twitter.com/rodydavis',
                              ),
                            ),
                            ListTile(
                              leading: Icon(FontAwesomeIcons.github),
                              title: Text('GitHub'),
                              subtitle: Text('@AppleEducate'),
                              onTap: () => launch(
                                'https://github.com/appleeducate',
                              ),
                            ),
                            // ListTile(
                            //   leading: Icon(FontAwesomeIcons.youtube),
                            //   title: Text('YouTube'),
                            //   subtitle: Text('Rody Davis'),
                            //   onTap: () => launch(
                            //       'https://www.youtube.com/channel/UCqc2elhr0N52GVsyNaWtLvA',
                            //      ),
                            // ),
                            ListTile(
                              leading: Icon(FontAwesomeIcons.instagram),
                              title: Text('Instagram'),
                              subtitle: Text('@rodydavisjr'),
                              onTap: () => launch(
                                'https://www.instagram.com/rodydavisjr/',
                              ),
                            ),
                            ListTile(
                              leading: Icon(FontAwesomeIcons.facebook),
                              title: Text('Facebook'),
                              subtitle: Text('@rodydavis'),
                              onTap: () => launch(
                                'https://www.facebook.com/rodydavis',
                              ),
                            ),
                            ListTile(
                              leading: Icon(FontAwesomeIcons.paintBrush),
                              title: Text('Art Work'),
                              subtitle: Text('by Jessie Davis'),
                              onTap: () => launch(
                                'https://gwenleibryn.wixsite.com/jldportfolio',
                              ),
                            ),
                          ],
                        )));
              },
            ),
            // ListTile(
            //   leading: Icon(Icons.bug_report),
            //   title: Text('Beta'),
            //   subtitle: Text('Join the Beta'),
            //   onTap: () => launch('https://testflight.com/'),
            // ),
          ],
        ),
      ),
    );
  }
}

class SettingsSubView extends StatelessWidget {
  SettingsSubView({
    @required this.children,
    this.title = 'Settings',
  });
  final String title;
  final List<Widget> children;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: Column(children: children),
      ),
    );
  }
}
