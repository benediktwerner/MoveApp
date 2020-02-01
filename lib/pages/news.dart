import 'package:flutter/material.dart';

import '../page.dart';
import '../routes.dart';

class NewsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Page(
      title: "News",
      route: Routes.news,
      body: ListView(
        children: <Widget>[
          NewsListTile(
            title: "Something happened!",
            time: "Gestern, 20:00",
            content:
                "Lorem ipsum dolores and some more stuff irgendwas so das hier halt was steht.",
          ),
          NewsListTile(
            title: "Irgendwas dsf!!!",
            time: "Vorgestern, 13:00",
            content:
                "Lorem ipsum dolores and some more stuff irgendwas so das hier halt was steht. Lorem ipsum dolores and some more stuff irgendwas so das hier halt was steht. Lorem ipsum dolores and some more stuff irgendwas so das hier halt was steht. Lorem ipsum dolores and some more stuff irgendwas so das hier halt was steht. Lorem ipsum dolores and some more stuff irgendwas so das hier halt was steht. Lorem ipsum dolores and some more stuff irgendwas so das hier halt was steht. Lorem ipsum dolores and some more stuff irgendwas so das hier halt was steht. Lorem ipsum dolores and some more stuff irgendwas so das hier halt was steht. Lorem ipsum dolores and some more stuff irgendwas so das hier halt was steht. Lorem ipsum dolores and some more stuff irgendwas so das hier halt was steht. Lorem ipsum dolores and some more stuff irgendwas so das hier halt was steht. Lorem ipsum dolores and some more stuff irgendwas so das hier halt was steht. Lorem ipsum dolores and some more stuff irgendwas so das hier halt was steht. Lorem ipsum dolores and some more stuff irgendwas so das hier halt was steht. Lorem ipsum dolores and some more stuff irgendwas so das hier halt was steht. Lorem ipsum dolores and some more stuff irgendwas so das hier halt was steht. Lorem ipsum dolores and some more stuff irgendwas so das hier halt was steht. Lorem ipsum dolores and some more stuff irgendwas so das hier halt was steht. Lorem ipsum dolores and some more stuff irgendwas so das hier halt was steht. Lorem ipsum dolores and some more stuff irgendwas so das hier halt was steht. Lorem ipsum dolores and some more stuff irgendwas so das hier halt was steht. Lorem ipsum dolores and some more stuff irgendwas so das hier halt was steht. Lorem ipsum dolores and some more stuff irgendwas so das hier halt was steht. Lorem ipsum dolores and some more stuff irgendwas so das hier halt was steht. Lorem ipsum dolores and some more stuff irgendwas so das hier halt was steht. Lorem ipsum dolores and some more stuff irgendwas so das hier halt was steht. Lorem ipsum dolores and some more stuff irgendwas so das hier halt was steht. Lorem ipsum dolores and some more stuff irgendwas so das hier halt was steht. Lorem ipsum dolores and some more stuff irgendwas so das hier halt was steht. Lorem ipsum dolores and some more stuff irgendwas so das hier halt was steht. Lorem ipsum dolores and some more stuff irgendwas so das hier halt was steht. Lorem ipsum dolores and some more stuff irgendwas so das hier halt was steht.",
          ),
          NewsListTile(
            title: "Irgendwas anderes!!!",
            time: "Vorgestern, 13:00",
            content:
                "Lorem ipsum dolores and some more stuff irgendwas so das hier halt was steht.",
          ),
          NewsListTile(
            title: "Irgendwas fff!!!",
            time: "Vorgestern, 13:00",
            content:
                "Lorem ipsum dolores and some more stuff irgendwas so das hier halt was steht.",
          ),
          NewsListTile(
            title: "Irgendwas xxx!!!",
            time: "Vorgestern, 13:00",
            content:
                "Lorem ipsum dolores and some more stuff irgendwas so das hier halt was steht.",
          ),
        ],
      ),
    );
  }
}

class NewsListTile extends StatelessWidget {
  final String title;
  final String time;
  final String content;

  NewsListTile({
    @required this.title,
    @required this.time,
    @required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: title,
      transitionOnUserGestures: true,
      flightShuttleBuilder: (context, anim, dir, fromContext, toContext) =>
          NewsCard(title, time, content, anim),
      child: NewsCard(
        title,
        time,
        content,
        AlwaysStoppedAnimation(0),
      ),
    );
  }
}

class NewsCard extends AnimatedWidget {
  static final _opacityTween = Tween<double>(begin: 0, end: 1);

  final String title;
  final String time;
  final String content;

  NewsCard(
    this.title,
    this.time,
    this.content, [
    Animation<double> animation,
  ]) : super(listenable: animation);

  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;

    return SingleChildScrollView(
      child: Card(
        child: Column(
          children: [
            ListTile(
              title: Text(title),
              subtitle: Text(time),
              onTap: createOnTapHandler(context),
            ),
            _content(animation),
          ],
        ),
      ),
    );
  }

  Widget _content(animation) {
    if (animation.value == 0) {
      return SizedBox(height: 0);
    }
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, bottom: 32),
      child: Opacity(
        opacity: _opacityTween.evaluate(animation),
        child: Text(content),
      ),
    );
  }

  Function createOnTapHandler(context) {
    if ((listenable as Animation<double>).value == 0) {
      return () => Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => Scaffold(
                appBar: AppBar(
                  title: Text("News"),
                ),
                body: Hero(
                  tag: title,
                  transitionOnUserGestures: true,
                  flightShuttleBuilder:
                      (context, anim, dir, fromContext, toContext) => NewsCard(
                    title,
                    time,
                    content,
                    anim,
                  ),
                  child: NewsCard(
                    title,
                    time,
                    content,
                    AlwaysStoppedAnimation(1),
                  ),
                ),
              ),
              transitionsBuilder: (_, anim, __, child) =>
                  FadeTransition(opacity: anim, child: child),
            ),
          );
    } else {
      return null;
    }
  }
}
