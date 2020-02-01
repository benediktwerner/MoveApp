import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'routes.dart';

class Page extends StatelessWidget {
  final String title;
  final String route;
  final Widget body;
  final Widget bottomNavigationBar;

  Page({this.title, this.route, this.body, this.bottomNavigationBar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        elevation: defaultTargetPlatform == TargetPlatform.android ? 5 : 0,
      ),
      bottomNavigationBar: bottomNavigationBar,
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Container(
                alignment: Alignment.center,
                child: Image.asset(
                  "assets/images/logo_move_large_transparent.png",
                  width: 250,
                ),
              ),
            ),
            DrawerListTile("Start", Icons.home, Routes.start, route),
            DrawerListTile(
                "Programm", Icons.calendar_today, Routes.program, route),
            DrawerListTile("Lageplan", Icons.map, Routes.map, route),
            DrawerListTile("Gebetsbuch", Icons.book, Routes.prayers, route),
            DrawerListTile(
                "Sprecher & Musiker", Icons.people, Routes.speakers, route),
            DrawerListTile("News", Icons.announcement, Routes.news, route),
            DrawerListTile("Spenden", Icons.favorite, Routes.donate, route),
            DrawerListTile(
                "Social Media", Icons.share, Routes.socialMedia, route),
          ],
        ),
      ),
      body: body,
    );
  }
}

class DrawerListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final String route;
  final String activeRoute;

  DrawerListTile(this.title, this.icon, this.route, this.activeRoute);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      selected: route == activeRoute,
      onTap: () => navigateTo(route, context),
    );
  }
}

void navigateTo(String route, context) {
  var navigator = Navigator.of(context);
  navigator.pop();
  navigator.pushReplacementNamed(route);
}
