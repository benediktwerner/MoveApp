import 'package:flutter/material.dart';

import 'page.dart';
import 'pages/program.dart';
import 'pages/start.dart';
import 'pages/map.dart';
import 'pages/prayers.dart';
import 'pages/speakers.dart';
import 'pages/news.dart';
import 'pages/donate.dart';
import 'pages/social_media.dart';
import 'routes.dart';

void main() {
  runApp(
    MaterialApp(
      title: "Move 2020",
      theme: ThemeData(primarySwatch: Colors.red),
      initialRoute: Routes.start,
      onGenerateRoute: (settings) => PageRouteBuilder(
        pageBuilder: (_, __, ___) {
          switch (settings.name) {
            case Routes.start:
              return StartPage();
            case Routes.program:
              return ProgramPage();
            case Routes.map:
              return MapPage();
            case Routes.prayers:
              return PrayersPage();
            case Routes.speakers:
              return SpeakersPage();
            case Routes.news:
              return NewsPage();
            case Routes.donate:
              return DonatePage();
            case Routes.socialMedia:
              return SocialMediaPage();
            default:
              return Page(
                title: "Fehler",
                route: null,
                body: Container(
                  child: Center(
                    child: Text("Seite nicht gefunden"),
                  ),
                ),
              );
          }
        },
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
      ),
    ),
  );
}
