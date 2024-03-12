import 'dart:convert';

class GameTemplate {
  String name;
  bool dtl;
  String id;
  List<int> doubleIndexes;
  List<String> letters;
  List<int> playerMovements;
  GameTemplate({
    required this.name,
    required this.dtl,
    required this.letters,
    required this.playerMovements,
    required this.doubleIndexes,
    required this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'doubleIndexes': doubleIndexes,
      'id': id,
      'dtl': dtl,
      'letters': letters,
      'movements': playerMovements
    };
  }

  factory GameTemplate.fromMap(Map<String, dynamic> map) {
    return GameTemplate(
      name: map['name'] ?? '',
      id: map['id'] ?? '',
      playerMovements: List<int>.from(map['movements']),
      letters: List<String>.from(map['letters']),
      dtl: map['dtl'] ?? false,
      doubleIndexes: List<int>.from(map['doubleIndexes']),
    );
  }

  String toJson() => json.encode(toMap());

  factory GameTemplate.fromJson(String source) =>
      GameTemplate.fromMap(json.decode(source));
}
