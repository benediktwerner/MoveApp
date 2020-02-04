import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../page.dart';
import '../routes.dart';

const double topHeight = 35;
const double leftWidth = 60;
const double cellWidth = 150;
const double cellHeight = 15;

const icons = [
  Icons.looks_one,
  Icons.looks_two,
  Icons.looks_3,
  Icons.looks_4,
  Icons.looks_5,
  Icons.looks_6,
];
const weekdays = [
  "Mo",
  "Di",
  "Mi",
  "Do",
  "Fr",
  "Sa",
  "So",
];

class ProgramPage extends StatefulWidget {
  @override
  _ProgramPageState createState() => _ProgramPageState();
}

class _ProgramPageState extends State<ProgramPage>
    with TickerProviderStateMixin {
  TabController _tabController;
  List<Timestamp> days;
  Map<String, int> tracksToPos;
  List<String> tracks;
  List<bool> trackActive;
  Map<Timestamp, List<Program>> programs;
  List<DocumentSnapshot> programDocs;
  StreamSubscription<QuerySnapshot> _programListener;
  StreamSubscription<QuerySnapshot> _tracksListener;

  @override
  void initState() {
    super.initState();

    _programListener =
        Firestore.instance.collection("program").snapshots().listen((snapshot) {
      setState(() {
        programDocs = snapshot.documents;
        final daysSet = Set<Timestamp>();
        for (var prog in programDocs) {
          daysSet.add(prog.data["day"]);
        }
        days = daysSet.toList();
        days.sort((a, b) => a.seconds - b.seconds);

        if (_tabController == null || _tabController.length != days.length) {
          _tabController = TabController(vsync: this, length: days.length);
          _tabController.addListener(() => setState(() {}));
        }
        _rebuildPrograms();
      });
    });

    _tracksListener =
        Firestore.instance.collection("tracks").snapshots().listen((snapshot) {
      setState(() {
        tracksToPos = {};
        tracks = [];
        for (var track in snapshot.documents) {
          tracksToPos[track.documentID] = track.data["position"];
          tracks.add(track.documentID);
        }
        if (trackActive == null || trackActive.length != tracks.length) {
          trackActive = List.filled(tracks.length, true);
        }
        _rebuildPrograms();
      });
    });
  }

  void _rebuildPrograms() {
    if (programDocs == null || tracks == null) return;

    var sub = 0;
    final filterSub = [];
    for (final isActive in trackActive) {
      if (!isActive) sub++;
      filterSub.add(sub);
    }

    programs = {};
    for (final day in days) programs[day] = [];

    for (final p in programDocs) {
      final ts = <int>[];
      for (final t in p["tracks"]) {
        final tPos = tracksToPos[t];
        if (trackActive[tPos]) {
          ts.add(tPos - filterSub[tPos]);
        }
      }
      if (ts.isNotEmpty) {
        ts.sort();
        programs[p["day"]]
            .add(Program(p["timeStart"], p["timeEnd"], ts, p["name"]));
      }
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _programListener?.cancel();
    _tracksListener?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Page(
      title: "Programm",
      route: Routes.program,
      body: _makeBody(),
      bottomNavigationBar: tracks == null || programs == null || days.length < 2
          ? null
          : BottomNavigationBar(
              items: _makeBottomNavBarItems(),
              currentIndex: _tabController.index,
              selectedItemColor: Colors.redAccent,
              onTap: (index) {
                setState(() => _tabController.animateTo(index));
              },
            ),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          tooltip: "Filter einstellen",
          onPressed: () {
            if (tracks != null) {
              showDialog(
                context: context,
                builder: (context) => FilterDialog(tracks, trackActive),
              ).then((active) {
                if (active != null) {
                  setState(() {
                    trackActive = active;
                    _rebuildPrograms();
                  });
                }
              });
            }
          },
        )
      ],
    );
  }

  Widget _makeBody() {
    if (tracks == null || programs == null) {
      return Center(child: CircularProgressIndicator());
    }

    final now = DateTime.now();
    final today = Timestamp.fromDate(DateTime.utc(
      now.year,
      now.month,
      now.day,
    ));

    final tracksFiltered = <String>[];
    for (var i = 0; i < tracks.length; i++) {
      if (trackActive[i]) tracksFiltered.add(tracks[i]);
    }

    return TabBarView(
      controller: _tabController,
      children: days.map((d) {
        return TimetableView(
          tracksFiltered,
          programs[d],
          showTime: d == today,
        );
      }).toList(),
    );
  }

  List<BottomNavigationBarItem> _makeBottomNavBarItems() {
    final result = <BottomNavigationBarItem>[];
    for (var i = 0; i < days.length; i++) {
      final date = days[i].toDate();
      final weekday = weekdays[date.weekday];
      final day = date.day.toString().padLeft(2, "0");
      final month = date.month.toString().padLeft(2, "0");
      result.add(BottomNavigationBarItem(
        icon: Icon(icons[i]),
        title: Text("$weekday, $day.$month"),
      ));
    }
    return result;
  }
}

