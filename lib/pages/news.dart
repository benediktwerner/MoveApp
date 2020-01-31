import 'package:flutter/material.dart';

import '../page.dart';

class NewsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Page(
      title: "News",
      body: ListView(
        children: <Widget>[
          NewsListTile(
            title: "Something happened!",
            time: "Gestern, 20:00",
            content:
                "Lorem ipsum dolores and some more stuff irgendwas so das hier halt was steht.",
          ),
          NewsListTile(
            title: "Irgendwas anderes!!!",
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

  NewsListTile({this.title, this.time, this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(time),
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => NewsDetails(title, time, content))),
      ),
    );
  }
}

class NewsDetails extends StatelessWidget {
  final String title;
  final String time;
  final String content;

  NewsDetails(this.title, this.time, this.content);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("News")),
      body: Container(
        child: Card(
          margin: EdgeInsets.all(16),
          child: Padding(
            padding: EdgeInsets.all(16).add(EdgeInsets.only(bottom: 8)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  time,
                  style: TextStyle(color: Colors.grey.shade500),
                ),
                SizedBox(height: 16),
                Text(content),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
