import 'package:flutter/material.dart';

import '../page.dart';
import '../routes.dart';

class SpeakersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Page(
      title: "Sprecher & Musiker",
      route: Routes.speakers,
      body: Container(
        child: Center(
          child: Text("Sprecher & Musiker"),
        ),
      ),
    );
  }
}
