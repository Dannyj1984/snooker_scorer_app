import 'package:flutter/material.dart';
import 'package:snooker_scorer/components/frames.dart';
import 'package:snooker_scorer/helpers/date_helper.dart';
import 'package:snooker_scorer/model/game_date.dart';
import 'package:snooker_scorer/module/games/games.dart';
import 'package:snooker_scorer/test_data.dart';

class GameDetails extends StatefulWidget {
  const GameDetails({super.key, required this.game});

  final GameDate game;

  @override
  State<GameDetails> createState() => _GameDetailsState();
}

class _GameDetailsState extends State<GameDetails> {
  @override
  void initState() {
    super.initState();
  }

  String _getUser(int id) {
    var users = FakeData.getUsers();
    return users.firstWhere((element) => element.id == id).name;
  }

  List<int> _getFramesWon() {
    final frames = widget.game.frames ?? [];
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
        title: const Text('Snooker Scorer'),
      ),
      body: Column(
        children: [
          Column(
            children: [
              Text(
                convertDate('YYYY-MM-DD', widget.game.date),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                _getUser(widget.game.players![0]),
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(
                width: 20,
              ),
              Text(
                '${_getFramesWon().first}',
                style: const TextStyle(fontSize: 20),
              ),
              Text('${_getFramesWon().last}',
                  style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 20),
              Text(
                _getUser(widget.game.players![1]),
                style: const TextStyle(fontSize: 20),
              )
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: FramesForDate(
              frames: widget.game.frames ?? [],
              gameDate: widget.game,
            ),
          ),
        ],
      ),
    );
  }
}
