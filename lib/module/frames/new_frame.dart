import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:snooker_scorer/model/break.dart';
import 'package:snooker_scorer/module/frames/foul_form.dart';
import 'package:snooker_scorer/model/frame.dart';
import 'package:snooker_scorer/model/game_date.dart';
import 'package:snooker_scorer/module/frames/settings_form.dart';

typedef Breaks = Map<String, int>;

class NewFrame extends StatefulWidget {
  const NewFrame({super.key, required this.frame, required this.gameDate});

  final Frame frame;
  final GameDate gameDate;

  @override
  State<NewFrame> createState() => _NewFrameState();
}

class _NewFrameState extends State<NewFrame> {
  String? _userOne;
  String? _userTwo;
  ValueNotifier<int> _player1Score = ValueNotifier<int>(0);
  ValueNotifier<int> _player2Score = ValueNotifier<int>(0);
  int _currentPlayer = 1;
  int _currentBreak = 0;
  String _nextBall = 'red';
  String nextColour = '';
  int redsRemaining = 15;
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
  List<Breaks> p1Breaks = [];
  List<Breaks> p2Breaks = [];

  @override
  void initState() {
    super.initState();
    _player1Score.addListener(_updatePlayer1ScoreInDatabase);
    _player2Score.addListener(_updatePlayer2ScoreInDatabase);
    _player1Score.value = widget.frame.playerOneScore;
    _player2Score.value = widget.frame.playerTwoScore;
    _userOne = 'Danny';
    _userTwo = 'Andy';
    widget.frame?.playerOneBreaks = [];
    widget.frame?.playerTwoBreaks = [];
  }

  @override
  void dispose() {
    _player1Score.removeListener(_updatePlayer1ScoreInDatabase);
    _player2Score.removeListener(_updatePlayer2ScoreInDatabase);
    super.dispose();
  }

  void _updatePlayer1ScoreInDatabase() {
    widget.frame.playerOneScore = _player1Score.value;
    // TODO: update the frame with the score
  }

