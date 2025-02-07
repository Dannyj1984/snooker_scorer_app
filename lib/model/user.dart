class User {
  final String id;
  final String name;
  final int? gamesPlayed;
  final int? gamesWon;
  final int? gamesLost;
  final int? totalScore;

  User({
    required this.id,
    required this.name,
    this.gamesPlayed,
    this.gamesWon,
    this.gamesLost,
    this.totalScore,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      gamesPlayed: json['gamesPlayed'],
      gamesWon: json['gamesWon'],
      gamesLost: json['gamesLost'],
      totalScore: json['totalScore'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'gamesPlayed': gamesPlayed,
      'gamesWon': gamesWon,
      'gamesLost': gamesLost,
      'totalScore': totalScore,
    };
  }
}
