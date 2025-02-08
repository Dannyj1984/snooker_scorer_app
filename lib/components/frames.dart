import 'package:flutter/material.dart';
import 'package:snooker_scorer/model/frame.dart';
import 'package:snooker_scorer/model/frame_score.dart';
import 'package:snooker_scorer/model/game_date.dart';

class FramesForDate extends StatefulWidget {
  final List<Frame> frames;
  final GameDate gameDate;

  const FramesForDate(
      {super.key, required this.frames, required this.gameDate});

  @override
  _FramesForDateState createState() => _FramesForDateState();
}

class _FramesForDateState extends State<FramesForDate> {
  final Map<int, bool> _showBreaksMap = {};

  showBreaks(int frame) {
    setState(() {
      if (_showBreaksMap[frame] == null) _showBreaksMap[frame] = false;
      _showBreaksMap[frame] = !_showBreaksMap[frame]!;
    });
  }

  _goToFrameDetails(Frame frame, GameDate gameDate) {
    Navigator.pushNamed(
      context,
      '/frameDetails',
      arguments: {'frame': frame, 'gameDate': gameDate},
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Frame> frames = widget.frames;

    return ListView.builder(
        itemCount: frames.length,
        itemBuilder: (context, index) {
          Frame frame = frames[index];
          return Column(children: [
            const SizedBox(height: 20),
            Text('Frame ${index + 1} ${frame.inProgress ? 'In Progress' : ''}',
                style: const TextStyle(fontSize: 20)),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () => frame.inProgress
                  ? _goToFrameDetails(frame, widget.gameDate)
                  : showBreaks(index + 1),
              child: Container(
                color: Colors.transparent, // Make the container transparent
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('${frame.playerOneScore}',
                        style: const TextStyle(fontSize: 30)),
                    Text('${frame.playerTwoScore}',
                        style: const TextStyle(fontSize: 30)),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: _showBreaksMap[index + 1] ?? false,
              child: showBreaksSection(frame),
            ),
            const Divider()
          ]);
        });
  }

  Widget showBreaksSection(Frame frame) {
    final p1Breaks = frame.playerOneBreakData ?? [];
    final p2Breaks = frame.playerTwoBreakData ?? [];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: p1Breaks!
              .map((breakScore) => Text(breakScore['points'].toString()))
              .toList(),
        ),
        Column(
          children: p2Breaks!
              .map((breakScore) => Text(breakScore['points'].toString()))
              .toList(),
        ),
      ],
    );
  }
}
