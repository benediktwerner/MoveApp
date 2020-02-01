import 'package:flutter/material.dart';

import '../page.dart';
import '../routes.dart';

class MapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Page(
      title: "Lageplan",
      route: Routes.map,
      body: Container(
        child: Center(
          child: Text("Lageplan"),
        ),
      ),
    );
  }
}
