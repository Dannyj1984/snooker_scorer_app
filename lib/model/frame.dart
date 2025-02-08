import 'package:snooker_scorer/model/frame_score.dart';

class Frame {
  late String? docReference;
  final int frame;
  final bool inProgress;
  final String playerOne;
  final String playerTwo;
  late int playerOneScore;
  late int playerTwoScore;
  late List<String>? playerOneBreaks;
  late List<String>? playerTwoBreaks;
  late List<Map<String, dynamic>>? playerOneBreakData;
  late List<Map<String, dynamic>>? playerTwoBreakData;

  Frame(
      {this.docReference,
      required this.frame,
      required this.inProgress,
      required this.playerOne,
      required this.playerTwo,
      required this.playerOneScore,
      required this.playerTwoScore,
      this.playerOneBreaks,
      this.playerTwoBreaks,
      this.playerOneBreakData,
      this.playerTwoBreakData});

  Map<String, dynamic> toJson() {
    return {
      'frame': frame,
      'inProgress': inProgress,
      'playerOne': playerOne,
      'playerTwo': playerTwo,
      'playerOneScore': playerOneScore,
      'playerTwoScore': playerTwoScore,
      'playerOneBreaks': playerOneBreaks,
      'playerTwoBreaks': playerTwoBreaks,
      'playerOneBreakData': playerOneBreakData,
      'playerTwoBreakData': playerTwoBreakData
    };
  }

  factory Frame.fromJson(Map<String, dynamic> json) {
    return Frame(
      frame: json['frame'],
      inProgress: json['inProgress'],
      playerOne: json['playerOne'],
      playerTwo: json['playerTwo'],
      playerOneScore: json['playerOneScore'],
      playerTwoScore: json['playerTwoScore'],
      playerOneBreaks: List<String>.from(json['playerOneBreaks'] ?? []),
      playerTwoBreaks: List<String>.from(json['playerTwoBreaks'] ?? []),
      playerOneBreakData:
          List<Map<String, dynamic>>.from(json['playerOneBreakData'] ?? []),
      playerTwoBreakData:
          List<Map<String, dynamic>>.from(json['playerTwoBreakData'] ?? []),
    );
  }
}
