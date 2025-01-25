import 'package:snooker_scorer/model/frame.dart';

class GameDate {
  final int id;
  final String date;
  final List<int>? players;
  final int? gamesPlayed;
  final List<Frame>? frames;

  GameDate({
    required this.id,
    required this.date,
    this.players,
    this.gamesPlayed,
    this.frames,
  });

  factory GameDate.fromJson(Map<String, dynamic> json) {
    return GameDate(
      id: json['id'],
      date: json['date'],
      players: json['players']?.cast<int>(),
      gamesPlayed: json['frames']?.length,
      frames: json['frames']?.cast<Frame>()?.toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'players': players,
      'gamesPlayed': gamesPlayed,
      'Frames': frames,
    };
  }
}
