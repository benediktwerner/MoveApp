import 'package:flutter/material.dart';

import '../page.dart';
import '../routes.dart';

class PrayersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Page(
      title: "Gebetsbuch",
      route: Routes.prayers,
      body: Container(
        child: Center(
          child: Text("Gebetsbuch"),
        ),
      ),
    );
  }
}
