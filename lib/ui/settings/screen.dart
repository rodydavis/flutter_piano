import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../plugins/url_launcher/url_launcher.dart';

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
              onTap: () => UrlUtils.open(
                  'https://github.com/AppleEducate/flutter_piano/issues/new',
                  name: 'Bug Report'),
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
                              onTap: () => UrlUtils.open(
                                  'https://rodydavis.com/',
                                  name: 'Website'),
                            ),
                            ListTile(
                              leading: Icon(FontAwesomeIcons.twitter),
                              title: Text('Twitter'),
                              subtitle: Text('@rodydavis'),
                              onTap: () => UrlUtils.open(
                                  'https://twitter.com/rodydavis',
                                  name: 'Twitter'),
                            ),
                            ListTile(
                              leading: Icon(FontAwesomeIcons.github),
                              title: Text('GitHub'),
                              subtitle: Text('@AppleEducate'),
                              onTap: () => UrlUtils.open(
                                  'https://github.com/appleeducate',
                                  name: 'Github'),
                            ),
                            // ListTile(
                            //   leading: Icon(FontAwesomeIcons.youtube),
                            //   title: Text('YouTube'),
                            //   subtitle: Text('Rody Davis'),
                            //   onTap: () => UrlUtils.open(
                            //       'https://www.youtube.com/channel/UCqc2elhr0N52GVsyNaWtLvA',
                            //       name: 'YouTube'),
                            // ),
                            ListTile(
                              leading: Icon(FontAwesomeIcons.instagram),
                              title: Text('Instagram'),
                              subtitle: Text('@rodydavisjr'),
                              onTap: () => UrlUtils.open(
                                  'https://www.instagram.com/rodydavisjr/',
                                  name: 'Instagram'),
                            ),
                            ListTile(
                              leading: Icon(FontAwesomeIcons.facebook),
                              title: Text('Facebook'),
                              subtitle: Text('@rodydavis'),
                              onTap: () => UrlUtils.open(
                                  'https://www.facebook.com/rodydavis',
                                  name: 'Facebook'),
                            ),
                            ListTile(
                              leading: Icon(FontAwesomeIcons.paintBrush),
                              title: Text('Art Work'),
                              subtitle: Text('by Jessie Davis'),
                              onTap: () => UrlUtils.open(
                                  'https://gwenleibryn.wixsite.com/jldportfolio',
                                  name: 'Artwork'),
                            ),
                          ],
                        )));
              },
            ),
            // ListTile(
            //   leading: Icon(Icons.bug_report),
            //   title: Text('Beta'),
            //   subtitle: Text('Join the Beta'),
            //   onTap: () => UrlUtils.open('https://testflight.com/'),
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