  void _updatePlayer2ScoreInDatabase() {
    widget.frame.playerTwoScore = _player2Score.value;
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
            if (_player1Score == _player2Score) {
              black = true;
              currentColourIndex = 6;
              nextColour = 'Black';
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                          title: const Text('Black Ball game'),
                          content: const Text('Who will go first.'),
                          actions: [
                            TextButton(
                                child: Text(_userOne!),
                                onPressed: () {
                                  setState(() {
                                    _currentPlayer = 1;
                                  });
                                  Navigator.of(context).pop();
                                }),
                            TextButton(
                                child: Text(_userTwo!),
                                onPressed: () {
                                  setState(() {
                                    _currentPlayer = 2;
                                  });
                                  Navigator.of(context).pop();
                                })
                          ]));
            } else {
              black = false;
            }
          });
          break;
      }
    }
  }

  Future<void> _checkMissedShot() async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Off the spot'),
        content: const Text('Did you miss the black ball off the spot.'),
        actions: [
          TextButton(
            onPressed: () async {
              if (_currentPlayer == 1) {
                await _incrementBlacksMissed('Danny');
              } else {
                await _incrementBlacksMissed('Andy');
              }
              setState(() {});
              Navigator.of(ctx).pop();
            },
            child: const Text('Yes'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('No'),
          ),
        ],
      ),
    );
  }

  void _checkOffSpot() {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
                title: const Text('Off the spot'),
                content: const Text('Did you pot the black ball off the spot.'),
                actions: [
                  TextButton(
                      onPressed: () {
                        setState(() {
                          if (_currentPlayer == 1) {
                            _incrementBlacksPotted('Danny');
                          } else {
                            _incrementBlacksPotted('Andy');
                          }
                        });
                        Navigator.of(ctx).pop();
                      },
                      child: const Text('Yes')),
                  TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: const Text('No'))
                ]));
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
        _player1Score.value += score;
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
        _player2Score.value += score;
        _currentBreak += score;
        _updateNextBall(score);
      });
    }
  }

  void changeTurn() async {
    if (_currentBreak > 0 && _nextBall == 'colour') {
      await _checkMissedShot();
    }
    if (_currentBreak > 20) {
      final breakData = {
        'total': _currentBreak,
        if (breakReds > 0) 'breakReds': breakReds,
        if (breakYellows > 0) 'breakYellows': breakYellows,
        if (breakGreens > 0) 'breakGreens': breakGreens,
        if (breakBrowns > 0) 'breakBrowns': breakBrowns,
        if (breakBlues > 0) 'breakBlues': breakBlues,
        if (breakPinks > 0) 'breakPinks': breakPinks,
        if (breakBlacks > 0) 'breakBlacks': breakBlacks,
      };
      if (_currentPlayer == 1) {
        p1Breaks.add(breakData);
      } else {
        p2Breaks.add(breakData);
      }
      await _saveBreak(_currentBreak, _currentPlayer);
    }
    setState(() {
      _currentPlayer = _currentPlayer == 1 ? 2 : 1;
      _nextBall = 'red';
      resetBreak();
    });
  }

  Future<bool> _saveBreak(int points, int playerName) async {
    final playerBreak = Break(
      points: points,
      playerName: _currentPlayer == 1 ? _userOne! : _userTwo!,
      timestamp: DateTime.now(),
    );

    final DocumentReference docRef = await FirebaseFirestore.instance
        .collection('breaks')
        .add(playerBreak.toJson());
    if (_currentPlayer == 1) {
      widget.frame.playerOneBreaks!.add(docRef.id);
    } else {
      widget.frame.playerTwoBreaks!.add(docRef.id);
    }
    // Update the frame data with the new value for playerOneBreaks.
    FirebaseFirestore.instance
        .collection('frames')
        .doc(widget.frame.docReference)
        .set(widget.frame.toJson(), SetOptions(merge: true));
    return true;
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

  void updateSettings(int p1Score, int p2Score, int reds, bool endFr) {
    setState(() {
      _player1Score.value = p1Score;
      _player2Score.value = p2Score;
      redsRemaining = reds;
      if (endFr == true) {
        endFrame();
      }
    });
  }

  Future<int?> settings() {
    return showModalBottomSheet<int>(
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return SettingsForm(
          updateSettings: updateSettings,
          p1Score: _player1Score.value,
          p2Score: _player2Score.value,
          redsRemaining: redsRemaining,
          endFrame: false,
        );
      },
    );
  }

  void handleFoul(int foul, int redsPotted) {
    setState(() {
      if (_currentPlayer == 1) {
        _player2Score.value += foul;
      } else {
        _player1Score.value += foul;
      }
      _nextBall = 'red';
      if (redsPotted > 0) {
        redsRemaining -= redsPotted;
      }
    });
  }

  String _getLeaderName() {
    if (_player1Score.value > _player2Score.value) {
      return _userOne!;
    }
    return _userTwo!;
  }

  void concedeFrame() {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
                title: const Text('Concede'),
                content: Text(
                    'Are you sure you want to concede the frame to ${_getLeaderName()}'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        endFrame();
                      },
                      child: const Text('OK')),
                  TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: const Text('Cancel'))
                ]));
  }

  void luck() {
    FirebaseFirestore.instance
        .collection('users')
        .where('name', isEqualTo: _currentPlayer == 1 ? _userOne : _userTwo)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        final userDoc = querySnapshot.docs.first;
        userDoc.reference.update({'luck': FieldValue.increment(1)});
      }
    });
  }

  void easyMiss() {
    FirebaseFirestore.instance
        .collection('users')
        .where('name', isEqualTo: _currentPlayer == 1 ? _userOne : _userTwo)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        final userDoc = querySnapshot.docs.first;
        userDoc.reference.update({'easyMiss': FieldValue.increment(1)});
      }
    });
  }

  void actions() {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
                title: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text('Actions')],
                ),
                actions: [
                  ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        luck();
                      },
                      icon: const Icon(Icons.flag_circle_outlined),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(100, 50),
                      ),
                      label: const Text('Luck')),
                  ElevatedButton.icon(
                      onPressed: () {
                        easyMiss();
                        Navigator.of(ctx).pop();
                      },
                      icon: const Icon(Icons.car_crash),
                      label: const Text('Miss')),
                ]));
  }

  void endFrame() {
    FirebaseFirestore.instance
        .collection('frames')
        .doc(widget.frame.docReference)
        .update({'inProgress': false});

    Navigator.of(context).pop();
  }

  void addFoul() {
    showFoulForm().then((value) {
      if (value == null) return;
      changeTurn();
    });
  }

  Future<void> _incrementBlacksMissed(String name) async {
    FirebaseFirestore.instance
        .collection('users')
        .where('name', isEqualTo: name)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        final userDoc = querySnapshot.docs.first;
        final userData = userDoc.data();
        final blacksMissed =
            userData.containsKey('blacksMissed') ? userData['blacksMissed'] : 0;
        final newBlacksMissed = blacksMissed + 1;
        userDoc.reference.update({'blacksMissed': newBlacksMissed});
      }
    });
  }

  void _incrementBlacksPotted(String name) {
    FirebaseFirestore.instance
        .collection('users')
        .where('name', isEqualTo: name)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        final userDoc = querySnapshot.docs.first;
        final userData = userDoc.data();
        final blacksPotted =
            userData.containsKey('blacksPotted') ? userData['blacksPotted'] : 0;
        final newBlacksPotted = blacksPotted + 1;
        userDoc.reference.update({'blacksPotted': newBlacksPotted});
      }
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

  Widget _p1BreakBalls(Breaks breakScore) {
    String trimName(String name) {
      name = name.substring(0, name.length - 1);
      return name.replaceAll('break', '');
    }

    Color getColour(String key) {
      key = trimName(key);
      key = key[0].toUpperCase() + key.substring(1);
      switch (key.trim()) {
        case 'Red':
          return Colors.red;
        case 'Yellow':
          return Colors.yellow;
        case 'Green':
          return Colors.green;
        case 'Brown':
          return Colors.brown;
        case 'Blue':
          return Colors.blue;
        case 'Pink':
          return Colors.pink;
        case 'Black':
          return Colors.black;
        default:
          return Colors.white;
      }
    }

    // This should return a list of the balls for player 1 break
    return Row(
      children: breakScore.entries
          .where((element) => element.value > 0 && element.key != 'total')
          .map((entry) => Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 3,
                    color: getColour(entry.key),
                  ),
                ),
                child: Center(
                  child: Text(
                    entry.value.toString(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 18,
                    ),
                  ),
                ),
              ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final frameNumber = widget.frame.frame;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
          title: Text('Frame $frameNumber'),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.3),
                BlendMode.dstATop,
              ),
              image: const AssetImage('snooker.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              black
                  ? Row(children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0, left: 4.0),
                        child: ElevatedButton(
                            onPressed: concedeFrame,
                            child: const Text('Concede Frame')),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0, left: 4.0),
                        child: ElevatedButton(
                            onPressed: actions, child: const Text('Actions')),
                      ),
                    ])
                  : Container(),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('${_userOne!} ${_currentPlayer == 1 ? '*' : ''}',
                      style: const TextStyle(fontSize: 20)),
                  ValueListenableBuilder<int>(
                    valueListenable: _player1Score,
                    builder: (context, value, child) {
                      return Text('$value',
                          style: const TextStyle(fontSize: 30));
                    },
                  ),
                  ValueListenableBuilder<int>(
                    valueListenable: _player2Score,
                    builder: (context, value, child) {
                      return Text('$value',
                          style: const TextStyle(fontSize: 30));
                    },
                  ),
                  Text('${_currentPlayer == 2 ? '*' : ''} ${_userTwo!}',
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
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: p1Breaks
                    .map((breakScore) => Row(children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 16.0, left: 8.0),
                            child: Text(breakScore['total'].toString(),
                                style: const TextStyle(fontSize: 30)),
                          ),
                          _p1BreakBalls(breakScore),
                        ]))
                    .toList(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: p2Breaks
                    .map((breakScore) => Row(children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: _p1BreakBalls(breakScore),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              right: 16.0,
                            ),
                            child: Text(breakScore['total'].toString(),
                                style: const TextStyle(fontSize: 30)),
                          ),
                        ]))
                    .toList(),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: _breakBalls(),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: _nextBallInfo(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _pointsRemaining(),
              ),
              if (width <= 600) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: _colourButtonsA().toList(), // Convert Set to List
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: _colourButtonsB().toList(), // Convert Set to List
                ),
              ] else ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ..._colourButtonsA(),
                    ..._colourButtonsB()
                  ], // Convert Set to List
                ),
              ],
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      changeTurn();
                    },
                    child:
                        Text(_currentBreak > 0 ? 'End Break' : 'Change Turn'),
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
                            endFrame();
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
        ));
  }

  _pointsRemaining() {
    return [
      Text(
          'Remaining: ${calculateRemaining()} ${_colourSequence[currentColourIndex]}',
          style: const TextStyle(fontSize: 20)),
    ];
  }

  _nextBallInfo() {
    final width = MediaQuery.of(context).size.width;
    return [
      Container(
        height: 40,
        width: width,
        color: Colors.green.shade400,
        alignment: Alignment.center,
        child: Text(
            'Next: ${_currentPlayer == 1 ? _userOne! : _userTwo!} potting ${_getColour()}',
            style: const TextStyle(fontSize: 20, color: Colors.white)),
      ),
    ];
  }

  String _getColour() {
    if (currentColourIndex == 0) {
      return _nextBall;
    }
    return _colourSequence[currentColourIndex];
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

  List<Widget> _colourButtonsA() {
    return <Widget>[
      const SizedBox(width: 10),
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
        child: const CircleAvatar(
          radius: 30,
          backgroundColor: Colors.red,
        ),
      ),
      const SizedBox(width: 10),
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
      const SizedBox(width: 10),
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
      const SizedBox(width: 10),
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
    ];
  }

  List<Widget> _colourButtonsB() {
    return <Widget>[
      const SizedBox(width: 10),
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
      const SizedBox(width: 10),
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
      const SizedBox(width: 10),
      ElevatedButton(
        onPressed: ((_nextBall == 'red' && !black) ||
                (_nextBall == 'colour' && !black))
            ? null
            : () {
                _updateBreak(7);
                _checkOffSpot();
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
