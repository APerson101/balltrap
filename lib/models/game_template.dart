import 'dart:convert';

class GameTemplate {
  String name;
  String id;
  List<int> doubleIndexes;
  GameTemplate({
    required this.name,
    required this.doubleIndexes,
    required this.id,
  });

  Map<String, dynamic> toMap() {
    return {'name': name, 'doubleIndexes': doubleIndexes, 'id': id};
  }

  factory GameTemplate.fromMap(Map<String, dynamic> map) {
    return GameTemplate(
      name: map['name'] ?? '',
      id: map['id'] ?? '',
      doubleIndexes: List<int>.from(map['doubleIndexes']),
    );
  }

  String toJson() => json.encode(toMap());

  factory GameTemplate.fromJson(String source) =>
      GameTemplate.fromMap(json.decode(source));
}
