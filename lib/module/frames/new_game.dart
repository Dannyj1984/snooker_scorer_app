import 'package:flutter/material.dart';
import 'package:snooker_scorer/components/frames.dart';
import 'package:snooker_scorer/module/frames/foul_form.dart';
import 'package:snooker_scorer/components/user_selector.dart';
import 'package:snooker_scorer/model/frame.dart';
import 'package:snooker_scorer/model/frame_score.dart';
import 'package:snooker_scorer/model/game_date.dart';
import 'package:snooker_scorer/model/user.dart';
import 'package:snooker_scorer/test_data.dart';

class NewGameDate extends StatefulWidget {
  const NewGameDate({super.key, required this.title});

  final String title;

  @override
  State<NewGameDate> createState() => _NewGameDateState();
}

class _NewGameDateState extends State<NewGameDate> {
  User? _selectedUserOne;
  User? _selectedUserTwo;
  List<User> _users = [];
  bool _showSelector = false;
  GameDate? _selectedGame;

  @override
  void initState() {
    super.initState();
    _users = FakeData.getUsers();
    _selectedUserOne = _users[0];
    _selectedUserTwo = _users[1];
    _selectedGame = FakeData.getDates().first;
  }

  // void _openAddFrameOverlay() {
  //   showModalBottomSheet(
  //       isScrollControlled: true,
  //       context: context,
  //       builder: (ctx) {
  //         return NewFrameDetails(onAddFrame: _addNewFrame);
  //       });
  // }

  void _addNewFrame() {
    setState(() {
      final newFrame = _generateNewFrame(true);
      _selectedGame!.frames!.add(newFrame);
    });
  }

  Frame _generateNewFrame(bool inProgress) {
    return Frame(
        id: 1,
        frame: 1,
        inProgress: inProgress,
        scores: FrameScore(
          playerOne: _selectedUserOne!.id,
          playerTwo: _selectedUserTwo!.id,
        ));
  }

  void _addFrame() {
    setState(() {
      _addNewFrame();
    });
  }

  void _onUserSelected(User user, int player) {
    setState(() {
      if (player == 1) {
        _selectedUserOne = user;
      } else {
        _selectedUserTwo = user;
      }
    });
  }

  void _selector() {
    setState(() {
      _showSelector = !_showSelector;
    });
  }

  List<int> _getFramesWon(int id) {
    final frames = _selectedGame!.frames ?? [];
    if (frames.isEmpty) {
      return [0, 0];
    }
    var playerOneWins = 0;
    var playerTwoWins = 0;

    for (var frame in frames) {
      if ((frame.scores!.playerOneScore ?? 0) >
          (frame.scores!.playerTwoScore ?? 0)) {
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
          Row(
            children: [
              TextButton(
                onPressed: _selector,
                child: const Text('Select Players'),
              )
            ],
          ),
          if (_showSelector)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                UserSelector(
                    users: _users, onUserSelected: _onUserSelected, player: 1),
                UserSelector(
                    users: _users, onUserSelected: _onUserSelected, player: 2),
              ],
            ),
          const SizedBox(height: 20),
          if (width < 600)
            const Padding(
              padding: EdgeInsets.only(bottom: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Date: 18-01-2025',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                '${_selectedUserOne?.name}',
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(
                width: 20,
              ),
              Text(
                '${_getFramesWon(_selectedUserOne?.id ?? 1).first}',
                style: const TextStyle(fontSize: 20),
              ),
              if (width >= 600)
                const Text(
                  'Date: 18-01-2025',
                  style: TextStyle(fontSize: 20),
                ),
              Text('${_getFramesWon(_selectedUserTwo?.id ?? 2).last}',
                  style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 20),
              Text(
                '${_selectedUserTwo?.name} ',
                style: const TextStyle(fontSize: 20),
              )
            ],
          ),
          Expanded(
            child: FramesForDate(
              frames: _selectedGame!.frames ?? [],
              gameDate: _selectedGame!,
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
        const Padding(
          padding: EdgeInsets.only(bottom: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Date: 18-01-2025',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            '${_selectedUserOne?.name}',
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(
            width: 20,
          ),
          Text(
            '${_getFramesWon(_selectedUserOne?.id ?? 1).first}',
            style: const TextStyle(fontSize: 20),
          ),
          if (width >= 600)
            const Text(
              'Date: 18-01-2025',
              style: TextStyle(fontSize: 20),
            ),
          Text('${_getFramesWon(_selectedUserTwo?.id ?? 2).last}',
              style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 20),
          Text(
            '${_selectedUserTwo?.name} ',
            style: const TextStyle(fontSize: 20),
          )
        ],
      ),
      Expanded(
          child: FramesForDate(
        frames: _selectedGame!.frames ?? [],
        gameDate: _selectedGame!,
      ))
    ]);
  }
}
