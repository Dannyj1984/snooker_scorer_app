import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:snooker_scorer/model/frame.dart';
import 'package:snooker_scorer/model/game_date.dart';
import 'package:snooker_scorer/module/frames/new_frame.dart';
import 'package:snooker_scorer/module/frames/new_game.dart';
import 'package:snooker_scorer/module/games/games.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:snooker_scorer/module/stats/stats.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: "../.env");
  } catch (e) {
    print('Error loading .env file: $e');
  }
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: dotenv.env['API_KEY']!,
      appId: dotenv.env['APP_ID']!,
      messagingSenderId: dotenv.env['MESSAGING_SENDER_ID']!,
      projectId: dotenv.env['PROJECT_ID']!,
    ),
  );
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
    _createUsers();
  }

  Future<void> _createUsers() async {
    final users = await FirebaseFirestore.instance.collection('users').get();
    if (users.docs.length < 2) {
      await FirebaseFirestore.instance.collection('users').doc('user1').set({
        'name': 'Danny',
        'luck': 0,
        'easyMiss': 0,
        'blacksMissed': 0,
        'blacksPotted': 0,
      });
      await FirebaseFirestore.instance.collection('users').doc('user2').set({
        'name': 'Andy',
        'luck': 0,
        'easyMiss': 0,
        'blacksMissed': 0,
        'blacksPotted': 0,
      });
    }
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
                height: 50,
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
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Games(
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
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Stats(
                          title: 'Stats',
                        ),
                      ),
                    );
                  },
                  child: const Text('Stats'),
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: screenWidth / 2 - 16,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Games(
                          title: 'New Game',
                        ),
                      ),
                    );
                  },
                  child: const Text('Complete Sessions'),
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
        ),
      ]),
    );
  }
}