class FilterDialog extends StatefulWidget {
  final List<String> tracks;
  final List<bool> initialActive;

  FilterDialog(this.tracks, this.initialActive);

  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  List<bool> active;

  @override
  void initState() {
    super.initState();
    active = widget.initialActive;
  }

  @override
  Widget build(BuildContext context) {
    final singleActive =
        active.map((b) => b ? 1 : 0).reduce((a, b) => a + b) == 1;

    return AlertDialog(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Filter", style: Theme.of(context).textTheme.title),
          Divider(),
          ...Iterable<int>.generate(active.length).map(
            (i) => CheckboxListTile(
              title: Text(widget.tracks[i]),
              value: active[i],
              onChanged: singleActive && active[i]
                  ? null
                  : (val) => setState(() => active[i] = val),
            ),
          ),
        ],
      ),
      actions: [
        FlatButton(
          child: Text("Ok"),
          onPressed: () => Navigator.of(context).pop(active),
        ),
      ],
    );
  }
}

class Program {
  final int start;
  final int end;
  final List<int> tracks;
  final String name;

  Program(this.start, this.end, this.tracks, this.name);
}

class TimetableView extends StatefulWidget {
  final List<String> tracks;
  final List<Program> program;
  final bool showTime;

  TimetableView(this.tracks, this.program, {this.showTime = false});

  @override
  _TimetableViewState createState() => _TimetableViewState();
}

class _TimetableViewState extends State<TimetableView> {
  final ScrollController _mainScrollController = new ScrollController();
  final ScrollController _sideScrollController = new ScrollController();
  Timer _timer;

