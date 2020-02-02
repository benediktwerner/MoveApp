import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../page.dart';
import '../routes.dart';

class NewsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
            itemBuilder: (context, index) => _buildNewsTile(documents[index]),
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

Widget _buildNewsTile(DocumentSnapshot document) {
  return NewsListTile(
    title: document["title"],
    time: formatTime(document["time"]),
    content: document["content"],
  );
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
      alignment: Alignment.topLeft,
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
