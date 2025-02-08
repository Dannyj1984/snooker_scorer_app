import 'dart:js_interop';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:snooker_scorer/helpers/date_helper.dart';
import 'package:snooker_scorer/model/game_date.dart';
import 'package:snooker_scorer/module/frames/new_game.dart';
import 'package:snooker_scorer/module/games/game_details.dart';

class Stats extends StatefulWidget {
  const Stats({super.key, required this.title});

  final String title;

  @override
  State<Stats> createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  CollectionReference breaks = FirebaseFirestore.instance.collection('breaks');
  int dannyTopBreak = 0;
  double dannyAvgBreak = 0;
  int andyTopBreak = 0;
  double andyAvgBreak = 0;
  double andyBlackPercent = 0;
  double dannyBlackPercent = 0;
  final statKeys = ['Blacks Potted %', 'Best Break', 'Avg Break'];

  @override
  void initState() {
    super.initState();
    _getBreaks();
    _getBlackStats();
  }

  Future<void> _getBlackStats() async {
    try {
      final QuerySnapshot andyBlacksData = await FirebaseFirestore.instance
          .collection('users')
          .where('name', isEqualTo: 'Andy')
          .get();
      final QuerySnapshot dannyBlacksData = await FirebaseFirestore.instance
          .collection('users')
          .where('name', isEqualTo: 'Danny')
          .get();
      if (andyBlacksData.docs.isNotEmpty) {
        final andyBlacks = andyBlacksData.docs.first['blacksPotted'];
        final andyBlacksMissed = andyBlacksData.docs.first['blacksMissed'];
        final dannyBlacks = dannyBlacksData.docs.first['blacksPotted'];
        final dannyBlacksMissed = dannyBlacksData.docs.first['blacksMissed'];
        final dannyTotalBlacks = dannyBlacks + dannyBlacksMissed;
        final andyTotalBlacks = andyBlacks + andyBlacksMissed;
        andyBlackPercent = (andyBlacks / andyTotalBlacks) * 100;
        dannyBlackPercent = (dannyBlacks / dannyTotalBlacks) * 100;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _getBreaks() async {
    final avgData = await getAveragePoints();
    andyAvgBreak = avgData['Andy']!;
    dannyAvgBreak = avgData['Danny']!;
    try {
      final QuerySnapshot andyTop = await FirebaseFirestore.instance
          .collection('breaks')
          .where('playerName', isEqualTo: 'Andy')
          .orderBy('points', descending: true)
          .limit(1)
          .get();
      final QuerySnapshot dannyTop = await FirebaseFirestore.instance
          .collection('breaks')
          .where('playerName', isEqualTo: 'Danny')
          .orderBy('points', descending: true)
          .limit(1)
          .get();
      if (andyTop.docs.isNotEmpty) {
        andyTopBreak = andyTop.docs.first['points'];
      }
      if (dannyTop.docs.isNotEmpty) {
        dannyTopBreak = dannyTop.docs.first['points'];
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<Map<String, double>> getAveragePoints() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot snapshot = await firestore.collection('breaks').get();

    Map<String, List<int>> playerScores = {};

    // Group points by playerName
    for (var doc in snapshot.docs) {
      String playerName = doc['playerName'];
      int points = doc['points'];

      if (!playerScores.containsKey(playerName)) {
        playerScores[playerName] = [];
      }
      playerScores[playerName]!.add(points);
    }

    // Calculate averages
    Map<String, double> averagePoints = {};
    playerScores.forEach((player, scores) {
      double avg = scores.reduce((a, b) => a + b) / scores.length;
      averagePoints[player] = avg;
    });

    return averagePoints;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
        title: Text(widget.title),
      ),
      body: FutureBuilder(
        future: _getBreaks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('Danny',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30)),
                    Text('Andy',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30)),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(dannyTopBreak.toString()),
                    const Text('Best Break'),
                    Text(andyTopBreak.toStringAsFixed(2).toString()),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(dannyAvgBreak.toStringAsFixed(2).toString()),
                    const Text('Avg Break'),
                    Text(andyAvgBreak.toStringAsFixed(2).toString()),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${dannyBlackPercent.toStringAsFixed(2).toString()}%'),
                    const Text('Black Success %'),
                    Text('${andyBlackPercent.toStringAsFixed(2).toString()}%'),
                  ],
                ),
              ],
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
