import 'package:flutter/material.dart';

import '../page.dart';

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Page(
      title: "Move 2020",
      body: Container(
        child: Center(
          child: Text("Start"),
        ),
      ),
    );
  }
}
