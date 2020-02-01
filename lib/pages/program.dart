import 'package:flutter/material.dart';

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

class ProgramPage extends StatefulWidget {
  @override
  _ProgramPageState createState() => _ProgramPageState();
}

class _ProgramPageState extends State<ProgramPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Page(
      title: "Programm",
      route: Routes.program,
      body: TabBarView(
          controller: _tabController,
          children: [TimetableView(), TimetableView(), TimetableView()]),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.looks_one),
            title: Text("Fr, 12.06."),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.looks_two),
            title: Text("Sa, 13.06."),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.looks_3),
            title: Text("So, 14.06."),
          ),
        ],
        currentIndex: _tabController.index,
        selectedItemColor: Colors.redAccent,
        onTap: (index) {
          _tabController.animateTo(index);
          setState(() {});
        },
      ),
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

final programs = [
  Program(7 * 4, 10 * 4, [0, 1, 2], "Frühstück"),
  Program(10 * 4 + 1, 12 * 4, [0], "Wandern"),
  Program(10 * 4, 13 * 4, [1, 2], "Kino"),
  Program(14 * 4, 15 * 4, [0, 2], "Test"),
];

final tracks = [
  "Erwachsene",
  "GetStrong",
  "NET",
];

class TimetableView extends StatelessWidget {
  final ScrollController _mainScrollController = new ScrollController();
  final ScrollController _sideScrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    var start = 9 * 4;
    var end = 18 * 4;

    for (var prog in programs) {
      if (prog.start < start) start = prog.start;
      if (prog.end > end) end = prog.end;
    }

    start = (--start) - (start % 4);
    end += 3;
    end += 4 - (end % 4);

    List<Widget> programElements = [
      CustomPaint(
        size: Size(
          leftWidth + cellWidth * tracks.length,
          cellHeight * (end - start),
        ),
        painter: GridPainter(start, end, tracks.length),
      ),
    ];

    for (var prog in programs) {
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

    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          controller: _sideScrollController,
          physics: NeverScrollableScrollPhysics(),
          child: SizedBox(
            height: topHeight,
            width: leftWidth + cellWidth * tracks.length,
            child: Row(
              children: [
                SizedBox(width: leftWidth),
                ...tracks.map((t) => TrackHeading(t)),
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
              child: Row(
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
                          width: cellWidth * tracks.length,
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
          padding: EdgeInsets.all(8),
          color: Colors.red.shade300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
