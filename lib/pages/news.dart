import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../page.dart';
import '../routes.dart';

class NewsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final News arg = ModalRoute.of(context).settings.arguments;
    if (arg != null) arg.showInDialog(context);

    return Page(
      title: "News",
      route: Routes.news,
      body: StreamBuilder(
        stream: Firestore.instance.collection("news").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final List<DocumentSnapshot> documents = snapshot.data.documents;
          documents.sort((a, b) => b["time"].compareTo(a["time"]));

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) =>
                NewsListTile(News.fromDoc(documents[index])),
          );
        },
      ),
    );
  }
}

String formatTime(Timestamp timestamp) {
  final DateTime time = timestamp.toDate();
  final now = DateTime.now();
  final daysDiff = now.difference(time).inDays;

  final timeString = ", ${time.hour}:${time.minute.toString().padLeft(2, '0')}";

  if (now.year == time.year) {
    if (now.month == time.month && now.day == time.day) {
      return "Heute" + timeString;
    } else if (daysDiff < 2) {
      return "Gestern" + timeString;
    }
  }

  return "vor $daysDiff Tagen" + timeString;
}

class NewsListTile extends StatelessWidget {
  final News news;

  NewsListTile(this.news);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: news.title,
      transitionOnUserGestures: true,
      flightShuttleBuilder: (context, anim, dir, fromContext, toContext) =>
          NewsCard(news, anim),
      child: NewsCard(
        news,
        AlwaysStoppedAnimation(0),
      ),
    );
  }
}

class NewsCard extends AnimatedWidget {
  static final _opacityTween = Tween<double>(begin: 0, end: 1);

  final News news;

  NewsCard(
    this.news, [
    Animation<double> animation,
  ]) : super(listenable: animation);

  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;

    return SingleChildScrollView(
      child: Card(
        child: Column(
          children: [
            ListTile(
              title: Text(news.title),
              subtitle: Text(news.time),
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
      alignment: Alignment.topLeft,
      child: Opacity(
        opacity: _opacityTween.evaluate(animation),
        child: Text(news.content),
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
                  tag: news.title,
                  transitionOnUserGestures: true,
                  flightShuttleBuilder:
                      (context, anim, dir, fromContext, toContext) => NewsCard(
                    news,
                    anim,
                  ),
                  child: NewsCard(
                    news,
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

class News {
  final String title;
  final String time;
  final String content;

  News.fromNotification(Map<String, dynamic> message)
      : title = message["data"]["title"],
        time = message["data"]["time"],
        content = message["data"]["content"];

  News.fromDoc(DocumentSnapshot doc)
      : title = doc["title"],
        time = formatTime(doc["time"]),
        content = doc["content"];

  void showInDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: Theme.of(context).textTheme.title),
            Divider(),
            Text(content),
          ],
        ),
        actions: [
          FlatButton(
            child: Text("Ok"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  @override
  String toString() {
    return "($title, $content, $time)";
  }
}
