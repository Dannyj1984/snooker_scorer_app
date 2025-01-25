import 'package:flutter/material.dart';
import 'package:snooker_scorer/components/frames.dart';
import 'package:snooker_scorer/module/frames/foul_form.dart';
import 'package:snooker_scorer/components/user_selector.dart';
import 'package:snooker_scorer/model/frame.dart';
import 'package:snooker_scorer/model/frame_score.dart';
import 'package:snooker_scorer/model/game_date.dart';
import 'package:snooker_scorer/model/user.dart';
import 'package:snooker_scorer/module/frames/new_frame.dart';
import 'package:snooker_scorer/module/frames/new_game.dart';
import 'package:snooker_scorer/module/games/games.dart';
import 'package:snooker_scorer/test_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Snooker Scorer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 17, 148, 50)),
        useMaterial3: true,
      ),
      initialRoute: '/',
      // home: const MyHomePage(title: 'Snooker Scorer'),
      routes: {
        '/': (context) => const MyHomePage(title: 'Snooker Scorer'),
      },
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/frameDetails':
            final args = settings.arguments as Map<String, dynamic>;
            final Frame frame = args['frame'] as Frame;
            final GameDate gameDate = args['gameDate'] as GameDate;
            return MaterialPageRoute(
              builder: (context) {
                return NewFrame(frame: frame, gameDate: gameDate);
              },
            );
          default:
            return MaterialPageRoute(
              builder: (context) => const MyHomePage(title: 'Snooker Scorer'),
            );
        }
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
        title: Text(widget.title),
      ),
      body: Column(children: [
        Expanded(
          child: Row(
            children: [
              SizedBox(
                width: screenWidth / 2 - 16,
                height: 200,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Games(
                          title: 'Games',
                        ),
                      ),
                    );
                  },
                  child: const Text('Games'),
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: screenWidth / 2 - 16,
                height: 200,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NewGameDate(
                          title: 'New Game',
                        ),
                      ),
                    );
                  },
                  child: const Text('New Frame'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Row(
            children: [
              SizedBox(
                width: screenWidth / 2 - 16,
                height: 200,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NewGameDate(
                          title: 'New Game',
                        ),
                      ),
                    );
                  },
                  child: const Text('Frames'),
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: screenWidth / 2 - 16,
                height: 200,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NewGameDate(
                          title: 'New Game',
                        ),
                      ),
                    );
                  },
                  child: const Text('New Frame'),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
