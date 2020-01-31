import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Move 2020',
      home: Scaffold(
        appBar: AppBar(
          title: Text("Move 2020"),
        ),
        body: Center(
          child: Text(
            'Move 2020 App',
          ),
        ),
      ),
    );
  }
}
