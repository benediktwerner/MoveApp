import 'package:flutter/material.dart';

import '../page.dart';
import '../routes.dart';

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Page(
      title: "Wilkommen zur Move 2020",
      route: Routes.start,
      body: ListView(
        padding: EdgeInsets.only(left: 32, right: 32, bottom: 32),
        children: [
          SizedBox(
            height: 175,
            child: Center(
              child: Image.asset(
                  "assets/images/logo_move_large_transparent.png",
                  width: 250),
            ),
          ),
          Text("Was ist die Move?", style: Theme.of(context).textTheme.title),
          Divider(),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: "Unter dem Motto "),
                TextSpan(
                    text: "„Komm zur Quelle!“",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text: " – und werde selbst zur sprudelnden Quelle",
                    style: TextStyle(fontStyle: FontStyle.italic)),
                TextSpan(
                    text:
                        "(siehe Joh 4,4-42) – findet vom 12. bis 14. Juni 2020 in Kempten die MOVE statt. Bei der Begegnung mit Jesus am Jakobsbrunnen findet die Frau aus Samarien die Quelle ewigen Lebens. Sie ändert ihr Leben und wird zum Apostel. Die MOVE will ein Fest des Glaubens für alle Altersgruppen sein."),
              ],
            ),
          ),
          SizedBox(height: 32),
          Table(
            children: [
              TableRow(children: [
                _MainButton(Icons.calendar_today, "Programm", Routes.program),
                _MainButton(Icons.map, "Lageplan", Routes.map),
              ]),
              TableRow(children: [
                _MainButton(
                    Icons.people, "Sprecher & Musiker", Routes.speakers),
                _MainButton(Icons.book, "Gebetsbuch", Routes.prayers),
              ]),
              TableRow(children: [
                _MainButton(Icons.announcement, "News", Routes.news),
                _MainButton(Icons.favorite, "Spenden", Routes.donate),
              ]),
            ],
          ),
        ],
      ),
    );
  }
}

class _MainButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final String route;

  _MainButton(this.icon, this.text, this.route);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon),
              SizedBox(height: 8),
              Text(text),
            ],
          ),
        ),
        onTap: () => Navigator.of(context).pushReplacementNamed(route),
      ),
    );
  }
}
