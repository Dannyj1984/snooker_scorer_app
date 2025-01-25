import 'package:flutter/material.dart';
import 'package:snooker_scorer/module/frames/foul_form.dart';
import 'package:snooker_scorer/model/frame.dart';
import 'package:snooker_scorer/model/game_date.dart';
import 'package:snooker_scorer/model/user.dart';
import 'package:snooker_scorer/test_data.dart';

class NewFrame extends StatefulWidget {
  const NewFrame({super.key, required this.frame, required this.gameDate});

  final Frame frame;
  final GameDate gameDate;

  @override
  State<NewFrame> createState() => _NewFrameState();
}

class _NewFrameState extends State<NewFrame> {
  User? _userOne;
  User? _userTwo;
  int _player1Score = 0;
  int _player2Score = 0;
  int _currentPlayer = 1;
  int _currentBreak = 0;
  String _nextBall = 'red';
  int redsRemaining = 15;
  bool yellow = true;
  bool green = true;
  bool brown = true;
  bool blue = true;
  bool pink = true;
  bool black = true;
  @override
  void initState() {
    super.initState();
    final players = widget.gameDate.players!;
    _userOne =
        FakeData.getUsers().where((element) => element.id == players[0]).first;
    _userTwo =
        FakeData.getUsers().where((element) => element.id == players[1]).first;
  }

  void switchNextBall() {
    setState(() {
      _nextBall = _nextBall == 'red' ? 'colour' : 'red';
    });
  }

  void _updateBreak(int score) {
    if (_currentPlayer == 1) {
      if (_nextBall == 'red') {
        redsRemaining -= 1;
      }
      setState(() {
        _player1Score += score;
        _currentBreak += score;
        _nextBall = _nextBall == 'red' ? 'colour' : 'red';
      });
    } else {
      setState(() {
        _player2Score += score;
        _currentBreak += score;
        _nextBall = _nextBall == 'red' ? 'colour' : 'red';
      });
    }
  }

  void changeTurn() {
    setState(() {
      _currentPlayer = _currentPlayer == 1 ? 2 : 1;
      _currentBreak = 0;
      _nextBall = 'red';
    });
  }

  Future<int?> showFoulForm() {
    return showModalBottomSheet<int>(
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return FoulForm(handleFoul: handleFoul);
      },
    );
  }

  void handleFoul(int foul) {
    setState(() {
      if (_currentPlayer == 1) {
        _player2Score += foul;
      } else {
        _player1Score += foul;
      }
      _nextBall = 'red';
    });
  }

  void addFoul() {
    showFoulForm().then((value) {
      if (value == null) return;
      changeTurn();
    });
  }

  int countColoursRemaining() {
    var remaining = 0;
    if (yellow) remaining += 2;
    if (green) remaining += 3;
    if (brown) remaining += 4;
    if (blue) remaining += 5;
    if (pink) remaining += 6;
    if (black) remaining += 7;
    return remaining;
  }

  int remainingRedPointsPotential() {
    var remaining = 0;
    for (var i = 0; i < redsRemaining; i++) {
      remaining += 8;
    }
    return remaining;
  }

  int calculateRemaining() {
    final redsGone = redsRemaining == 0;
    if (redsGone) {
      setState(() {});
      return countColoursRemaining();
    } else {
      setState(() {});
      return remainingRedPointsPotential() + countColoursRemaining();
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final frameNumber = widget.frame.frame;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
        title: Text('Frame $frameNumber'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('${_userOne!.name} ${_currentPlayer == 1 ? '*' : ''}',
                  style: const TextStyle(fontSize: 20)),
              Text(_player1Score.toString(),
                  style: const TextStyle(fontSize: 30)),
              Text(_player2Score.toString(),
                  style: const TextStyle(fontSize: 30)),
              Text('${_currentPlayer == 2 ? '*' : ''} ${_userTwo!.name}',
                  style: const TextStyle(fontSize: 20)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(_currentPlayer == 1 ? _currentBreak.toString() : '',
                  style: const TextStyle(fontSize: 20)),
              Text(_currentPlayer == 2 ? _currentBreak.toString() : '',
                  style: const TextStyle(fontSize: 20)),
            ],
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _pointsRemaining(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _colourButtons(),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  changeTurn();
                },
                child: Text(_currentBreak > 0 ? 'End Break' : 'Change Turn'),
              ),
              ElevatedButton(
                onPressed: () {
                  addFoul();
                },
                child: const Text('Foul'),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  _pointsRemaining() {
    return [
      Text('Remaining: ${calculateRemaining()}',
          style: const TextStyle(fontSize: 20)),
    ];
  }

  _colourButtons() {
    return [
      ElevatedButton(
        onPressed: _nextBall == 'colour'
            ? null
            : () {
                _updateBreak(1);
              },
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: EdgeInsets.zero, // Remove extra padding
        ),
        child: CircleAvatar(
          radius: _nextBall == 'red' ? 40 : 30,
          backgroundColor: Colors.red,
        ),
      ),
      ElevatedButton(
        onPressed: _nextBall == 'red'
            ? null
            : () {
                _updateBreak(2);
              },
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: EdgeInsets.zero, // Remove extra padding
        ),
        child: const CircleAvatar(
          radius: 30,
          backgroundColor: Colors.yellow,
        ),
      ),
      ElevatedButton(
        onPressed: _nextBall == 'red'
            ? null
            : () {
                _updateBreak(3);
              },
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: EdgeInsets.zero, // Remove extra padding
        ),
        child: const CircleAvatar(
          radius: 30,
          backgroundColor: Colors.green,
        ),
      ),
      ElevatedButton(
        onPressed: _nextBall == 'red'
            ? null
            : () {
                _updateBreak(4);
              },
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: EdgeInsets.zero, // Remove extra padding
        ),
        child: const CircleAvatar(
          radius: 30,
          backgroundColor: Colors.brown,
        ),
      ),
      ElevatedButton(
        onPressed: _nextBall == 'red'
            ? null
            : () {
                _updateBreak(5);
              },
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: EdgeInsets.zero, // Remove extra padding
        ),
        child: const CircleAvatar(
          radius: 30,
          backgroundColor: Colors.blue,
        ),
      ),
      ElevatedButton(
        onPressed: _nextBall == 'red'
            ? null
            : () {
                _updateBreak(6);
              },
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: EdgeInsets.zero, // Remove extra padding
        ),
        child: const CircleAvatar(
          radius: 30,
          backgroundColor: Colors.pink,
        ),
      ),
      ElevatedButton(
        onPressed: _nextBall == 'red'
            ? null
            : () {
                _updateBreak(7);
              },
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: EdgeInsets.zero, // Remove extra padding
        ),
        child: const CircleAvatar(
          radius: 30,
          backgroundColor: Colors.black,
        ),
      ),
    ];
  }
}
