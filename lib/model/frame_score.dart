mixin Score {
  int? playerOne;
  int? playerOneScore;
  int? playerTwo;
  int? playerTwoScore;
  List<int>? playerOneBreaks;
  List<int>? playerTwoBreaks;
}

class FrameScore with Score {
  FrameScore({
    this.playerOne,
    this.playerOneScore,
    this.playerTwo,
    this.playerTwoScore,
    this.playerOneBreaks,
    this.playerTwoBreaks,
  });

  @override
  int? playerOne;
  @override
  int? playerOneScore;
  @override
  int? playerTwo;
  @override
  int? playerTwoScore;
  @override
  List<int>? playerTwoBreaks;
  @override
  List<int>? playerOneBreaks;
}
