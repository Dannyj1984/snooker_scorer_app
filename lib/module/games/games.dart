import 'dart:js_interop';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:snooker_scorer/helpers/date_helper.dart';
import 'package:snooker_scorer/model/game_date.dart';
import 'package:snooker_scorer/module/frames/new_game.dart';
import 'package:snooker_scorer/module/games/game_details.dart';

class Games extends StatefulWidget {
  const Games({super.key, required this.title});

  final String title;

  @override
  State<Games> createState() => _GameState();
}

class _GameState extends State<Games> {
  List<GameDate>? _games;
  CollectionReference games = FirebaseFirestore.instance.collection('games');

  @override
  void initState() {
    super.initState();
    _getGames();
  }

  Future<void> _getGames() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('games')
          .where('completed', isEqualTo: false)
          .get();
      if (snapshot.docs.isEmpty) {
        _games = [];
        return;
      }

      setState(() {
        _games = snapshot.docs.map((doc) {
          var data = doc.data() as Map<String, dynamic>;
          var gameDate = GameDate.fromJson(data);
          gameDate.documentId = doc.id; // Set the document ID
          return gameDate;
        }).toList();
      });
      for (var game in _games!) {
        game.frames = await game.fetchFrames();
        setState(() {});
      }
    } catch (e) {
      print('Error fetching games: $e');
    }
  }

  Future<void> addGame() async {
    if (_games!.isNotEmpty &&
        _games!.any(
          (game) => game.date == DateTime.now().toString().substring(0, 10),
        )) {
      return;
    }
    final user1 = FirebaseFirestore.instance.collection('users').doc('user1');
    final users2 = FirebaseFirestore.instance.collection('users').doc('user2');

    GameDate gameDate = GameDate(
        completed: false,
        date: DateTime.now().toString().substring(0, 10),
        players: [user1.id, users2.id],
        gamesPlayed: 0,
        frames: []);
    // Add a new document with the data from the GameDate object
    await games
        .add(gameDate.toJson())
        .then((DocumentReference doc) {})
        .catchError((error) {
      print('Error adding document: $error');
    });
    await _getGames();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return _games != null
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
              title: Text(widget.title),
            ),
            body: Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    itemCount: _games?.length,
                    itemBuilder: (context, index) {
                      final date =
                          convertDate('YYYY-MM-DD', _games![index].date);
                      return ListTile(
                        title: Text(date!),
                        onTap: () {
                          if (_games![index].completed) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    GameDetails(game: _games![index]),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NewGameDate(
                                  game: _games![index],
                                  title: 'New Game',
                                ),
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: addGame,
              tooltip: 'Add Game',
              child: const Icon(Icons.add),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
              title: Text(widget.title),
            ),
            body: const Center(
              child: Text('No games found'),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: addGame,
              tooltip: 'Add Game',
              child: const Icon(Icons.add),
            ),
          );
  }
}
