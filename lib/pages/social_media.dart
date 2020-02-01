import 'package:flutter/material.dart';

import '../page.dart';
import '../routes.dart';

class SocialMediaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Page(
      title: "Social Media",
      route: Routes.socialMedia,
      body: Container(
        child: Center(
          child: Text("Social Media"),
        ),
      ),
    );
  }
}
