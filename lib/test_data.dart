import 'package:snooker_scorer/model/frame.dart';
import 'package:snooker_scorer/model/frame_score.dart';
import 'package:snooker_scorer/model/game_date.dart';
import 'package:snooker_scorer/model/user.dart';

class FakeData {
  static List<User> getUsers() {
    return [
      User(
          id: 1,
          name: "Danny",
          gamesPlayed: 1,
          gamesWon: 1,
          gamesLost: 0,
          totalScore: 75),
      User(
          id: 2,
          name: "Andy",
          gamesPlayed: 1,
          gamesWon: 0,
          gamesLost: 1,
          totalScore: 66),
    ];
  }

  static List<GameDate> getGameDates() {
    final dates = getDates();
    dates.sort((a, b) => b.date.compareTo(a.date));
    return dates;
  }

  static List<GameDate> getDates() {
    return [
      GameDate(
        id: 1,
        date: "2025-01-18",
        players: [1, 2],
        frames: [
          Frame(
            id: 1,
            frame: 1,
            inProgress: false,
            scores: FrameScore(
                playerOne: 1,
                playerOneScore: 20,
                playerOneBreaks: [24, 25],
                playerTwo: 2,
                playerTwoScore: 30,
                playerTwoBreaks: []),
          ),
          Frame(
            id: 2,
            frame: 2,
            inProgress: false,
            scores: FrameScore(
              playerOne: 1,
              playerOneScore: 25,
              playerOneBreaks: [24, 25],
              playerTwo: 2,
              playerTwoScore: 35,
              playerTwoBreaks: [29],
            ),
          ),
        ],
      ),
      GameDate(
        id: 1,
        date: "2025-01-21",
        players: [1, 2],
        frames: [
          Frame(
            id: 1,
            frame: 1,
            inProgress: false,
            scores: FrameScore(
                playerOne: 1,
                playerOneScore: 20,
                playerOneBreaks: [24, 25],
                playerTwo: 2,
                playerTwoScore: 30,
                playerTwoBreaks: []),
          ),
          Frame(
            id: 2,
            frame: 2,
            inProgress: false,
            scores: FrameScore(
              playerOne: 1,
              playerOneScore: 25,
              playerOneBreaks: [24, 25],
              playerTwo: 2,
              playerTwoScore: 35,
              playerTwoBreaks: [29],
            ),
          ),
        ],
      ),
      GameDate(
        id: 1,
        date: "2025-01-25",
        players: [1, 2],
        frames: [
          Frame(
            id: 1,
            frame: 1,
            inProgress: false,
            scores: FrameScore(
                playerOne: 1,
                playerOneScore: 20,
                playerOneBreaks: [24, 25],
                playerTwo: 2,
                playerTwoScore: 30,
                playerTwoBreaks: []),
          ),
          Frame(
            id: 2,
            frame: 2,
            inProgress: false,
            scores: FrameScore(
              playerOne: 1,
              playerOneScore: 25,
              playerOneBreaks: [24, 25],
              playerTwo: 2,
              playerTwoScore: 35,
              playerTwoBreaks: [29],
            ),
          ),
        ],
      ),
    ];
  }

  static List<Frame> getFramesForDate(String date, int p1, int p2) {
    var dates = FakeData.getDates();
    return dates.firstWhere((element) => element.date == date).frames!;
  }
}
