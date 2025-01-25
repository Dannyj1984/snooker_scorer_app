import 'package:snooker_scorer/model/frame_score.dart';

class Frame {
  final int id;
  final int frame;
  final FrameScore? scores;
  final bool inProgress;

  Frame({
    required this.id,
    required this.frame,
    required this.inProgress,
    this.scores,
  });

  factory Frame.fromJson(Map<String, dynamic> json) {
    return Frame(
      id: json['id'],
      inProgress: json['inProgress'],
      frame: json['frame'],
      scores: json['scores'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'frame': frame,
      'scores': scores,
      'inProgress': inProgress
    };
  }
}
