class FrameScore {
  final String playerOne;
  final String playerTwo;
  late int playerOneScore;
  late int playerTwoScore;
  late List<String>? playerOneBreaks;
  late List<String>? playerTwoBreaks;

  FrameScore({
    required this.playerOne,
    required this.playerTwo,
    required this.playerOneScore,
    required this.playerTwoScore,
    this.playerOneBreaks,
    this.playerTwoBreaks,
  });

  Map<String, dynamic> toJson() {
    return {
      'playerOne': playerOne,
      'playerTwo': playerTwo,
      'playerOneScore': playerOneScore,
      'playerTwoScore': playerTwoScore,
      'playerOneBreaks': playerOneBreaks,
      'playerTwoBreaks': playerTwoBreaks,
    };
  }

  factory FrameScore.fromJson(Map<String, dynamic> json) {
    return FrameScore(
      playerOne: json['playerOne'],
      playerTwo: json['playerTwo'],
      playerOneScore: json['playerOneScore'],
      playerTwoScore: json['playerTwoScore'],
      playerOneBreaks: List<String>.from(json['playerOneBreaks'] ?? []),
      playerTwoBreaks: List<String>.from(json['playerTwoBreaks'] ?? []),
    );
  }
}
