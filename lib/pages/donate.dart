import 'package:flutter/material.dart';

import '../page.dart';
import '../routes.dart';

class DonatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Page(
      title: "Spenden",
      route: Routes.donate,
      body: Container(
        child: Center(
          child: Text("Spenden"),
        ),
      ),
    );
  }
}
