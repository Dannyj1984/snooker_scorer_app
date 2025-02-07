import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:snooker_scorer/components/frames.dart';
import 'package:snooker_scorer/helpers/date_helper.dart';
import 'package:snooker_scorer/model/game_date.dart';

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

  Future<String> _getUser(String name) async {
    var user = await FirebaseFirestore.instance
        .collection('users')
        .where('name', isEqualTo: name)
        .limit(1)
        .get();
    return user.docs.first.data()['name'];
  }

  List<int> _getFramesWon() {
    final frames = widget.game.frames ?? [];
    if (frames.isEmpty) {
      return [0, 0];
    }
    var playerOneWins = 0;
    var playerTwoWins = 0;

    for (var frame in frames) {
      if ((frame.playerOneScore) > (frame.playerTwoScore)) {
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
              FutureBuilder(
                future: _getUser('Danny'),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      snapshot.data!,
                      style: const TextStyle(fontSize: 20),
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
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
              FutureBuilder(
                future: _getUser('Andy'),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      snapshot.data!,
                      style: const TextStyle(fontSize: 20),
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
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
