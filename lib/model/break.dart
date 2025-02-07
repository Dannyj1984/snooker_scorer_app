class Break {
  final int points;
  final String playerName;
  final DateTime timestamp;

  Break(
      {required this.points,
      required this.playerName,
      required this.timestamp});

  Map<String, dynamic> toJson() {
    return {
      'points': points,
      'playerName': playerName,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory Break.fromJson(Map<String, dynamic> json) {
    return Break(
      points: json['points'],
      playerName: json['playerName'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
