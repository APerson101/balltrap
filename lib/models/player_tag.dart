import 'dart:convert';

class PlayerDetails {
  String id;
  String name;
  int subscriptionsLeft;
  PlayerDetails(
      {required this.id, required this.name, required this.subscriptionsLeft});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'subscriptionsLeft': subscriptionsLeft,
    };
  }

  factory PlayerDetails.fromMap(Map<String, dynamic> map) {
    return PlayerDetails(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      subscriptionsLeft: map['subscriptionsLeft']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory PlayerDetails.fromJson(String source) =>
      PlayerDetails.fromMap(json.decode(source));
}
