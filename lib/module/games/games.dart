import 'package:flutter/material.dart';
import 'package:snooker_scorer/components/frames.dart';
import 'package:snooker_scorer/module/frames/foul_form.dart';
import 'package:snooker_scorer/components/user_selector.dart';
import 'package:snooker_scorer/helpers/date_helper.dart';
import 'package:snooker_scorer/model/frame.dart';
import 'package:snooker_scorer/model/frame_score.dart';
import 'package:snooker_scorer/model/game_date.dart';
import 'package:snooker_scorer/model/user.dart';
import 'package:snooker_scorer/module/games/game_details.dart';
import 'package:snooker_scorer/test_data.dart';

class Games extends StatefulWidget {
  const Games({super.key, required this.title});

  final String title;

  @override
  State<Games> createState() => _GameState();
}

class _GameState extends State<Games> {
  List<GameDate>? _games;

  @override
  void initState() {
    super.initState();
    _games = FakeData.getGameDates();
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
          Expanded(
            child: ListView.builder(
              itemCount: _games?.length,
              itemBuilder: (context, index) {
                final date = convertDate('YYYY-MM-DD', _games![index].date);
                return ListTile(
                  title: Text(date!),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GameDetails(game: _games![index]),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
