import 'dart:convert';

class GameSession {
  String id;
  List<Map<String, dynamic>> playersScores;
  String date;
  int tablet;
  int broken;
  GameSession({
    required this.id,
    required this.date,
    required this.tablet,
    required this.broken,
    required this.playersScores,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'playersScores': playersScores,
      'date': date,
      'tablet': tablet,
      'broken': broken,
    };
  }

  factory GameSession.fromMap(Map<String, dynamic> map) {
    return GameSession(
      id: map['id'] ?? '',
      playersScores: List<Map<String, dynamic>>.from(map['playersScores']
          ?.map((x) => {'name': x['name'], 'score': x['score']})),
      date: map['date'] ?? '',
      tablet: map['tablet']?.toInt() ?? 0,
      broken: map['broken']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory GameSession.fromJson(String source) =>
      GameSession.fromMap(json.decode(source));
}
