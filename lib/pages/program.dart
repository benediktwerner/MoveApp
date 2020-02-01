import 'package:flutter/material.dart';

import '../page.dart';
import '../routes.dart';

class ProgramPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Page(
      title: "Programm",
      route: Routes.program,
      body: Container(
        child: Center(
          child: Text("Programm"),
        ),
      ),
    );
  }
}
