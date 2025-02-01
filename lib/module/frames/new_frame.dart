import 'package:flutter/material.dart';
import 'package:snooker_scorer/module/frames/foul_form.dart';
import 'package:snooker_scorer/model/frame.dart';
import 'package:snooker_scorer/model/game_date.dart';
import 'package:snooker_scorer/model/user.dart';
import 'package:snooker_scorer/module/frames/settings_form.dart';
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
  String nextColour = '';
  int redsRemaining = 5;
  bool yellow = true;
  bool green = true;
  bool brown = true;
  bool blue = true;
  bool pink = true;
  bool black = true;
  int breakReds = 0;
  int breakYellows = 0;
  int breakGreens = 0;
  int breakBrowns = 0;
  int breakBlues = 0;
  int breakPinks = 0;
  int breakBlacks = 0;
  bool startingColours = false;
  bool lastRed = false;
  final List<Map<String, dynamic>> _history = [];
  final List<String> _colourSequence = [
    '',
    'Yellow',
    'Green',
    'Brown',
    'Blue',
    'Pink',
    'Black'
  ];
  int currentColourIndex = 0;

  @override
  void initState() {
    super.initState();
    final players = widget.gameDate.players!;
    _userOne =
        FakeData.getUsers().where((element) => element.id == players[0]).first;
    _userTwo =
        FakeData.getUsers().where((element) => element.id == players[1]).first;
  }

  void _saveState() {
    _history.add({
      'redsRemaining': redsRemaining,
      '_nextBall': _nextBall,
      'currentColourIndex': currentColourIndex,
      'playerOneScore': _player1Score,
      'playerTwoScore': _player2Score,
      'currentPlayer': _currentPlayer,
      'yellow': yellow,
      'green': green,
      'brown': brown,
      'blue': blue,
      'pink': pink,
      'black': black,
      'breakReds': breakReds,
      'breakYellows': breakYellows,
      'breakGreens': breakGreens,
      'breakBrowns': breakBrowns,
      'breakBlues': breakBlues,
      'breakPinks': breakPinks,
      'breakBlacks': breakBlacks
    });
  }

  void _undo() {
    if (_history.isNotEmpty) {
      final lastState = _history.removeLast();
      setState(() {
        redsRemaining = lastState['redsRemaining'];
        _nextBall = lastState['_nextBall'];
        currentColourIndex = lastState['currentColourIndex'];
        _player1Score = lastState['playerOneScore'];
        _player2Score = lastState['playerTwoScore'];
        _currentPlayer = lastState['currentPlayer'];
        yellow = lastState['yellow'];
        green = lastState['green'];
        brown = lastState['brown'];
        blue = lastState['blue'];
        pink = lastState['pink'];
        black = lastState['black'];
        breakReds = lastState['breakReds'];
        breakYellows = lastState['breakYellows'];
        breakGreens = lastState['breakGreens'];
        breakBrowns = lastState['breakBrowns'];
        breakBlues = lastState['breakBlues'];
        breakPinks = lastState['breakPinks'];
        breakBlacks = lastState['breakBlacks'];
      });
    }
  }

  void switchNextBall() {
    setState(() {
      _nextBall = _nextBall == 'red' ? 'colour' : 'red';
    });
  }

  void _updateBreakBalls(int score) {
    if (score == 1) {
      breakReds += 1;
    } else if (score == 2) {
      breakYellows += 1;
    } else if (score == 3) {
      breakGreens += 1;
    } else if (score == 4) {
      breakBrowns += 1;
    } else if (score == 5) {
      breakBlues += 1;
    } else if (score == 6) {
      breakPinks += 1;
    } else if (score == 7) {
      breakBlacks += 1;
    }
  }

  void _updateNextBall(int score) {
    if (redsRemaining > 0 && lastRed == false) {
      _nextBall = _nextBall == 'red' ? 'colour' : 'red';
    } else if (redsRemaining == 0 && lastRed == true && _nextBall == 'red') {
      _nextBall = 'colour';
    } else if (redsRemaining == 0 && lastRed == true && _nextBall == 'colour') {
      lastRed = false;
      currentColourIndex += 1;
    } else {
      _nextBall = 'colour';
      if (currentColourIndex < 6) {
        currentColourIndex += 1;
      }
      switch (score) {
        case 2:
          setState(() {
            yellow = false;
            nextColour = 'Green';
          });
          break;
        case 3:
          setState(() {
            green = false;
            nextColour = 'Brown';
          });
          break;
        case 4:
          setState(() {
            brown = false;
            nextColour = 'Blue';
          });
          break;
        case 5:
          setState(() {
            blue = false;
            nextColour = 'Pink';
          });
          break;
        case 6:
          setState(() {
            pink = false;
            nextColour = 'Black';
          });
          break;
        case 7:
          setState(() {
            black = false;
          });
          break;
      }
    }
  }

  void _updateBreak(int score) {
    _saveState();
    final redsGone = redsRemaining == 0 && lastRed == false;
    if (redsGone && score == 1) {
      setState(() {});
      return;
    }
    _updateBreakBalls(score);
    if (_currentPlayer == 1) {
      if (_nextBall == 'red') {
        if (redsRemaining == 1) {
          lastRed = true;
        }
        redsRemaining -= 1;
      }
      setState(() {
        _player1Score += score;
        _currentBreak += score;
        _updateNextBall(score);
      });
    } else {
      if (_nextBall == 'red') {
        if (redsRemaining == 1) {
          lastRed = true;
        }
        redsRemaining -= 1;
      }
      setState(() {
        _player2Score += score;
        _currentBreak += score;
        _updateNextBall(score);
      });
    }
  }

  void changeTurn() {
    setState(() {
      _currentPlayer = _currentPlayer == 1 ? 2 : 1;
      _nextBall = 'red';
      resetBreak();
    });
  }

  void resetBreak() {
    setState(() {
      _currentBreak = 0;
      breakReds = 0;
      breakYellows = 0;
      breakGreens = 0;
      breakBrowns = 0;
      breakBlues = 0;
      breakPinks = 0;
      breakBlacks = 0;
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

  void updateSettings(int p1Score, int p2Score, int reds) {
    setState(() {
      _player1Score = p1Score;
      _player2Score = p2Score;
      redsRemaining = reds;
    });
  }

  Future<int?> settings() {
    return showModalBottomSheet<int>(
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return SettingsForm(
          updateSettings: updateSettings,
          p1Score: _player1Score,
          p2Score: _player2Score,
          redsRemaining: redsRemaining,
        );
      },
    );
  }

  void handleFoul(int foul, int redsPotted) {
    setState(() {
      if (_currentPlayer == 1) {
        _player2Score += foul;
      } else {
        _player1Score += foul;
      }
      _nextBall = 'red';
      if (redsPotted > 0) {
        redsRemaining -= redsPotted;
      }
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: _breakBalls(),
          ),
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
              !black
                  ? ElevatedButton(
                      onPressed: () {
                        addFoul();
                      },
                      child: const Text('End Frame'),
                    )
                  : Container(),
              black
                  ? ElevatedButton(
                      onPressed: () {
                        settings();
                      },
                      child: const Text('Settings'),
                    )
                  : Container(),
              ElevatedButton(
                onPressed: () {
                  _undo();
                },
                child: const Text('Undo'),
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
      Text(
          'Remaining: ${calculateRemaining()} ${_colourSequence[currentColourIndex]}',
          style: const TextStyle(fontSize: 20)),
    ];
  }

  List<Widget> _breakBalls() {
    return [
      breakReds > 0
          ? ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(8), // Remove extra padding
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.red,
                  ),
                  Text(breakReds.toString(),
                      style:
                          const TextStyle(fontSize: 20, color: Colors.white)),
                ],
              ),
            )
          : Container(),
      breakYellows > 0
          ? ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(8), // Remove extra padding
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.yellow,
                  ),
                  Text(breakYellows.toString(),
                      style:
                          const TextStyle(fontSize: 20, color: Colors.black)),
                ],
              ),
            )
          : Container(),
      breakGreens > 0
          ? ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(8), // Remove extra padding
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.green,
                  ),
                  Text(breakGreens.toString(),
                      style:
                          const TextStyle(fontSize: 20, color: Colors.white)),
                ],
              ),
            )
          : Container(),
      breakBrowns > 0
          ? ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(8), // Remove extra padding
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.brown,
                  ),
                  Text(breakBrowns.toString(),
                      style:
                          const TextStyle(fontSize: 20, color: Colors.white)),
                ],
              ),
            )
          : Container(),
      breakBlues > 0
          ? ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(8), // Remove extra padding
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.blue,
                  ),
                  Text(breakBlues.toString(),
                      style:
                          const TextStyle(fontSize: 20, color: Colors.white)),
                ],
              ),
            )
          : Container(),
      breakPinks > 0
          ? ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(8), // Remove extra padding
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.pink,
                  ),
                  Text(breakPinks.toString(),
                      style:
                          const TextStyle(fontSize: 20, color: Colors.white)),
                ],
              ),
            )
          : Container(),
      breakBlacks > 0
          ? ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(8), // Remove extra padding
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.black,
                  ),
                  Text(breakBlacks.toString(),
                      style:
                          const TextStyle(fontSize: 20, color: Colors.white)),
                ],
              ),
            )
          : Container(),
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
        onPressed: ((_nextBall == 'red' && !yellow) ||
                (_nextBall == 'colour' && !yellow))
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
        onPressed: ((_nextBall == 'red' && !green) ||
                (_nextBall == 'colour' && !green))
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
        onPressed: ((_nextBall == 'red' && !brown) ||
                (_nextBall == 'colour' && !brown))
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
        onPressed:
            ((_nextBall == 'red' && !blue) || (_nextBall == 'colour' && !blue))
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
        onPressed:
            ((_nextBall == 'red' && !pink) || (_nextBall == 'colour' && !pink))
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
        onPressed: ((_nextBall == 'red' && !black) ||
                (_nextBall == 'colour' && !black))
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