  @override
  void initState() {
    super.initState();
    if (widget.showTime) {
      _timer = Timer.periodic(Duration(minutes: 5), (_) => setState(() {}));
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var start = 9 * 4;
    var end = 18 * 4;

    for (var prog in widget.program) {
      start = min(start, prog.start);
      end = max(end, prog.end);
    }

    start = (--start) - (start % 4);
    end += 3;
    end += 4 - (end % 4);

    List<Widget> programElements = [
      CustomPaint(
        size: Size(
          leftWidth + cellWidth * widget.tracks.length,
          cellHeight * (end - start),
        ),
        painter: GridPainter(start, end, widget.tracks.length),
      ),
    ];

    for (var prog in widget.program) {
      var currFirstTrack = prog.tracks[0];
      var currLastTrack = currFirstTrack;

      for (var track in prog.tracks.skip(1)) {
        if (track != currLastTrack + 1) {
          programElements.add(ProgramElement(
            start,
            prog.start,
            prog.end,
            currFirstTrack,
            currLastTrack,
            prog.name,
          ));
          currFirstTrack = track;
        }
        currLastTrack = track;
      }

      programElements.add(ProgramElement(
        start,
        prog.start,
        prog.end,
        currFirstTrack,
        currLastTrack,
        prog.name,
      ));
    }

    final now = DateTime.now();
    final quarters = now.hour * 4 + now.minute / 15;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          controller: _sideScrollController,
          physics: NeverScrollableScrollPhysics(),
          child: SizedBox(
            height: topHeight,
            width: leftWidth + cellWidth * widget.tracks.length,
            child: Row(
              children: [
                SizedBox(width: leftWidth),
                ...widget.tracks.map((t) => TrackHeading(t)),
              ],
            ),
          ),
        ),
        Divider(
          height: 1,
        ),
        Expanded(
          child: SingleChildScrollView(
            child: SizedBox(
              height: cellHeight * (end - start),
              child: Stack(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: leftWidth,
                        child: Column(
                          children: List.generate(
                            (end - start) ~/ 4,
                            (i) => TimeHeading(start + i * 4),
                          ),
                        ),
                      ),
                      VerticalDivider(width: 1),
                      Expanded(
                        child: NotificationListener<ScrollNotification>(
                          onNotification: (_) {
                            _sideScrollController
                                .jumpTo(_mainScrollController.offset);
                            return false;
                          },
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            controller: _mainScrollController,
                            child: SizedBox(
                              width: cellWidth * widget.tracks.length,
                              height: cellHeight * (end - start),
                              child: Stack(
                                children: programElements,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  widget.showTime
                      ? Positioned(
                          left: 0,
                          right: 0,
                          top: cellHeight * (quarters - start),
                          child: Divider(
                            color: Colors.redAccent.shade700,
                            thickness: 2,
                            height: 1,
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class TrackHeading extends StatelessWidget {
  final String text;

  TrackHeading(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: cellWidth,
      padding: EdgeInsets.only(bottom: 6),
      alignment: Alignment.bottomCenter,
      child: Text(
        text,
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}

class ProgramElement extends StatelessWidget {
  final int timeOffset;
  final int timeStart;
  final int timeEnd;
  final int trackStart;
  final int trackEnd;
  final String name;

  ProgramElement(
    this.timeOffset,
    this.timeStart,
    this.timeEnd,
    this.trackStart,
    this.trackEnd,
    this.name,
  );

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: cellWidth * trackStart,
      top: cellHeight * (timeStart - timeOffset),
      width: cellWidth * (trackEnd - trackStart + 1),
      height: cellHeight * (timeEnd - timeStart),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          margin: EdgeInsets.all(2),
          padding: EdgeInsets.symmetric(
            horizontal: 8,
            vertical: timeEnd - timeStart > 3 ? 8 : 4,
          ),
          color: Colors.red.shade300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (timeEnd - timeStart > 2)
                Text(
                  "${timeToString(timeStart)} - ${timeToString(timeEnd)}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              Text(name),
            ],
          ),
        ),
      ),
    );
  }
}

class TimeHeading extends StatelessWidget {
  final int time;

  TimeHeading(this.time);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: cellHeight * 4,
      padding: EdgeInsets.only(top: 2),
      alignment: Alignment.topRight,
      child: Text("${time ~/ 4} Uhr  "),
    );
  }
}

String timeToString(time) {
  final hours = time ~/ 4;
  final minutes = ((time % 4) * 15).toString().padLeft(2, "0");
  return "$hours:$minutes";
}

class GridPainter extends CustomPainter {
  final int start;
  final int end;
  final int trackCount;

  GridPainter(this.start, this.end, this.trackCount);

  @override
  void paint(Canvas canvas, Size size) {
    final lightPaint = Paint()..color = Colors.black38;
    final darkPaint = Paint()
      ..color = Colors.black38
      ..strokeWidth = 1;
    final right = cellWidth * trackCount;
    final bottom = cellHeight * (end - start);

    for (var i = 2; i <= end - start; i += 2) {
      final y = i * cellHeight;
      canvas.drawLine(
        Offset(0, y),
        Offset(right, y),
        i % 4 == 0 ? darkPaint : lightPaint,
      );
    }

    for (var i = 0; i <= trackCount; i++) {
      final x = cellWidth * i;
      canvas.drawLine(Offset(x, 0), Offset(x, bottom), lightPaint);
    }
  }

  @override
  bool shouldRepaint(GridPainter old) {
    return start != old.start || end != old.end || trackCount != old.trackCount;
  }
}
