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
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: "Suchen",
            onPressed: () async {
              final route = await showSearch(
                  context: context, delegate: AppSearchDelegate());
              if (route != null) {
                Navigator.of(context).pushNamed(route);
              }
            },
          )
        ],
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
                  "assets/images/logo_move_transparent.png",
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

class AppSearchDelegate extends SearchDelegate {
  bool showingResults = false;

  AppSearchDelegate() : super(searchFieldLabel: "Suchen");

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          if (showingResults) {
            showingResults = false;
            showSuggestions(context);
          } else {
            query = "";
          }
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    showingResults = true;
    if (query == "nix") {
      return Center(
        child: Text("Die Suche ergab keine Treffer."),
      );
    }
    return ListView(
      children: [
        ListTile(
          title: Text("Sprecher"),
          subtitle: Text.rich(TextSpan(children: [
            TextSpan(text: "Bla bla.. "),
            TextSpan(
              text: query,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
            ),
            TextSpan(text: " bla")
          ])),
          onTap: () => close(context, Routes.speakers),
        ),
        ListTile(
          title: Text("Spenden"),
          subtitle: Text.rich(TextSpan(children: [
            TextSpan(text: "Bla "),
            TextSpan(
              text: query,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
            ),
            TextSpan(text: " blabla .. bla")
          ])),
          onTap: () => close(context, Routes.donate),
        ),
      ],
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: store and show previous searches
    if (query.isEmpty) {
      // TODO: use ListView.builder
      return ListView(
        children: [
          ListTile(
            title: Text("Sprecher"),
            onTap: () {
              query = "Sprecher";
              showResults(context);
            },
          ),
          ListTile(
            title: Text("Spenden"),
            onTap: () {
              query = "Spenden";
              showResults(context);
            },
          ),
        ],
      );
    }
    return ListView(
      children: [
        ListTile(
          title: Text("Sprecher"),
          subtitle: Text.rich(TextSpan(children: [
            TextSpan(text: "Bla bla.. "),
            TextSpan(
              text: query,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
            ),
            TextSpan(text: " bla")
          ])),
          onTap: () => close(context, Routes.speakers),
        ),
        ListTile(
          title: Text("Spenden"),
          subtitle: Text.rich(TextSpan(children: [
            TextSpan(text: "Bla "),
            TextSpan(
              text: query,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
            ),
            TextSpan(text: " blabla .. bla")
          ])),
          onTap: () => close(context, Routes.donate),
        ),
      ],
    );
  }
}
