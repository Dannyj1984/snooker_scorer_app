import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:snooker_scorer/model/frame.dart';

class GameDate {
  String? documentId; // Optional parameter for the document ID
  bool completed;
  String date;
  List<String> players;
  int? gamesPlayed;
  List<Frame>? frames;
  List<String>? frameIds;

  GameDate({
    this.documentId, // Optional parameter for the document ID
    required this.completed,
    required this.date,
    required this.players,
    this.gamesPlayed,
    this.frames,
    this.frameIds,
  });

  Map<String, dynamic> toJson() {
    return {
      'completed': completed,
      'date': date,
      'players': players,
      'gamesPlayed': gamesPlayed,
      'frames': frames?.map((frame) => frame).toList() ?? [],
    };
  }

  factory GameDate.fromJson(Map<String, dynamic> json) {
    return GameDate(
      completed: json['completed'],
      date: json['date'],
      players: List<String>.from(json['players']),
      frameIds: (json['frameIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      frames: List<Frame>.from(json['frames'] ?? []),
      gamesPlayed: json['frames']?.length ?? 0,
    );
  }

  Future<List<Frame>> fetchFrames() async {
    List<Frame> frames = [];
    for (String frameId in frameIds ?? []) {
      DocumentSnapshot frameSnapshot = await FirebaseFirestore.instance
          .collection('frames')
          .doc(frameId)
          .get();
      var frameData = frameSnapshot.data() as Map<String, dynamic>;

      // Fetch playerOneBreaks details
      List<Map<String, dynamic>> playerOneBreaks = [];
      for (String breakId in frameData['playerOneBreaks'] ?? []) {
        DocumentSnapshot breakSnapshot = await FirebaseFirestore.instance
            .collection('breaks')
            .doc(breakId)
            .get();
        playerOneBreaks.add(breakSnapshot.data() as Map<String, dynamic>);
      }

      // Fetch playerTwoBreaks details
      List<Map<String, dynamic>> playerTwoBreaks = [];
      for (String breakId in frameData['playerTwoBreaks'] ?? []) {
        DocumentSnapshot breakSnapshot = await FirebaseFirestore.instance
            .collection('breaks')
            .doc(breakId)
            .get();
        playerTwoBreaks.add(breakSnapshot.data() as Map<String, dynamic>);
      }

      var frame = Frame.fromJson(frameData);
      frame.docReference = frameId;
      frame.playerOneBreakData!.addAll(playerOneBreaks);
      frame.playerTwoBreakData!.addAll(playerTwoBreaks);

      frames.add(frame);
    }

    return frames;
  }

  @override
  String toString() {
    return 'GameDate{completed: $completed, date: $date, players: $players, gamesPlayed: $gamesPlayed, frames: $frames}';
  }
}
