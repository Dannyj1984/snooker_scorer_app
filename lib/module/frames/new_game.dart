import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:snooker_scorer/components/frames.dart';
import 'package:snooker_scorer/model/frame.dart';
import 'package:snooker_scorer/model/game_date.dart';
import 'package:snooker_scorer/model/user.dart';

class NewGameDate extends StatefulWidget {
  const NewGameDate({super.key, required this.title, required this.game});

  final String title;
  final GameDate game;

  @override
  State<NewGameDate> createState() => _NewGameDateState();
}

class _NewGameDateState extends State<NewGameDate> {
  String? _selectedUserOne;
  String? _selectedUserTwo;
  late GameDate _selectedGame;

  @override
  void initState() {
    super.initState();
    _selectedUserOne = "Danny";
    _selectedUserTwo = "Andy";
    _selectedGame = widget.game;
  }

  Frame _generateNewFrame(bool inProgress) {
    return Frame(
      frame: 1,
      inProgress: inProgress,
      playerOne: _selectedUserOne!,
      playerTwo: _selectedUserTwo!,
      playerOneScore: 0,
      playerTwoScore: 0,
    );
  }

  void _addFrame() async {
    try {
      final frames = _selectedGame.frames ?? [];
      final newFrame = _generateNewFrame(true);
      setState(() {
        frames.add(newFrame);
      });
      DocumentReference frameRef = await FirebaseFirestore.instance
          .collection('frames')
          .add(newFrame.toJson());
      newFrame.docReference = frameRef.id;
      await FirebaseFirestore.instance
          .collection('games')
          .doc(_selectedGame.documentId)
          .update({
        'frameIds': FieldValue.arrayUnion([frameRef.id])
      });
    } catch (e) {
      debugPrint('failed to update $e');
    }
  }

  List<int> _getFramesWon(String id) {
    final frames = _selectedGame.frames ?? [];
    if (frames.isEmpty) {
      return [0, 0];
    }
    var playerOneWins = 0;
    var playerTwoWins = 0;

    for (var frame in frames) {
      if ((frame.playerOneScore ?? 0) > (frame.playerTwoScore ?? 0)) {
        playerOneWins++;
      } else {
        playerTwoWins++;
      }
    }
    return [playerOneWins, playerTwoWins];
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(height: 20),
          if (width < 600)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${_selectedGame.date.substring(8, 10)}-${_selectedGame.date.substring(5, 7)}-${_selectedGame.date.substring(0, 4)}',
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                '$_selectedUserOne',
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(
                width: 20,
              ),
              Text(
                '${_getFramesWon(_selectedUserOne ?? '1').first}',
                style: const TextStyle(fontSize: 20),
              ),
              if (width >= 600)
                Text(
                  '${_selectedGame.date.substring(8, 10)}-${_selectedGame.date.substring(5, 7)}-${_selectedGame.date.substring(0, 4)}',
                  style: const TextStyle(fontSize: 20),
                ),
              Text('${_getFramesWon(_selectedUserTwo ?? '2').last}',
                  style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 20),
              Text(
                '$_selectedUserTwo ',
                style: const TextStyle(fontSize: 20),
              )
            ],
          ),
          Expanded(
            child: FramesForDate(
              frames: _selectedGame.frames ?? [],
              gameDate: _selectedGame,
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('games')
                    .doc(_selectedGame.documentId)
                    .update({'completed': true});
                Navigator.pop(context);
              },
              child: const Text('Complete Session'),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addFrame,
        tooltip: 'Add Frame',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget frameDetails(double width) {
    return Column(children: [
      if (width < 600)
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${_selectedGame.date.substring(8, 10)}-${_selectedGame.date.substring(5, 7)}-${_selectedGame.date.substring(0, 4)}',
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            '$_selectedUserOne',
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(
            width: 20,
          ),
          Text(
            '${_getFramesWon(_selectedUserOne ?? '1').first}',
            style: const TextStyle(fontSize: 20),
          ),
          if (width >= 600)
            Text(
              '${_selectedGame.date.substring(8, 10)}-${_selectedGame.date.substring(5, 7)}-${_selectedGame.date.substring(0, 4)}',
              style: const TextStyle(fontSize: 20),
            ),
          Text('${_getFramesWon(_selectedUserTwo ?? '2').last}',
              style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 20),
          Text(
            '$_selectedUserTwo ',
            style: const TextStyle(fontSize: 20),
          )
        ],
      ),
      Expanded(
          child: FramesForDate(
        frames: _selectedGame.frames ?? [],
        gameDate: _selectedGame,
      ))
    ]);
  }
}
