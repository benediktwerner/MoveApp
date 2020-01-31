import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'routes.dart';

class Page extends StatelessWidget {
  final String title;
  final Widget body;

  Page({this.title, this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        elevation: defaultTargetPlatform == TargetPlatform.android ? 5 : 0,
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Container(
                child: Image.asset("assets/images/logo_move.png", width: 250),
              ),
            ),
            ListTile(
              title: Text("Start"),
              leading: Icon(Icons.home),
              onTap: () => navigateTo(Routes.start, context),
            ),
            ListTile(
              title: Text("Programm"),
              leading: Icon(Icons.calendar_today),
              onTap: () => navigateTo(Routes.program, context),
            ),
            ListTile(
              title: Text("Lageplan"),
              leading: Icon(Icons.map),
              onTap: () => navigateTo(Routes.map, context),
            ),
            ListTile(
              title: Text("Gebetsbuch"),
              leading: Icon(Icons.book),
              onTap: () => navigateTo(Routes.prayers, context),
            ),
            ListTile(
              title: Text("Sprecher & Musiker"),
              leading: Icon(Icons.people),
              onTap: () => navigateTo(Routes.speakers, context),
            ),
            ListTile(
              title: Text("News"),
              leading: Icon(Icons.announcement),
              onTap: () => navigateTo(Routes.news, context),
            ),
            ListTile(
              title: Text("Spenden"),
              leading: Icon(Icons.favorite),
              onTap: () => navigateTo(Routes.donate, context),
            ),
            ListTile(
              title: Text("Social Media"),
              leading: Icon(Icons.share),
              onTap: () => navigateTo(Routes.socialMedia, context),
            ),
          ],
        ),
      ),
      body: body,
    );
  }
}

void navigateTo(String route, context) {
  var navigator = Navigator.of(context);
  navigator.pop();
  navigator.pushReplacementNamed(route);
}
