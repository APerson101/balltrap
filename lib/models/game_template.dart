import 'dart:convert';

class GameTemplate {
  String name;
  bool dtl;
  String id;
  List<int> doublesSim;
  List<String> letters;
  List<int> playerMovements;
  bool compak;
  List<int>doublesCDF;
  GameTemplate({
    required this.name,
    required this.dtl,
    required this.letters,
    required this.playerMovements,
    required this.compak,
    required this.doublesSim,
    required this.doublesCDF,
    required this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'doubleIndexes': doublesSim,
      'id': id,
      'dtl': dtl,
      'compak': compak,
      'letters': letters,
      'movements': playerMovements,
      'doublesCDF':doublesCDF
    };
  }

  factory GameTemplate.fromMap(Map<String, dynamic> map) {
    return GameTemplate(
      name: map['name'] ?? '',
      id: map['id'] ?? '',
      compak: map['compak'] ?? false,
      playerMovements: List<int>.from(map['movements']),
      letters: List<String>.from(map['letters']),
      dtl: map['dtl'] ?? false,
      doublesSim: List<int>.from(map['doublesSim']),
      doublesCDF: List<int>.from(map['doublesCDF'])
    );
  }

  String toJson() => json.encode(toMap());

  factory GameTemplate.fromJson(String source) =>
      GameTemplate.fromMap(json.decode(source));
}
