import 'dart:convert';

class GameSession {
  String id;
  List<Map<String, dynamic>> playersScores;
  String date;
  int hit;
  int miss;
  int broken;
  String template;
  GameSession({
    required this.id,
    required this.date,
    required this.hit,
    required this.miss,
    required this.template,
    required this.broken,
    required this.playersScores,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'playersScores': playersScores,
      'date': date,
      'hit': hit,
      "miss": miss,
      'template': template,
      'broken': broken,
    };
  }

  factory GameSession.fromMap(Map<String, dynamic> map) {
    return GameSession(
      id: map['id'] ?? '',
      playersScores: List<Map<String, dynamic>>.from(map['playersScores']?.map(
          (x) => {'name': x['name'], 'score': x['score'], 'id': x['id']})),
      date: map['date'] ?? '',
      hit: map["hit"],
      miss: map["miss"],
      template: map['template'] ?? '',
      broken: map['broken']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory GameSession.fromJson(String source) =>
      GameSession.fromMap(json.decode(source));
}
